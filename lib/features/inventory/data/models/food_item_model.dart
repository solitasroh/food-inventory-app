import '../../domain/entities/enums.dart';
import '../../domain/entities/food_item.dart';

class FoodItemModel {
  int id = 0;
  late String uid;
  late String name;
  String? barcode;
  late FoodCategory category;
  late StorageLocation location;
  late double quantity;
  late String unit;
  DateTime? expirationDate;
  late DateTime purchaseDate;
  DateTime? openedDate;
  double? price;
  String? imageUrl;
  String? notes;
  late DateTime createdAt;
  DateTime? updatedAt;

  FoodItemModel();

  // Entity -> Model
  static FoodItemModel fromEntity(FoodItem entity) {
    return FoodItemModel()
      ..uid = entity.id
      ..name = entity.name
      ..barcode = entity.barcode
      ..category = entity.category
      ..location = entity.location
      ..quantity = entity.quantity
      ..unit = entity.unit
      ..expirationDate = entity.expirationDate
      ..purchaseDate = entity.purchaseDate
      ..openedDate = entity.openedDate
      ..price = entity.price
      ..imageUrl = entity.imageUrl
      ..notes = entity.notes
      ..createdAt = entity.createdAt
      ..updatedAt = entity.updatedAt;
  }

  // Model -> Entity
  FoodItem toEntity() {
    return FoodItem(
      id: uid,
      name: name,
      barcode: barcode,
      category: category,
      location: location,
      quantity: quantity,
      unit: unit,
      expirationDate: expirationDate,
      purchaseDate: purchaseDate,
      openedDate: openedDate,
      price: price,
      imageUrl: imageUrl,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
