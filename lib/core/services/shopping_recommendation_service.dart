import '../../features/inventory/domain/entities/food_item.dart';
import '../../features/shopping_list/domain/entities/shopping_enums.dart';

/// 쇼핑 추천 서비스
/// 재고 부족, 자주 구매 품목 등을 분석하여 추천
class ShoppingRecommendationService {
  /// 재고 부족 기준 수량 (기본값)
  static const Map<String, double> _defaultMinQuantities = {
    '개': 2,
    '팩': 1,
    'L': 1,
    'ml': 500,
    'kg': 0.5,
    'g': 200,
    '병': 1,
    '봉': 1,
    '박스': 1,
  };

  /// 재고 부족 아이템 감지
  List<LowStockRecommendation> detectLowStock(List<FoodItem> items) {
    final recommendations = <LowStockRecommendation>[];

    for (final item in items) {
      final minQuantity = _getMinQuantity(item.unit);
      if (item.quantity <= minQuantity) {
        recommendations.add(LowStockRecommendation(
          item: item,
          currentQuantity: item.quantity,
          recommendedQuantity: _getRecommendedQuantity(item.unit),
          priority: item.quantity <= minQuantity / 2
              ? ShoppingPriority.high
              : ShoppingPriority.medium,
        ));
      }
    }

    // 우선순위 순으로 정렬
    recommendations.sort((a, b) => a.priority.index.compareTo(b.priority.index));

    return recommendations;
  }

  /// 만료 임박 아이템 감지 (쇼핑리스트 추천용)
  List<FoodItem> detectExpiringItems(List<FoodItem> items, {int days = 3}) {
    final now = DateTime.now();
    final threshold = now.add(Duration(days: days));

    return items.where((item) {
      if (item.expirationDate == null) return false;
      return item.expirationDate!.isAfter(now) &&
          item.expirationDate!.isBefore(threshold);
    }).toList()
      ..sort((a, b) => a.expirationDate!.compareTo(b.expirationDate!));
  }

  /// 단위별 최소 수량 반환
  double _getMinQuantity(String unit) {
    return _defaultMinQuantities[unit] ?? 1;
  }

  /// 단위별 추천 구매 수량 반환
  double _getRecommendedQuantity(String unit) {
    switch (unit) {
      case '개':
        return 5;
      case '팩':
        return 2;
      case 'L':
        return 2;
      case 'ml':
        return 1000;
      case 'kg':
        return 1;
      case 'g':
        return 500;
      case '병':
        return 2;
      case '봉':
        return 2;
      case '박스':
        return 1;
      default:
        return 2;
    }
  }
}

/// 재고 부족 추천 모델
class LowStockRecommendation {
  final FoodItem item;
  final double currentQuantity;
  final double recommendedQuantity;
  final ShoppingPriority priority;

  const LowStockRecommendation({
    required this.item,
    required this.currentQuantity,
    required this.recommendedQuantity,
    required this.priority,
  });

  /// 추천 메시지 생성
  String get message {
    final remaining = currentQuantity.toStringAsFixed(
      currentQuantity == currentQuantity.roundToDouble() ? 0 : 1,
    );
    return '${item.name}이(가) $remaining${item.unit} 남았습니다';
  }
}
