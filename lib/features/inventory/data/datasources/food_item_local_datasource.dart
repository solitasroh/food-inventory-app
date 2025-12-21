import '../../domain/entities/enums.dart';
import '../../domain/entities/food_item.dart';
import '../models/food_item_model.dart';

abstract class FoodItemLocalDataSource {
  Future<List<FoodItemModel>> getAllItems();
  Future<FoodItemModel?> getItemById(String uid);
  Future<FoodItemModel?> getItemByBarcode(String barcode);
  Future<List<FoodItemModel>> getItemsByLocation(StorageLocation location);
  Future<List<FoodItemModel>> getItemsByCategory(FoodCategory category);
  Future<List<FoodItemModel>> getExpiringItems(DateTime before);
  Future<List<FoodItemModel>> getExpiredItems();
  Future<void> insertItem(FoodItemModel item);
  Future<void> updateItem(FoodItemModel item);
  Future<void> deleteItem(String uid);
  Future<void> deleteAllItems();
  Stream<List<FoodItemModel>> watchAllItems();
}

/// 메모리 기반 DataSource (테스트용)
class FoodItemMemoryDataSource implements FoodItemLocalDataSource {
  final List<FoodItemModel> _items = [];

  @override
  Future<List<FoodItemModel>> getAllItems() async {
    return List.from(_items);
  }

  @override
  Future<FoodItemModel?> getItemById(String uid) async {
    try {
      return _items.firstWhere((item) => item.uid == uid);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<FoodItemModel?> getItemByBarcode(String barcode) async {
    try {
      return _items.firstWhere((item) => item.barcode == barcode);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<FoodItemModel>> getItemsByLocation(StorageLocation location) async {
    return _items.where((item) => item.location == location).toList();
  }

  @override
  Future<List<FoodItemModel>> getItemsByCategory(FoodCategory category) async {
    return _items.where((item) => item.category == category).toList();
  }

  @override
  Future<List<FoodItemModel>> getExpiringItems(DateTime before) async {
    final now = DateTime.now();
    return _items
        .where((item) =>
            item.expirationDate != null &&
            item.expirationDate!.isAfter(now) &&
            item.expirationDate!.isBefore(before))
        .toList()
      ..sort((a, b) => a.expirationDate!.compareTo(b.expirationDate!));
  }

  @override
  Future<List<FoodItemModel>> getExpiredItems() async {
    final now = DateTime.now();
    return _items
        .where((item) =>
            item.expirationDate != null && item.expirationDate!.isBefore(now))
        .toList()
      ..sort((a, b) => a.expirationDate!.compareTo(b.expirationDate!));
  }

  @override
  Future<void> insertItem(FoodItemModel item) async {
    _items.add(item);
  }

  @override
  Future<void> updateItem(FoodItemModel item) async {
    final index = _items.indexWhere((i) => i.uid == item.uid);
    if (index != -1) {
      _items[index] = item;
    }
  }

  @override
  Future<void> deleteItem(String uid) async {
    _items.removeWhere((item) => item.uid == uid);
  }

  @override
  Future<void> deleteAllItems() async {
    _items.clear();
  }

  @override
  Stream<List<FoodItemModel>> watchAllItems() {
    return Stream.value(List.from(_items));
  }
}
