/// 쇼핑 아이템 우선순위
enum ShoppingPriority {
  high('높음'),
  medium('보통'),
  low('낮음');

  final String label;
  const ShoppingPriority(this.label);
}

/// 쇼핑 아이템 추가 경로
enum SuggestionSource {
  manual('수동 추가'),
  lowStock('재고 부족'),
  expired('만료/삭제'),
  frequent('자주 구매');

  final String label;
  const SuggestionSource(this.label);
}
