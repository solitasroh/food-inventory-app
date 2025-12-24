import '../data/food_subcategory.dart';
import '../data/food_subcategories_data.dart';
import '../../features/inventory/domain/entities/enums.dart';

/// 보관기간 추천 서비스
/// 식품 이름과 저장 위치를 기반으로 유통기한을 자동 추천
class ShelfLifeService {
  /// 식품 이름으로 서브카테고리 검색
  List<FoodSubCategory> searchSubCategories(String query) {
    if (query.isEmpty) return [];

    final lowerQuery = query.toLowerCase();
    final results = <FoodSubCategory>[];

    for (final subCat in foodSubCategories) {
      if (subCat.matches(lowerQuery)) {
        results.add(subCat);
      }
    }

    // 이름이 정확히 일치하는 것을 먼저 정렬
    results.sort((a, b) {
      final aExact = a.name.toLowerCase() == lowerQuery ? 0 : 1;
      final bExact = b.name.toLowerCase() == lowerQuery ? 0 : 1;
      if (aExact != bExact) return aExact - bExact;

      // 이름에 포함되는 것을 그 다음
      final aContains = a.name.toLowerCase().contains(lowerQuery) ? 0 : 1;
      final bContains = b.name.toLowerCase().contains(lowerQuery) ? 0 : 1;
      return aContains - bContains;
    });

    return results.take(10).toList();
  }

  /// 정확한 서브카테고리 찾기
  FoodSubCategory? findExactSubCategory(String name) {
    final lowerName = name.toLowerCase();
    for (final subCat in foodSubCategories) {
      if (subCat.name.toLowerCase() == lowerName) {
        return subCat;
      }
    }
    return null;
  }

  /// 퍼지 매칭으로 가장 유사한 서브카테고리 찾기
  FoodSubCategory? findBestMatch(String name) {
    final lowerName = name.toLowerCase();

    // 1. 정확한 이름 매칭
    final exact = findExactSubCategory(name);
    if (exact != null) return exact;

    // 2. 키워드 매칭
    FoodSubCategory? bestMatch;
    int bestScore = 0;

    for (final subCat in foodSubCategories) {
      for (final keyword in subCat.allKeywords) {
        final lowerKeyword = keyword.toLowerCase();

        // 완전 포함
        if (lowerName.contains(lowerKeyword)) {
          final score = lowerKeyword.length * 2;
          if (score > bestScore) {
            bestScore = score;
            bestMatch = subCat;
          }
        }
        // 키워드가 이름을 포함
        else if (lowerKeyword.contains(lowerName) && lowerName.length >= 2) {
          final score = lowerName.length;
          if (score > bestScore) {
            bestScore = score;
            bestMatch = subCat;
          }
        }
      }
    }

    return bestMatch;
  }

  /// 보관기간 추천
  ShelfLifeRecommendation? recommend({
    required String name,
    required StorageLocation location,
    FoodCategory? category,
  }) {
    // 1. 서브카테고리 매칭 시도
    final subCat = findBestMatch(name);
    if (subCat != null) {
      final days = subCat.getShelfLife(location);
      if (days != null) {
        return ShelfLifeRecommendation(
          days: days,
          reason: '${subCat.name}의 ${location.label} 보관 기준',
          confidence: 0.9,
          matchedSubCategory: subCat,
        );
      }

      // 저장 위치에 해당하는 보관기간이 없으면 다른 위치 추천
      final availableLocations = subCat.shelfLifeDays.keys.toList();
      if (availableLocations.isNotEmpty) {
        final altLocation = availableLocations.first;
        final altDays = subCat.shelfLifeDays[altLocation]!;
        return ShelfLifeRecommendation(
          days: altDays,
          reason: '${subCat.name}은 ${altLocation.label} 보관을 권장합니다',
          confidence: 0.7,
          matchedSubCategory: subCat,
        );
      }
    }

    // 2. 카테고리 기본값 사용
    if (category != null) {
      final defaults = categoryDefaults[category];
      if (defaults != null) {
        final days = defaults[location];
        if (days != null) {
          return ShelfLifeRecommendation(
            days: days,
            reason: '${category.label} 평균 보관 기간',
            confidence: 0.5,
          );
        }

        // 카테고리에 해당 저장위치가 없으면 첫 번째 위치 사용
        if (defaults.isNotEmpty) {
          final altLocation = defaults.keys.first;
          return ShelfLifeRecommendation(
            days: defaults[altLocation]!,
            reason: '${category.label}은 ${altLocation.label} 보관을 권장합니다',
            confidence: 0.4,
          );
        }
      }
    }

    // 3. 기본값 (매칭 실패)
    return ShelfLifeRecommendation(
      days: 7,
      reason: '일반적인 보관 기간',
      confidence: 0.2,
    );
  }

  /// 자동완성용 식품명 제안
  List<String> getSuggestions(String query, {int limit = 10}) {
    if (query.isEmpty) return [];

    final suggestions = <String>{};
    final lowerQuery = query.toLowerCase();

    for (final subCat in foodSubCategories) {
      // 이름 매칭
      if (subCat.name.toLowerCase().contains(lowerQuery)) {
        suggestions.add(subCat.name);
      }
      // 키워드 매칭
      for (final keyword in subCat.keywords) {
        if (keyword.toLowerCase().contains(lowerQuery)) {
          suggestions.add(keyword);
        }
      }
    }

    return suggestions.take(limit).toList();
  }

  /// 특정 카테고리의 서브카테고리 목록
  List<FoodSubCategory> getSubCategoriesByCategory(FoodCategory category) {
    return foodSubCategories
        .where((s) => s.parentCategory == category)
        .toList();
  }

  /// 저장 위치 권장 여부 확인
  bool isRecommendedLocation(String name, StorageLocation location) {
    final subCat = findBestMatch(name);
    if (subCat == null) return true; // 매칭 안되면 모든 위치 허용

    return subCat.shelfLifeDays.containsKey(location);
  }

  /// 권장 저장 위치 목록
  List<StorageLocation> getRecommendedLocations(String name) {
    final subCat = findBestMatch(name);
    if (subCat == null) return StorageLocation.values.toList();

    return subCat.shelfLifeDays.keys.toList();
  }
}
