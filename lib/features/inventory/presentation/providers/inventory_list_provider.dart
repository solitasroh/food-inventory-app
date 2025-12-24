import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/services/notification_service.dart';
import '../../../../main.dart';
import '../../domain/entities/food_item.dart';

part 'inventory_list_provider.g.dart';

@riverpod
class InventoryList extends _$InventoryList {
  @override
  Future<List<FoodItem>> build() async {
    return _loadItems();
  }

  Future<List<FoodItem>> _loadItems() async {
    final repository = ref.read(foodItemRepositoryProvider);
    final items = await repository.getAllItems();

    // 알림 재스케줄링
    await NotificationService().scheduleExpirationNotifications(items);

    return items;
  }

  Future<void> loadItems() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadItems());
  }

  Future<void> addItem(FoodItem item) async {
    final repository = ref.read(foodItemRepositoryProvider);

    final newItem = item.copyWith(
      id: const Uuid().v4(),
      createdAt: DateTime.now(),
    );

    await repository.addItem(newItem);

    // 목록 새로고침
    state = await AsyncValue.guard(() => _loadItems());
  }

  Future<void> updateItem(FoodItem item) async {
    final repository = ref.read(foodItemRepositoryProvider);

    final updatedItem = item.copyWith(updatedAt: DateTime.now());
    await repository.updateItem(updatedItem);

    // 목록 새로고침
    state = await AsyncValue.guard(() => _loadItems());
  }

  Future<void> deleteItem(String id) async {
    final repository = ref.read(foodItemRepositoryProvider);

    await repository.deleteItem(id);

    // 목록 새로고침
    state = await AsyncValue.guard(() => _loadItems());
  }

  Future<FoodItem?> getItemById(String id) async {
    final repository = ref.read(foodItemRepositoryProvider);
    return repository.getItemById(id);
  }
}

@riverpod
Future<List<FoodItem>> expiringItems(ExpiringItemsRef ref, {int days = 3}) async {
  final repository = ref.watch(foodItemRepositoryProvider);
  return repository.getExpiringItems(days: days);
}

@riverpod
Future<List<FoodItem>> expiredItems(ExpiredItemsRef ref) async {
  final repository = ref.watch(foodItemRepositoryProvider);
  return repository.getExpiredItems();
}
