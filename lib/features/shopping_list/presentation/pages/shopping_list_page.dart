import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../inventory/domain/entities/enums.dart';
import '../../domain/entities/shopping_item.dart';
import '../providers/shopping_list_provider.dart';
import '../widgets/shopping_item_tile.dart';
import 'add_shopping_item_page.dart';

class ShoppingListPage extends ConsumerWidget {
  const ShoppingListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupedListAsync = ref.watch(groupedShoppingListProvider);
    final statsAsync = ref.watch(shoppingListStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('쇼핑리스트'),
        actions: [
          // 완료 아이템 비우기
          statsAsync.whenOrNull(
                data: (stats) => stats.completedItems > 0
                    ? IconButton(
                        icon: const Icon(Icons.delete_sweep),
                        tooltip: '완료된 항목 삭제',
                        onPressed: () => _showClearCompletedDialog(context, ref),
                      )
                    : null,
              ) ??
              const SizedBox.shrink(),
        ],
      ),
      body: groupedListAsync.when(
        data: (grouped) => _buildContent(context, ref, grouped),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddItemSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('추가'),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    Map<FoodCategory, List<ShoppingItem>> grouped,
  ) {
    if (grouped.isEmpty) {
      return _buildEmptyState(context);
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(shoppingListProvider.notifier).refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: grouped.length,
        itemBuilder: (context, index) {
          final category = grouped.keys.elementAt(index);
          final items = grouped[category]!;

          return _buildCategorySection(context, ref, category, items);
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: theme.colorScheme.onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            '쇼핑리스트가 비어있습니다',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '추가 버튼을 눌러 구매할 품목을 추가하세요',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(
    BuildContext context,
    WidgetRef ref,
    FoodCategory category,
    List<ShoppingItem> items,
  ) {
    final theme = Theme.of(context);
    final pendingCount = items.where((i) => !i.isCompleted).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 카테고리 헤더
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Icon(
                _getCategoryIcon(category),
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                category.label,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$pendingCount',
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
        // 아이템 목록
        ...items.map(
          (item) => ShoppingItemTile(
            item: item,
            onToggle: () => _handleToggle(context, ref, item),
            onDelete: () => _handleDelete(ref, item.id),
            onTap: () => _showEditItemSheet(context, item),
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }

  IconData _getCategoryIcon(FoodCategory category) {
    switch (category) {
      case FoodCategory.vegetables:
        return Icons.eco;
      case FoodCategory.fruits:
        return Icons.apple;
      case FoodCategory.meat:
        return Icons.set_meal;
      case FoodCategory.seafood:
        return Icons.water;
      case FoodCategory.dairy:
        return Icons.egg;
      case FoodCategory.grains:
        return Icons.grain;
      case FoodCategory.seasonings:
        return Icons.restaurant;
      case FoodCategory.processed:
        return Icons.inventory_2;
      case FoodCategory.beverages:
        return Icons.local_cafe;
      case FoodCategory.other:
        return Icons.more_horiz;
    }
  }

  Future<void> _handleToggle(
    BuildContext context,
    WidgetRef ref,
    ShoppingItem item,
  ) async {
    await ref.read(shoppingListProvider.notifier).toggleComplete(item.id);

    // 완료 시 재고 추가 여부 확인
    if (!item.isCompleted) {
      if (context.mounted) {
        _showAddToInventoryDialog(context, ref, item);
      }
    }
  }

  void _handleDelete(WidgetRef ref, String id) {
    ref.read(shoppingListProvider.notifier).deleteItem(id);
  }

  void _showAddItemSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => const AddShoppingItemPage(),
    );
  }

  void _showEditItemSheet(BuildContext context, ShoppingItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => AddShoppingItemPage(editItem: item),
    );
  }

  Future<void> _showAddToInventoryDialog(
    BuildContext context,
    WidgetRef ref,
    ShoppingItem item,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('재고에 추가'),
        content: Text('${item.name}을(를) 재고에 추가하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('아니오'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('추가'),
          ),
        ],
      ),
    );

    if (result == true && context.mounted) {
      // 재고 추가 페이지로 이동 (사전 정보 전달)
      context.push('/inventory/add', extra: {
        'name': item.name,
        'category': item.category,
        'quantity': item.quantity,
        'unit': item.unit,
      });
    }
  }

  Future<void> _showClearCompletedDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('완료된 항목 삭제'),
        content: const Text('완료된 모든 항목을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(shoppingListProvider.notifier).clearCompleted();
    }
  }
}
