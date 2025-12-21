// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FoodItemImpl _$$FoodItemImplFromJson(Map<String, dynamic> json) =>
    _$FoodItemImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      barcode: json['barcode'] as String?,
      category: $enumDecode(_$FoodCategoryEnumMap, json['category']),
      location: $enumDecode(_$StorageLocationEnumMap, json['location']),
      quantity: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      expirationDate: json['expirationDate'] == null
          ? null
          : DateTime.parse(json['expirationDate'] as String),
      purchaseDate: DateTime.parse(json['purchaseDate'] as String),
      openedDate: json['openedDate'] == null
          ? null
          : DateTime.parse(json['openedDate'] as String),
      price: (json['price'] as num?)?.toDouble(),
      imageUrl: json['imageUrl'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$FoodItemImplToJson(_$FoodItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'barcode': instance.barcode,
      'category': _$FoodCategoryEnumMap[instance.category]!,
      'location': _$StorageLocationEnumMap[instance.location]!,
      'quantity': instance.quantity,
      'unit': instance.unit,
      'expirationDate': instance.expirationDate?.toIso8601String(),
      'purchaseDate': instance.purchaseDate.toIso8601String(),
      'openedDate': instance.openedDate?.toIso8601String(),
      'price': instance.price,
      'imageUrl': instance.imageUrl,
      'notes': instance.notes,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$FoodCategoryEnumMap = {
  FoodCategory.vegetables: 'vegetables',
  FoodCategory.fruits: 'fruits',
  FoodCategory.meat: 'meat',
  FoodCategory.seafood: 'seafood',
  FoodCategory.dairy: 'dairy',
  FoodCategory.grains: 'grains',
  FoodCategory.seasonings: 'seasonings',
  FoodCategory.processed: 'processed',
  FoodCategory.beverages: 'beverages',
  FoodCategory.other: 'other',
};

const _$StorageLocationEnumMap = {
  StorageLocation.refrigerator: 'refrigerator',
  StorageLocation.freezer: 'freezer',
  StorageLocation.pantry: 'pantry',
  StorageLocation.other: 'other',
};
