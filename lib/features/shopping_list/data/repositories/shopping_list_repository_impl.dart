import '../../../inventory/domain/entities/enums.dart';
import '../../domain/entities/shopping_item.dart';
import '../../domain/repositories/shopping_list_repository.dart';
import '../datasources/shopping_item_sqlite_datasource.dart';

/// 쇼핑리스트 Repository 구현
class ShoppingListRepositoryImpl implements ShoppingListRepository {
  final ShoppingItemSqliteDataSource _dataSource;

  ShoppingListRepositoryImpl(this._dataSource);

  @override
  Future<List<ShoppingItem>> getAllItems() => _dataSource.getAllItems();

  @override
  Stream<List<ShoppingItem>> watchAllItems() => _dataSource.itemsStream;

  @override
  Future<List<ShoppingItem>> getPendingItems() => _dataSource.getPendingItems();

  @override
  Future<List<ShoppingItem>> getCompletedItems() =>
      _dataSource.getCompletedItems();

  @override
  Future<List<ShoppingItem>> getItemsByCategory(FoodCategory category) =>
      _dataSource.getItemsByCategory(category);

  @override
  Future<ShoppingItem?> getItemById(String id) => _dataSource.getItemById(id);

  @override
  Future<void> addItem(ShoppingItem item) => _dataSource.addItem(item);

  @override
  Future<void> updateItem(ShoppingItem item) => _dataSource.updateItem(item);

  @override
  Future<void> deleteItem(String id) => _dataSource.deleteItem(id);

  @override
  Future<void> toggleComplete(String id) => _dataSource.toggleComplete(id);

  @override
  Future<void> clearCompleted() => _dataSource.clearCompleted();

  @override
  Future<List<ShoppingItem>> searchItems(String query) =>
      _dataSource.searchItems(query);

  @override
  Future<List<String>> getFrequentItems({int limit = 10}) async {
    final items = await _dataSource.getFrequentItems(limit: limit);
    return items.map((m) => m['item_name'] as String).toList();
  }

  @override
  Future<List<String>> getRecentItems({int limit = 10}) async {
    final items = await _dataSource.getRecentItems(limit: limit);
    return items.map((m) => m['item_name'] as String).toList();
  }
}
