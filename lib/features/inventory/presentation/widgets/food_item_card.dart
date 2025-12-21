import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/food_item.dart';
import 'expiration_badge.dart';

class FoodItemCard extends StatelessWidget {
  final FoodItem item;
  final VoidCallback? onTap;

  const FoodItemCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              _buildCategoryIcon(),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        ExpirationBadge(expirationDate: item.expirationDate),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        _buildInfoChip(
                          icon: Icons.inventory_2_outlined,
                          label: '${item.quantity.toStringAsFixed(item.quantity.truncateToDouble() == item.quantity ? 0 : 1)} ${item.unit}',
                        ),
                        SizedBox(width: 8.w),
                        _buildInfoChip(
                          icon: _getLocationIcon(item.location),
                          label: item.location.label,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.grey400,
                size: 24.w,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon() {
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        color: _getCategoryColor(item.category).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(
        _getCategoryIcon(item.category),
        color: _getCategoryColor(item.category),
        size: 24.w,
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.w, color: AppColors.grey600),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.grey600,
            ),
          ),
        ],
      ),
    );
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
