import 'food_safety_korea_service.dart';
import 'food_qr_service.dart';
import 'open_food_facts_service.dart';
import 'shelf_life_service.dart';
import '../../features/inventory/domain/entities/enums.dart';

/// 데이터 출처
enum DataSource {
  foodSafetyKorea('식품안전나라'),
  foodQR('푸드QR'),
  openFoodFacts('Open Food Facts'),
  shelfLifeDb('보관기간 DB'),
  manual('직접 입력');

  final String label;
  const DataSource(this.label);
}

/// 통합 제품 조회 결과
class ProductLookupResult {
  final String barcode;

  // 기본 정보
  final String? name;
  final String? brand;
  final String? category;
  final String? quantity;
  final String? imageUrl;

  // 유통기한 관련
  final int? shelfLifeDays;        // 유통기한 일수 (I2570)
  final DateTime? expirationDate;  // 소비기한 (푸드QR)

  // 추가 정보
  final List<String> allergens;
  final String? ingredients;
  final String? storageMethod;

  // 메타 정보
  final DataSource primarySource;
  final List<DataSource> sources;
  final double confidence;

  const ProductLookupResult({
    required this.barcode,
    this.name,
    this.brand,
    this.category,
    this.quantity,
    this.imageUrl,
    this.shelfLifeDays,
    this.expirationDate,
    this.allergens = const [],
    this.ingredients,
    this.storageMethod,
    required this.primarySource,
    this.sources = const [],
    this.confidence = 0.5,
  });

  bool get hasData => name != null;
  bool get hasShelfLife => shelfLifeDays != null || expirationDate != null;

  /// 유통기한 계산 (구매일 기준)
  DateTime? calculateExpirationDate([DateTime? purchaseDate]) {
    // 1. 소비기한이 직접 있으면 사용
    if (expirationDate != null) {
      return expirationDate;
    }

    // 2. 유통기한 일수가 있으면 계산
    if (shelfLifeDays != null) {
      final baseDate = purchaseDate ?? DateTime.now();
      return baseDate.add(Duration(days: shelfLifeDays!));
    }

    return null;
  }

  /// 복사본 생성
  ProductLookupResult copyWith({
    String? barcode,
    String? name,
    String? brand,
    String? category,
    String? quantity,
    String? imageUrl,
    int? shelfLifeDays,
    DateTime? expirationDate,
    List<String>? allergens,
    String? ingredients,
    String? storageMethod,
    DataSource? primarySource,
    List<DataSource>? sources,
    double? confidence,
  }) {
    return ProductLookupResult(
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
      shelfLifeDays: shelfLifeDays ?? this.shelfLifeDays,
      expirationDate: expirationDate ?? this.expirationDate,
      allergens: allergens ?? this.allergens,
      ingredients: ingredients ?? this.ingredients,
      storageMethod: storageMethod ?? this.storageMethod,
      primarySource: primarySource ?? this.primarySource,
      sources: sources ?? this.sources,
      confidence: confidence ?? this.confidence,
    );
  }
}

/// 통합 제품 조회 서비스
/// 다중 API 폴백 전략: I2570 → 푸드QR → Open Food Facts
class ProductLookupService {
  final FoodSafetyKoreaService _foodSafetyService;
  final FoodQRService _foodQRService;
  final OpenFoodFactsService _openFoodFactsService;
  final ShelfLifeService _shelfLifeService;

  ProductLookupService({
    FoodSafetyKoreaService? foodSafetyService,
    FoodQRService? foodQRService,
    OpenFoodFactsService? openFoodFactsService,
    ShelfLifeService? shelfLifeService,
  })  : _foodSafetyService = foodSafetyService ?? FoodSafetyKoreaService(),
        _foodQRService = foodQRService ?? FoodQRService(),
        _openFoodFactsService = openFoodFactsService ?? OpenFoodFactsService(),
        _shelfLifeService = shelfLifeService ?? ShelfLifeService();

