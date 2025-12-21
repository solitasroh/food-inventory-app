import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/enums.dart';
import '../providers/filter_provider.dart';
import '../providers/inventory_list_provider.dart';
import '../providers/search_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/food_item_card.dart';

class InventoryListPage extends ConsumerWidget {
  const InventoryListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryAsync = ref.watch(inventoryListProvider);
    final filteredItems = ref.watch(filteredItemsProvider);
    final selectedLocation = ref.watch(selectedLocationProvider);
    final isSearching = ref.watch(isSearchingProvider);

    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? _SearchField(ref: ref)
            : const Text('식재료 재고'),
        actions: [
          if (!isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                ref.read(isSearchingProvider.notifier).start();
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                ref.read(isSearchingProvider.notifier).stop();
              },
            ),
        ],
      ),
      body: Column(
        children: [
          _FilterChips(
            selectedLocation: selectedLocation,
            onSelected: (location) {
              ref.read(selectedLocationProvider.notifier).select(location);
            },
          ),
          Expanded(
            child: inventoryAsync.when(
              data: (_) {
                if (filteredItems.isEmpty) {
                  return const EmptyState(
                    icon: Icons.kitchen_outlined,
                    title: '등록된 식재료가 없습니다',
                    subtitle: '+ 버튼을 눌러 식재료를 추가해보세요',
                  );
                }
                return _ItemList(items: filteredItems);
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => EmptyState(
                icon: Icons.error_outline,
                title: '오류가 발생했습니다',
                subtitle: error.toString(),
                action: TextButton(
                  onPressed: () {
                    ref.read(inventoryListProvider.notifier).loadItems();
                  },
                  child: const Text('다시 시도'),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(AppRoutes.add),
        icon: const Icon(Icons.add),
        label: const Text('추가'),
      ),
    );
  }
}

class _SearchField extends StatefulWidget {
  final WidgetRef ref;

  const _SearchField({required this.ref});

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: true,
      decoration: InputDecoration(
        hintText: '식재료 검색...',
        border: InputBorder.none,
        filled: false,
        contentPadding: EdgeInsets.zero,
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, size: 20),
                onPressed: () {
                  _controller.clear();
                  widget.ref.read(searchQueryProvider.notifier).clear();
                },
              )
            : null,
      ),
      style: TextStyle(fontSize: 16.sp),
      onChanged: (value) {
        widget.ref.read(searchQueryProvider.notifier).update(value);
        setState(() {});
      },
    );
  }
}

class _FilterChips extends StatelessWidget {
  final StorageLocation? selectedLocation;
  final ValueChanged<StorageLocation?> onSelected;

  const _FilterChips({
    required this.selectedLocation,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildChip(null, '전체'),
            SizedBox(width: 8.w),
            _buildChip(StorageLocation.refrigerator, '냉장고'),
            SizedBox(width: 8.w),
            _buildChip(StorageLocation.freezer, '냉동고'),
            SizedBox(width: 8.w),
            _buildChip(StorageLocation.pantry, '팬트리'),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(StorageLocation? location, String label) {
    final isSelected = selectedLocation == location;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        onSelected(selected ? location : null);
      },
      backgroundColor: AppColors.grey100,
      selectedColor: AppColors.primaryLight,
      checkmarkColor: AppColors.onPrimaryLight,
      labelStyle: TextStyle(
        color: isSelected ? AppColors.onPrimaryLight : AppColors.grey700,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
    );
  }
}

class _ItemList extends StatelessWidget {
  final List items;

  const _ItemList({required this.items});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // Pull to refresh
        final container = ProviderScope.containerOf(context);
        await container.read(inventoryListProvider.notifier).loadItems();
      },
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: FoodItemCard(
              item: item,
              onTap: () => context.go(AppRoutes.itemDetailPath(item.id)),
            ),
          );
        },
      ),
    );
  }
}
