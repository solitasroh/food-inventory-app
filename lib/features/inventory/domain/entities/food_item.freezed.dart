// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FoodItem _$FoodItemFromJson(Map<String, dynamic> json) {
  return _FoodItem.fromJson(json);
}

/// @nodoc
mixin _$FoodItem {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get barcode => throw _privateConstructorUsedError;
  FoodCategory get category => throw _privateConstructorUsedError;
  StorageLocation get location => throw _privateConstructorUsedError;
  double get quantity => throw _privateConstructorUsedError;
  String get unit => throw _privateConstructorUsedError;
  DateTime? get expirationDate => throw _privateConstructorUsedError;
  DateTime get purchaseDate => throw _privateConstructorUsedError;
  DateTime? get openedDate => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FoodItemCopyWith<FoodItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FoodItemCopyWith<$Res> {
  factory $FoodItemCopyWith(FoodItem value, $Res Function(FoodItem) then) =
      _$FoodItemCopyWithImpl<$Res, FoodItem>;
  @useResult
  $Res call(
      {String id,
      String name,
      String? barcode,
      FoodCategory category,
      StorageLocation location,
      double quantity,
      String unit,
      DateTime? expirationDate,
      DateTime purchaseDate,
      DateTime? openedDate,
      double? price,
      String? imageUrl,
      String? notes,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$FoodItemCopyWithImpl<$Res, $Val extends FoodItem>
    implements $FoodItemCopyWith<$Res> {
  _$FoodItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? barcode = freezed,
    Object? category = null,
    Object? location = null,
    Object? quantity = null,
    Object? unit = null,
    Object? expirationDate = freezed,
    Object? purchaseDate = null,
    Object? openedDate = freezed,
    Object? price = freezed,
    Object? imageUrl = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as FoodCategory,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as StorageLocation,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      expirationDate: freezed == expirationDate
          ? _value.expirationDate
          : expirationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      purchaseDate: null == purchaseDate
          ? _value.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      openedDate: freezed == openedDate
          ? _value.openedDate
          : openedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FoodItemImplCopyWith<$Res>
    implements $FoodItemCopyWith<$Res> {
  factory _$$FoodItemImplCopyWith(
          _$FoodItemImpl value, $Res Function(_$FoodItemImpl) then) =
      __$$FoodItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String? barcode,
      FoodCategory category,
      StorageLocation location,
      double quantity,
      String unit,
      DateTime? expirationDate,
      DateTime purchaseDate,
      DateTime? openedDate,
      double? price,
      String? imageUrl,
      String? notes,
      DateTime createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$$FoodItemImplCopyWithImpl<$Res>
    extends _$FoodItemCopyWithImpl<$Res, _$FoodItemImpl>
    implements _$$FoodItemImplCopyWith<$Res> {
  __$$FoodItemImplCopyWithImpl(
      _$FoodItemImpl _value, $Res Function(_$FoodItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? barcode = freezed,
    Object? category = null,
    Object? location = null,
    Object? quantity = null,
    Object? unit = null,
    Object? expirationDate = freezed,
    Object? purchaseDate = null,
    Object? openedDate = freezed,
    Object? price = freezed,
    Object? imageUrl = freezed,
    Object? notes = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(_$FoodItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      barcode: freezed == barcode
          ? _value.barcode
          : barcode // ignore: cast_nullable_to_non_nullable
              as String?,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as FoodCategory,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as StorageLocation,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      expirationDate: freezed == expirationDate
          ? _value.expirationDate
          : expirationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      purchaseDate: null == purchaseDate
          ? _value.purchaseDate
          : purchaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      openedDate: freezed == openedDate
          ? _value.openedDate
          : openedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FoodItemImpl implements _FoodItem {
  const _$FoodItemImpl(
      {required this.id,
      required this.name,
      this.barcode,
      required this.category,
      required this.location,
      required this.quantity,
      required this.unit,
      this.expirationDate,
      required this.purchaseDate,
      this.openedDate,
      this.price,
      this.imageUrl,
      this.notes,
      required this.createdAt,
      this.updatedAt});

  factory _$FoodItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$FoodItemImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? barcode;
  @override
  final FoodCategory category;
  @override
  final StorageLocation location;
  @override
  final double quantity;
  @override
  final String unit;
  @override
  final DateTime? expirationDate;
  @override
  final DateTime purchaseDate;
  @override
  final DateTime? openedDate;
  @override
  final double? price;
  @override
  final String? imageUrl;
  @override
  final String? notes;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'FoodItem(id: $id, name: $name, barcode: $barcode, category: $category, location: $location, quantity: $quantity, unit: $unit, expirationDate: $expirationDate, purchaseDate: $purchaseDate, openedDate: $openedDate, price: $price, imageUrl: $imageUrl, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FoodItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.barcode, barcode) || other.barcode == barcode) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.expirationDate, expirationDate) ||
                other.expirationDate == expirationDate) &&
            (identical(other.purchaseDate, purchaseDate) ||
                other.purchaseDate == purchaseDate) &&
            (identical(other.openedDate, openedDate) ||
                other.openedDate == openedDate) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      barcode,
      category,
      location,
      quantity,
      unit,
      expirationDate,
      purchaseDate,
      openedDate,
      price,
      imageUrl,
      notes,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FoodItemImplCopyWith<_$FoodItemImpl> get copyWith =>
      __$$FoodItemImplCopyWithImpl<_$FoodItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FoodItemImplToJson(
      this,
    );
  }
}

abstract class _FoodItem implements FoodItem {
  const factory _FoodItem(
      {required final String id,
      required final String name,
      final String? barcode,
      required final FoodCategory category,
      required final StorageLocation location,
      required final double quantity,
      required final String unit,
      final DateTime? expirationDate,
      required final DateTime purchaseDate,
      final DateTime? openedDate,
      final double? price,
      final String? imageUrl,
      final String? notes,
      required final DateTime createdAt,
      final DateTime? updatedAt}) = _$FoodItemImpl;

  factory _FoodItem.fromJson(Map<String, dynamic> json) =
      _$FoodItemImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get barcode;
  @override
  FoodCategory get category;
  @override
  StorageLocation get location;
  @override
  double get quantity;
  @override
  String get unit;
  @override
  DateTime? get expirationDate;
  @override
  DateTime get purchaseDate;
  @override
  DateTime? get openedDate;
  @override
  double? get price;
  @override
  String? get imageUrl;
  @override
  String? get notes;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$FoodItemImplCopyWith<_$FoodItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
