import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/food_item.dart';
import 'filter_provider.dart';
import 'inventory_list_provider.dart';

part 'search_provider.g.dart';

@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void update(String query) {
    state = query;
  }

  void clear() {
    state = '';
  }
}

@riverpod
class IsSearching extends _$IsSearching {
  @override
  bool build() => false;

  void toggle() {
    state = !state;
  }

  void start() {
    state = true;
  }

  void stop() {
    state = false;
    // 검색 종료 시 검색어 초기화
    ref.read(searchQueryProvider.notifier).clear();
  }
}

@riverpod
List<FoodItem> filteredItems(FilteredItemsRef ref) {
  final itemsAsync = ref.watch(inventoryListProvider);
  final selectedLocation = ref.watch(selectedLocationProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final searchQuery = ref.watch(searchQueryProvider);
  final sortOption = ref.watch(selectedSortProvider);

  return itemsAsync.when(
    data: (items) {
      var filtered = items.toList();

      // 저장 위치 필터
      if (selectedLocation != null) {
        filtered = filtered
            .where((item) => item.location == selectedLocation)
            .toList();
      }

      // 카테고리 필터
      if (selectedCategory != null) {
        filtered = filtered
            .where((item) => item.category == selectedCategory)
            .toList();
      }

      // 검색어 필터
      if (searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        filtered = filtered.where((item) {
          return item.name.toLowerCase().contains(query) ||
              item.category.label.toLowerCase().contains(query) ||
              item.location.label.toLowerCase().contains(query);
        }).toList();
      }

      // 정렬
      switch (sortOption) {
        case SortOption.name:
          filtered.sort((a, b) => a.name.compareTo(b.name));
          break;
        case SortOption.expirationDate:
          filtered.sort((a, b) {
            if (a.expirationDate == null && b.expirationDate == null) return 0;
            if (a.expirationDate == null) return 1;
            if (b.expirationDate == null) return -1;
            return a.expirationDate!.compareTo(b.expirationDate!);
          });
          break;
        case SortOption.purchaseDate:
          filtered.sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));
          break;
        case SortOption.category:
          filtered.sort((a, b) => a.category.index.compareTo(b.category.index));
          break;
      }

      return filtered;
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

@riverpod
int filteredItemsCount(FilteredItemsCountRef ref) {
  return ref.watch(filteredItemsProvider).length;
}

@riverpod
int totalItemsCount(TotalItemsCountRef ref) {
  final itemsAsync = ref.watch(inventoryListProvider);
  return itemsAsync.valueOrNull?.length ?? 0;
}

@riverpod
Map<String, int> itemsCountByLocation(ItemsCountByLocationRef ref) {
  final itemsAsync = ref.watch(inventoryListProvider);

  return itemsAsync.when(
    data: (items) {
      final counts = <String, int>{};
      for (final item in items) {
        final key = item.location.name;
        counts[key] = (counts[key] ?? 0) + 1;
      }
      return counts;
    },
    loading: () => {},
    error: (_, __) => {},
  );
}
