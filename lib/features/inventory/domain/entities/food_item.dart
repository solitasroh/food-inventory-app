import 'package:freezed_annotation/freezed_annotation.dart';

import 'enums.dart';

part 'food_item.freezed.dart';
part 'food_item.g.dart';

@freezed
class FoodItem with _$FoodItem {
  const factory FoodItem({
    required String id,
    required String name,
    String? barcode,
    required FoodCategory category,
    required StorageLocation location,
    required double quantity,
    required String unit,
    DateTime? expirationDate,
    required DateTime purchaseDate,
    DateTime? openedDate,
    double? price,
    String? imageUrl,
    String? notes,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _FoodItem;

  factory FoodItem.fromJson(Map<String, dynamic> json) =>
      _$FoodItemFromJson(json);
}
