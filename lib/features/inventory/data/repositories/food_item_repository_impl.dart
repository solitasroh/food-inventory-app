import '../../domain/entities/enums.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/repositories/food_item_repository.dart';
import '../datasources/food_item_local_datasource.dart';
import '../models/food_item_model.dart';

class FoodItemRepositoryImpl implements FoodItemRepository {
  final FoodItemLocalDataSource _localDataSource;

  FoodItemRepositoryImpl(this._localDataSource);

  @override
  Future<List<FoodItem>> getAllItems() async {
    final models = await _localDataSource.getAllItems();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<FoodItem?> getItemById(String id) async {
    final model = await _localDataSource.getItemById(id);
    return model?.toEntity();
  }

  @override
  Future<FoodItem?> getItemByBarcode(String barcode) async {
    final model = await _localDataSource.getItemByBarcode(barcode);
    return model?.toEntity();
  }

  @override
  Future<List<FoodItem>> getItemsByLocation(StorageLocation location) async {
    final models = await _localDataSource.getItemsByLocation(location);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<FoodItem>> getItemsByCategory(FoodCategory category) async {
    final models = await _localDataSource.getItemsByCategory(category);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<FoodItem>> getExpiringItems({int days = 3}) async {
    final before = DateTime.now().add(Duration(days: days));
    final models = await _localDataSource.getExpiringItems(before);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<FoodItem>> getExpiredItems() async {
    final models = await _localDataSource.getExpiredItems();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> addItem(FoodItem item) async {
    final model = FoodItemModel.fromEntity(item);
    await _localDataSource.insertItem(model);
  }

  @override
  Future<void> updateItem(FoodItem item) async {
    final model = FoodItemModel.fromEntity(item);
    await _localDataSource.updateItem(model);
  }

  @override
  Future<void> deleteItem(String id) async {
    await _localDataSource.deleteItem(id);
  }

  @override
  Future<void> deleteAllItems() async {
    await _localDataSource.deleteAllItems();
  }

  @override
  Stream<List<FoodItem>> watchAllItems() {
    return _localDataSource.watchAllItems().map(
          (models) => models.map((model) => model.toEntity()).toList(),
        );
  }
}
