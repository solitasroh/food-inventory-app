import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/food_item.dart';
import '../providers/inventory_list_provider.dart';
import '../widgets/expiration_badge.dart';

class FoodItemDetailPage extends ConsumerWidget {
  final String itemId;

  const FoodItemDetailPage({
    super.key,
    required this.itemId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryAsync = ref.watch(inventoryListProvider);

    return inventoryAsync.when(
      data: (items) {
        final item = items.where((i) => i.id == itemId).firstOrNull;

        if (item == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(
              child: Text('식재료를 찾을 수 없습니다'),
            ),
          );
        }

        return _DetailContent(item: item);
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('오류: $error')),
      ),
    );
  }
}

class _DetailContent extends ConsumerWidget {
  final FoodItem item;

  const _DetailContent({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => context.go(AppRoutes.editItemPath(item.id)),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showDeleteDialog(context, ref),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 24.h),
            _buildInfoSection(),
            SizedBox(height: 24.h),
            _buildDateSection(),
            if (item.price != null) ...[
              SizedBox(height: 24.h),
              _buildPriceSection(),
            ],
            if (item.notes != null && item.notes!.isNotEmpty) ...[
              SizedBox(height: 24.h),
              _buildNotesSection(),
            ],
            SizedBox(height: 32.h),
            _buildQuickActions(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                color: _getCategoryColor(item.category).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                _getCategoryIcon(item.category),
                color: _getCategoryColor(item.category),
                size: 32.w,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      _buildTag(item.category.label, _getCategoryColor(item.category)),
                      SizedBox(width: 8.w),
                      _buildTag(item.location.label, AppColors.secondary),
                    ],
                  ),
                ],
              ),
            ),
            ExpirationBadge(expirationDate: item.expirationDate),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return _buildSection(
      title: '기본 정보',
      icon: Icons.info_outline,
      children: [
        _buildInfoRow(
          icon: Icons.numbers,
          label: '수량',
          value: '${item.quantity.toStringAsFixed(item.quantity.truncateToDouble() == item.quantity ? 0 : 1)} ${item.unit}',
        ),
        _buildInfoRow(
          icon: _getLocationIcon(item.location),
          label: '저장 위치',
          value: item.location.label,
        ),
        _buildInfoRow(
          icon: Icons.category_outlined,
          label: '카테고리',
          value: item.category.label,
        ),
        if (item.barcode != null)
          _buildInfoRow(
            icon: Icons.qr_code,
            label: '바코드',
            value: item.barcode!,
          ),
      ],
    );
  }

  Widget _buildDateSection() {
    final dateFormat = DateFormat('yyyy년 MM월 dd일');

    return _buildSection(
      title: '날짜 정보',
      icon: Icons.calendar_today_outlined,
      children: [
        _buildInfoRow(
          icon: Icons.shopping_cart_outlined,
          label: '구매일',
          value: dateFormat.format(item.purchaseDate),
        ),
        if (item.expirationDate != null)
          _buildInfoRow(
            icon: Icons.event_outlined,
            label: '유통기한',
            value: dateFormat.format(item.expirationDate!),
            valueColor: _getExpirationColor(item.expirationDate!),
          ),
        if (item.openedDate != null)
          _buildInfoRow(
            icon: Icons.lock_open_outlined,
            label: '개봉일',
            value: dateFormat.format(item.openedDate!),
          ),
      ],
    );
  }

  Widget _buildPriceSection() {
    final priceFormat = NumberFormat('#,###');

    return _buildSection(
      title: '가격 정보',
      icon: Icons.attach_money,
      children: [
        _buildInfoRow(
          icon: Icons.payment_outlined,
          label: '구매 가격',
          value: '${priceFormat.format(item.price!.toInt())}원',
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return _buildSection(
      title: '메모',
      icon: Icons.notes,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Text(
            item.notes!,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.grey700,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20.w, color: AppColors.primary),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 20.w, color: AppColors.grey500),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.grey600,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: valueColor ?? AppColors.grey800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '빠른 작업',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showQuantityDialog(context, ref),
                icon: const Icon(Icons.edit),
                label: const Text('수량 변경'),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _markAsOpened(context, ref),
                icon: const Icon(Icons.lock_open),
                label: const Text('개봉 표시'),
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ElevatedButton.icon(
          onPressed: () => context.go(AppRoutes.editItemPath(item.id)),
          icon: const Icon(Icons.edit_outlined),
          label: const Text('전체 수정'),
        ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('삭제 확인'),
        content: Text('${item.name}을(를) 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(inventoryListProvider.notifier).deleteItem(item.id);
              if (context.mounted) {
                context.go(AppRoutes.home);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${item.name}이(가) 삭제되었습니다'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  void _showQuantityDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(
      text: item.quantity.toStringAsFixed(
        item.quantity.truncateToDouble() == item.quantity ? 0 : 1,
      ),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('수량 변경'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: '수량',
            suffixText: item.unit,
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () async {
              final newQuantity = double.tryParse(controller.text);
              if (newQuantity != null && newQuantity > 0) {
                Navigator.pop(context);
                final updatedItem = item.copyWith(quantity: newQuantity);
                await ref.read(inventoryListProvider.notifier).updateItem(updatedItem);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('수량이 변경되었습니다'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }

  void _markAsOpened(BuildContext context, WidgetRef ref) async {
    final updatedItem = item.copyWith(openedDate: DateTime.now());
    await ref.read(inventoryListProvider.notifier).updateItem(updatedItem);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('개봉일이 기록되었습니다'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Color _getExpirationColor(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now).inDays;

    if (diff < 0) return AppColors.expired;
    if (diff <= 3) return AppColors.expiringSoon;
    return AppColors.fresh;
  }

  IconData _getCategoryIcon(FoodCategory category) {
    switch (category) {
      case FoodCategory.vegetables:
        return Icons.grass;
      case FoodCategory.fruits:
        return Icons.apple;
      case FoodCategory.meat:
        return Icons.set_meal;
      case FoodCategory.seafood:
        return Icons.water;
      case FoodCategory.dairy:
        return Icons.egg_alt;
      case FoodCategory.grains:
        return Icons.grain;
      case FoodCategory.seasonings:
        return Icons.science;
      case FoodCategory.processed:
        return Icons.inventory_2;
      case FoodCategory.beverages:
        return Icons.local_drink;
      case FoodCategory.other:
        return Icons.category;
    }
  }

  Color _getCategoryColor(FoodCategory category) {
    switch (category) {
      case FoodCategory.vegetables:
        return const Color(0xFF4CAF50);
      case FoodCategory.fruits:
        return const Color(0xFFFF9800);
      case FoodCategory.meat:
        return const Color(0xFFE91E63);
      case FoodCategory.seafood:
        return const Color(0xFF03A9F4);
      case FoodCategory.dairy:
        return const Color(0xFFFFC107);
      case FoodCategory.grains:
        return const Color(0xFF795548);
      case FoodCategory.seasonings:
        return const Color(0xFF9C27B0);
      case FoodCategory.processed:
        return const Color(0xFF607D8B);
      case FoodCategory.beverages:
        return const Color(0xFF00BCD4);
      case FoodCategory.other:
        return const Color(0xFF9E9E9E);
    }
  }

  IconData _getLocationIcon(StorageLocation location) {
    switch (location) {
      case StorageLocation.refrigerator:
        return Icons.kitchen;
      case StorageLocation.freezer:
        return Icons.ac_unit;
      case StorageLocation.pantry:
        return Icons.shelves;
      case StorageLocation.other:
        return Icons.inventory;
    }
  }
}
