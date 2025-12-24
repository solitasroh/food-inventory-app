import '../../features/inventory/domain/entities/enums.dart';

/// 식품 서브카테고리 모델
/// 바코드 없는 식품의 유통기한 자동 추천에 사용
class FoodSubCategory {
  final String id;
  final String name;
  final FoodCategory parentCategory;
  final Map<StorageLocation, int> shelfLifeDays; // 저장위치별 보관일수
  final List<String> keywords; // 검색/자동완성용 키워드

  const FoodSubCategory({
    required this.id,
    required this.name,
    required this.parentCategory,
    required this.shelfLifeDays,
    this.keywords = const [],
  });

  /// 특정 저장 위치의 보관 기간 반환
  int? getShelfLife(StorageLocation location) => shelfLifeDays[location];

  /// 모든 키워드 (이름 포함)
  List<String> get allKeywords => [name, ...keywords];

  /// 검색어와 매칭되는지 확인
  bool matches(String query) {
    final lowerQuery = query.toLowerCase();
    return allKeywords.any((k) => k.toLowerCase().contains(lowerQuery));
  }
}

/// 보관기간 추천 결과
class ShelfLifeRecommendation {
  final int days;
  final String reason;
  final double confidence; // 0.0 ~ 1.0
  final FoodSubCategory? matchedSubCategory;

  const ShelfLifeRecommendation({
    required this.days,
    required this.reason,
    this.confidence = 0.5,
    this.matchedSubCategory,
  });

  DateTime get expirationDate =>
      DateTime.now().add(Duration(days: days));
}
