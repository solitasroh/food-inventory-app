import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

enum ExpirationStatus {
  expired,
  expiringSoon,
  fresh,
  noDate,
}

class ExpirationBadge extends StatelessWidget {
  final DateTime? expirationDate;

  const ExpirationBadge({
    super.key,
    this.expirationDate,
  });

  @override
  Widget build(BuildContext context) {
    final status = _getStatus();
    final dDay = _getDDay();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: _getBackgroundColor(status),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        _getDisplayText(status, dDay),
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: _getTextColor(status),
        ),
      ),
    );
  }

  ExpirationStatus _getStatus() {
    if (expirationDate == null) {
      return ExpirationStatus.noDate;
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expDate = DateTime(
      expirationDate!.year,
      expirationDate!.month,
      expirationDate!.day,
    );

    final difference = expDate.difference(today).inDays;

    if (difference < 0) {
      return ExpirationStatus.expired;
    } else if (difference <= 3) {
      return ExpirationStatus.expiringSoon;
    } else {
      return ExpirationStatus.fresh;
    }
  }

  int? _getDDay() {
    if (expirationDate == null) return null;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expDate = DateTime(
      expirationDate!.year,
      expirationDate!.month,
      expirationDate!.day,
    );

    return expDate.difference(today).inDays;
  }

  String _getDisplayText(ExpirationStatus status, int? dDay) {
    switch (status) {
      case ExpirationStatus.expired:
        return 'D+${dDay!.abs()}';
      case ExpirationStatus.expiringSoon:
        if (dDay == 0) return 'D-Day';
        return 'D-$dDay';
      case ExpirationStatus.fresh:
        return 'D-$dDay';
      case ExpirationStatus.noDate:
        return '유통기한 없음';
    }
  }

  Color _getBackgroundColor(ExpirationStatus status) {
    switch (status) {
      case ExpirationStatus.expired:
        return AppColors.expired.withOpacity(0.1);
      case ExpirationStatus.expiringSoon:
        return AppColors.expiringSoon.withOpacity(0.1);
      case ExpirationStatus.fresh:
        return AppColors.fresh.withOpacity(0.1);
      case ExpirationStatus.noDate:
        return AppColors.grey200;
    }
  }

  Color _getTextColor(ExpirationStatus status) {
    switch (status) {
      case ExpirationStatus.expired:
        return AppColors.expired;
      case ExpirationStatus.expiringSoon:
        return AppColors.expiringSoon;
      case ExpirationStatus.fresh:
        return AppColors.fresh;
      case ExpirationStatus.noDate:
        return AppColors.grey600;
    }
  }
}
