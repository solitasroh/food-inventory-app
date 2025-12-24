import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../inventory/domain/entities/enums.dart';
import 'shopping_enums.dart';

part 'shopping_item.freezed.dart';
part 'shopping_item.g.dart';

@freezed
class ShoppingItem with _$ShoppingItem {
  const factory ShoppingItem({
    required String id,
    required String name,
    required FoodCategory category,
    required double quantity,
    required String unit,
    @Default(ShoppingPriority.medium) ShoppingPriority priority,
    @Default(false) bool isCompleted,
    String? notes,
    String? linkedFoodItemId,
    @Default(SuggestionSource.manual) SuggestionSource suggestedBy,
    required DateTime createdAt,
    DateTime? completedAt,
  }) = _ShoppingItem;

  factory ShoppingItem.fromJson(Map<String, dynamic> json) =>
      _$ShoppingItemFromJson(json);
}
