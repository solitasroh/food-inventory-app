import 'dart:convert';
import 'package:http/http.dart' as http;

/// 푸드QR API 응답 모델
class FoodQRProduct {
  final String? barcode;
  final String? name;              // 제품명
  final String? manufacturer;      // 제조사
  final String? category;          // 식품유형
  final DateTime? expirationDate;  // 소비기한
  final String? storageMethod;     // 보관방법
  final String? ingredients;       // 원재료
  final List<String> allergens;    // 알레르기 유발물질
  final NutritionInfo? nutrition;  // 영양정보
  final String? imageUrl;          // 이미지 URL

  const FoodQRProduct({
    this.barcode,
    this.name,
    this.manufacturer,
    this.category,
    this.expirationDate,
    this.storageMethod,
    this.ingredients,
    this.allergens = const [],
    this.nutrition,
    this.imageUrl,
  });

  factory FoodQRProduct.fromJson(Map<String, dynamic> json) {
    // 소비기한 파싱
    DateTime? expDate;
    final expStr = json['CNSMP_PERD'] as String?;
    if (expStr != null && expStr.isNotEmpty) {
      expDate = DateTime.tryParse(expStr);
    }

    // 알레르기 정보 파싱
    List<String> allergenList = [];
    final allergenStr = json['ALLRGY_INFO'] as String?;
    if (allergenStr != null && allergenStr.isNotEmpty) {
      allergenList = allergenStr.split(',').map((e) => e.trim()).toList();
    }

    // 영양정보 파싱
    NutritionInfo? nutritionInfo;
    if (json['NUTR_INFO'] != null) {
      nutritionInfo = NutritionInfo.fromJson(json['NUTR_INFO']);
    }

    return FoodQRProduct(
      barcode: json['BRCD_NO'] as String?,
      name: json['PRDLST_NM'] as String?,
      manufacturer: json['BSSH_NM'] as String?,
      category: json['PRDLST_DCNM'] as String?,
      expirationDate: expDate,
      storageMethod: json['STRG_MTH'] as String?,
      ingredients: json['RAWMTRL_NM'] as String?,
      allergens: allergenList,
      nutrition: nutritionInfo,
      imageUrl: json['IMG_URL'] as String?,
    );
  }

  bool get hasData => name != null;
  bool get hasExpirationDate => expirationDate != null;
}

/// 영양정보 모델
class NutritionInfo {
  final double? calories;      // 열량 (kcal)
  final double? carbohydrate;  // 탄수화물 (g)
  final double? protein;       // 단백질 (g)
  final double? fat;           // 지방 (g)
  final double? sugar;         // 당류 (g)
  final double? sodium;        // 나트륨 (mg)
  final double? saturatedFat;  // 포화지방 (g)
  final double? cholesterol;   // 콜레스테롤 (mg)

  const NutritionInfo({
    this.calories,
    this.carbohydrate,
    this.protein,
    this.fat,
    this.sugar,
    this.sodium,
    this.saturatedFat,
    this.cholesterol,
  });

  factory NutritionInfo.fromJson(Map<String, dynamic> json) {
    return NutritionInfo(
      calories: _parseDouble(json['KCAL']),
      carbohydrate: _parseDouble(json['CARBO']),
      protein: _parseDouble(json['PROT']),
      fat: _parseDouble(json['FAT']),
      sugar: _parseDouble(json['SUGAR']),
      sodium: _parseDouble(json['SODIUM']),
      saturatedFat: _parseDouble(json['SAT_FAT']),
      cholesterol: _parseDouble(json['CHOL']),
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

/// 푸드QR API 서비스
/// API 문서: https://portal.foodqr.kr/dvlpr/guide/introduceApiView.do
class FoodQRService {
  static const String _baseUrl = 'https://api.foodqr.kr/api/v1';

  final String? _apiKey;

  FoodQRService({String? apiKey}) : _apiKey = apiKey;

  /// API 키가 설정되어 있는지 확인
  bool get isConfigured => _apiKey != null && _apiKey!.isNotEmpty;

  /// 바코드로 제품 정보 조회
  Future<FoodQRProduct?> getProductByBarcode(String barcode) async {
    if (!isConfigured) {
      return null;
    }

    try {
      final url = Uri.parse('$_baseUrl/product/$barcode');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final data = json['data'] as Map<String, dynamic>?;
        if (data != null) {
          return FoodQRProduct.fromJson(data);
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// QR 코드 데이터로 제품 정보 조회
  Future<FoodQRProduct?> getProductByQRCode(String qrData) async {
    if (!isConfigured) {
      return null;
    }

    try {
      final url = Uri.parse('$_baseUrl/product/qr');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'qr_data': qrData}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final data = json['data'] as Map<String, dynamic>?;
        if (data != null) {
          return FoodQRProduct.fromJson(data);
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// 알레르기 정보 조회
  Future<List<String>> getAllergens(String barcode) async {
    final product = await getProductByBarcode(barcode);
    return product?.allergens ?? [];
  }
}
