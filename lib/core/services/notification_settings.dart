import 'package:shared_preferences/shared_preferences.dart';

/// 알림 설정 모델
class NotificationSettings {
  /// 알림 활성화 여부
  final bool enabled;

  /// 유통기한 며칠 전에 알림할지 (기본: 3일)
  final int daysBeforeExpiration;

  /// 알림 시간 (시)
  final int notificationHour;

  /// 알림 시간 (분)
  final int notificationMinute;

  /// 만료된 식품도 알림할지
  final bool notifyExpired;

  const NotificationSettings({
    this.enabled = true,
    this.daysBeforeExpiration = 3,
    this.notificationHour = 9,
    this.notificationMinute = 0,
    this.notifyExpired = true,
  });

  NotificationSettings copyWith({
    bool? enabled,
    int? daysBeforeExpiration,
    int? notificationHour,
    int? notificationMinute,
    bool? notifyExpired,
  }) {
    return NotificationSettings(
      enabled: enabled ?? this.enabled,
      daysBeforeExpiration: daysBeforeExpiration ?? this.daysBeforeExpiration,
      notificationHour: notificationHour ?? this.notificationHour,
      notificationMinute: notificationMinute ?? this.notificationMinute,
      notifyExpired: notifyExpired ?? this.notifyExpired,
    );
  }

  /// SharedPreferences에서 로드
  static Future<NotificationSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    return NotificationSettings(
      enabled: prefs.getBool(_keyEnabled) ?? true,
      daysBeforeExpiration: prefs.getInt(_keyDaysBefore) ?? 3,
      notificationHour: prefs.getInt(_keyHour) ?? 9,
      notificationMinute: prefs.getInt(_keyMinute) ?? 0,
      notifyExpired: prefs.getBool(_keyNotifyExpired) ?? true,
    );
  }

  /// SharedPreferences에 저장
  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyEnabled, enabled);
    await prefs.setInt(_keyDaysBefore, daysBeforeExpiration);
    await prefs.setInt(_keyHour, notificationHour);
    await prefs.setInt(_keyMinute, notificationMinute);
    await prefs.setBool(_keyNotifyExpired, notifyExpired);
  }

  // SharedPreferences 키
  static const _keyEnabled = 'notification_enabled';
  static const _keyDaysBefore = 'notification_days_before';
  static const _keyHour = 'notification_hour';
  static const _keyMinute = 'notification_minute';
  static const _keyNotifyExpired = 'notification_notify_expired';
}
