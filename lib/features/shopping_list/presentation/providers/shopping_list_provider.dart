import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/database_helper.dart';
import '../../../inventory/domain/entities/enums.dart';
import '../../data/datasources/shopping_item_sqlite_datasource.dart';
import '../../data/repositories/shopping_list_repository_impl.dart';
import '../../domain/entities/shopping_enums.dart';
import '../../domain/entities/shopping_item.dart';
import '../../domain/repositories/shopping_list_repository.dart';

part 'shopping_list_provider.g.dart';

/// 쇼핑리스트 DataSource Provider
final shoppingListDataSourceProvider =
    Provider<ShoppingItemSqliteDataSource>((ref) {
  throw UnimplementedError('DataSource must be initialized in main.dart');
});

/// 쇼핑리스트 Repository Provider
final shoppingListRepositoryProvider = Provider<ShoppingListRepository>((ref) {
  final dataSource = ref.watch(shoppingListDataSourceProvider);
  return ShoppingListRepositoryImpl(dataSource);
});

/// 쇼핑리스트 상태 관리
@riverpod
class ShoppingList extends _$ShoppingList {
  @override
  Future<List<ShoppingItem>> build() async {
    return _loadItems();
  }

  Future<List<ShoppingItem>> _loadItems() async {
    final repository = ref.read(shoppingListRepositoryProvider);
    return repository.getAllItems();
  }

  /// 목록 새로고침
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _loadItems());
  }

  /// 아이템 추가
  Future<void> addItem({
    required String name,
    required FoodCategory category,
    required double quantity,
    required String unit,
    ShoppingPriority priority = ShoppingPriority.medium,
    String? notes,
    String? linkedFoodItemId,
    SuggestionSource suggestedBy = SuggestionSource.manual,
  }) async {
    final repository = ref.read(shoppingListRepositoryProvider);

    final item = ShoppingItem(
      id: const Uuid().v4(),
      name: name,
      category: category,
      quantity: quantity,
      unit: unit,
      priority: priority,
      notes: notes,
      linkedFoodItemId: linkedFoodItemId,
      suggestedBy: suggestedBy,
      createdAt: DateTime.now(),
    );

    await repository.addItem(item);
    state = await AsyncValue.guard(() => _loadItems());
  }

  /// 아이템 수정
  Future<void> updateItem(ShoppingItem item) async {
    final repository = ref.read(shoppingListRepositoryProvider);
    await repository.updateItem(item);
    state = await AsyncValue.guard(() => _loadItems());
  }

  /// 아이템 삭제
  Future<void> deleteItem(String id) async {
    final repository = ref.read(shoppingListRepositoryProvider);
    await repository.deleteItem(id);
    state = await AsyncValue.guard(() => _loadItems());
  }

  /// 완료 상태 토글
  Future<void> toggleComplete(String id) async {
    final repository = ref.read(shoppingListRepositoryProvider);
    await repository.toggleComplete(id);
    state = await AsyncValue.guard(() => _loadItems());
  }

  /// 완료된 아이템 모두 삭제
  Future<void> clearCompleted() async {
    final repository = ref.read(shoppingListRepositoryProvider);
    await repository.clearCompleted();
    state = await AsyncValue.guard(() => _loadItems());
  }
}

/// 카테고리별로 그룹핑된 쇼핑리스트
@riverpod
Future<Map<FoodCategory, List<ShoppingItem>>> groupedShoppingList(
    GroupedShoppingListRef ref) async {
  final items = await ref.watch(shoppingListProvider.future);

  final grouped = <FoodCategory, List<ShoppingItem>>{};

  for (final item in items) {
    grouped.putIfAbsent(item.category, () => []).add(item);
  }

  // 카테고리 순서대로 정렬
  final sortedGrouped = <FoodCategory, List<ShoppingItem>>{};
  for (final category in FoodCategory.values) {
    if (grouped.containsKey(category)) {
      // 각 카테고리 내에서 미완료 → 완료 순, 생성일 역순 정렬
      final categoryItems = grouped[category]!;
      categoryItems.sort((a, b) {
        if (a.isCompleted != b.isCompleted) {
          return a.isCompleted ? 1 : -1;
        }
        return b.createdAt.compareTo(a.createdAt);
      });
      sortedGrouped[category] = categoryItems;
    }
  }

  return sortedGrouped;
}

/// 미완료 아이템만
@riverpod
Future<List<ShoppingItem>> pendingShoppingItems(
    PendingShoppingItemsRef ref) async {
  final repository = ref.watch(shoppingListRepositoryProvider);
  return repository.getPendingItems();
}

/// 완료된 아이템만
@riverpod
Future<List<ShoppingItem>> completedShoppingItems(
    CompletedShoppingItemsRef ref) async {
  final repository = ref.watch(shoppingListRepositoryProvider);
  return repository.getCompletedItems();
}

/// 자주 구매하는 아이템
@riverpod
Future<List<String>> frequentItems(FrequentItemsRef ref) async {
  final repository = ref.watch(shoppingListRepositoryProvider);
  return repository.getFrequentItems(limit: 10);
}

/// 최근 구매한 아이템
@riverpod
Future<List<String>> recentItems(RecentItemsRef ref) async {
  final repository = ref.watch(shoppingListRepositoryProvider);
  return repository.getRecentItems(limit: 10);
}

/// 쇼핑리스트 통계
@riverpod
Future<ShoppingListStats> shoppingListStats(ShoppingListStatsRef ref) async {
  final items = await ref.watch(shoppingListProvider.future);

  final pending = items.where((i) => !i.isCompleted).length;
  final completed = items.where((i) => i.isCompleted).length;

  final categoryCount = <FoodCategory, int>{};
  for (final item in items.where((i) => !i.isCompleted)) {
    categoryCount[item.category] = (categoryCount[item.category] ?? 0) + 1;
  }

  return ShoppingListStats(
    totalItems: items.length,
    pendingItems: pending,
    completedItems: completed,
    itemsByCategory: categoryCount,
  );
}

/// 쇼핑리스트 통계 모델
class ShoppingListStats {
  final int totalItems;
  final int pendingItems;
  final int completedItems;
  final Map<FoodCategory, int> itemsByCategory;

  const ShoppingListStats({
    required this.totalItems,
    required this.pendingItems,
    required this.completedItems,
    required this.itemsByCategory,
  });
}