  /// 바코드로 제품 정보 조회 (다중 API 폴백)
  Future<ProductLookupResult> lookupByBarcode(String barcode) async {
    final sources = <DataSource>[];
    ProductLookupResult? result;

    // 1차: 식품안전나라 (유통기한 정보 우선)
    if (_foodSafetyService.isConfigured) {
      final fsProduct = await _foodSafetyService.getProductByBarcode(barcode);
      if (fsProduct != null && fsProduct.hasData) {
        sources.add(DataSource.foodSafetyKorea);
        result = ProductLookupResult(
          barcode: barcode,
          name: fsProduct.name,
          brand: fsProduct.manufacturer,
          category: fsProduct.category,
          shelfLifeDays: fsProduct.shelfLifeDays,
          primarySource: DataSource.foodSafetyKorea,
          confidence: fsProduct.hasShelfLife ? 0.9 : 0.7,
        );

        // 유통기한 정보가 있으면 바로 반환
        if (fsProduct.hasShelfLife) {
          return result.copyWith(sources: sources);
        }
      }
    }

    // 2차: 푸드QR
    if (_foodQRService.isConfigured) {
      final fqProduct = await _foodQRService.getProductByBarcode(barcode);
      if (fqProduct != null && fqProduct.hasData) {
        sources.add(DataSource.foodQR);

        if (result == null) {
          result = ProductLookupResult(
            barcode: barcode,
            name: fqProduct.name,
            brand: fqProduct.manufacturer,
            category: fqProduct.category,
            expirationDate: fqProduct.expirationDate,
            allergens: fqProduct.allergens,
            ingredients: fqProduct.ingredients,
            storageMethod: fqProduct.storageMethod,
            imageUrl: fqProduct.imageUrl,
            primarySource: DataSource.foodQR,
            confidence: fqProduct.hasExpirationDate ? 0.95 : 0.8,
          );
        } else {
          // 기존 결과에 푸드QR 정보 병합
          result = result.copyWith(
            expirationDate: fqProduct.expirationDate ?? result.expirationDate,
            allergens: fqProduct.allergens.isNotEmpty
                ? fqProduct.allergens
                : result.allergens,
            ingredients: fqProduct.ingredients ?? result.ingredients,
            storageMethod: fqProduct.storageMethod ?? result.storageMethod,
            imageUrl: fqProduct.imageUrl ?? result.imageUrl,
          );
        }

        // 유통기한 정보가 있으면 바로 반환
        if (fqProduct.hasExpirationDate) {
          return result.copyWith(sources: sources);
        }
      }
    }

    // 3차: Open Food Facts
    final offProduct = await _openFoodFactsService.getProductByBarcode(barcode);
    if (offProduct != null && offProduct.hasData) {
      sources.add(DataSource.openFoodFacts);

      if (result == null) {
        result = ProductLookupResult(
          barcode: barcode,
          name: offProduct.displayName,
          brand: offProduct.brand,
          category: offProduct.categories,
          quantity: offProduct.quantity,
          imageUrl: offProduct.imageUrl,
          primarySource: DataSource.openFoodFacts,
          confidence: 0.6,
        );
      } else {
        // 기존 결과에 Open Food Facts 정보 병합
        result = result.copyWith(
          quantity: offProduct.quantity ?? result.quantity,
          imageUrl: offProduct.imageUrl ?? result.imageUrl,
        );
      }
    }

    // 최종 결과 반환
    if (result != null) {
      return result.copyWith(sources: sources);
    }

    // 모든 API에서 결과 없음
    return ProductLookupResult(
      barcode: barcode,
      primarySource: DataSource.manual,
      sources: sources,
      confidence: 0.0,
    );
  }

  /// 이름으로 보관기간 추천 (바코드 없는 식품용)
  Future<ProductLookupResult> lookupByName({
    required String name,
    required StorageLocation location,
    FoodCategory? category,
  }) async {
    final recommendation = _shelfLifeService.recommend(
      name: name,
      location: location,
      category: category,
    );

    return ProductLookupResult(
      barcode: '',
      name: name,
      category: category?.label,
      shelfLifeDays: recommendation?.days,
      primarySource: DataSource.shelfLifeDb,
      sources: [DataSource.shelfLifeDb],
      confidence: recommendation?.confidence ?? 0.2,
    );
  }

  /// 자동완성용 식품명 제안
  List<String> getSuggestions(String query) {
    return _shelfLifeService.getSuggestions(query);
  }

  /// 저장 위치별 보관기간 조회
  Map<StorageLocation, int> getShelfLifeByLocation(String name) {
    final subCat = _shelfLifeService.findBestMatch(name);
    return subCat?.shelfLifeDays ?? {};
  }
}
