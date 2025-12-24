import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

import '../../features/inventory/domain/entities/food_item.dart';
import 'notification_settings.dart';

/// 알림 서비스
/// 유통기한 임박/만료 식품에 대한 로컬 푸시 알림 관리
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  NotificationSettings _settings = const NotificationSettings();

  /// 알림 채널 ID
  static const String _channelId = 'food_expiration_channel';
  static const String _channelName = '유통기한 알림';
  static const String _channelDescription = '식재료 유통기한 임박 및 만료 알림';

  /// 알림 ID 기준
  static const int _dailyNotificationId = 0;
  static const int _expiringBaseId = 1000;
  static const int _expiredBaseId = 2000;

  /// 초기화
  Future<void> initialize() async {
    if (_isInitialized) return;

    // 타임존 초기화
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

    // Android 설정
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS 설정
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Android 알림 채널 생성
    if (Platform.isAndroid) {
      await _createAndroidNotificationChannel();
    }

    // 설정 로드
    _settings = await NotificationSettings.load();

    _isInitialized = true;
  }

  /// Android 알림 채널 생성
  Future<void> _createAndroidNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// 알림 탭 핸들러
  void _onNotificationTapped(NotificationResponse response) {
    // 알림 탭 시 처리 (예: 특정 화면으로 이동)
    debugPrint('Notification tapped: ${response.payload}');
  }

  /// 알림 권한 요청
  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      final granted = await androidPlugin?.requestNotificationsPermission();
      return granted ?? false;
    } else if (Platform.isIOS) {
      final iosPlugin = _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      final granted = await iosPlugin?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }
    return false;
  }

  /// 설정 업데이트
  Future<void> updateSettings(NotificationSettings settings) async {
    _settings = settings;
    await settings.save();
  }

  /// 현재 설정 반환
  NotificationSettings get settings => _settings;

  /// 즉시 알림 표시 (테스트용)
  Future<void> showImmediateNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch % 100000,
      title,
      body,
      details,
      payload: payload,
    );
  }

  /// 유통기한 임박 식품 알림 스케줄링
  Future<void> scheduleExpirationNotifications(List<FoodItem> items) async {
    if (!_settings.enabled) return;

    // 기존 알림 취소
    await cancelAllNotifications();

    final now = DateTime.now();
    final threshold = now.add(Duration(days: _settings.daysBeforeExpiration));

    // 임박 식품 필터링
    final expiringItems = items.where((item) {
      if (item.expirationDate == null) return false;
      return item.expirationDate!.isAfter(now) &&
          item.expirationDate!.isBefore(threshold);
    }).toList();

    // 만료된 식품 필터링
    final expiredItems = _settings.notifyExpired
        ? items.where((item) {
            if (item.expirationDate == null) return false;
            return item.expirationDate!.isBefore(now);
          }).toList()
        : <FoodItem>[];

    // 매일 정해진 시간에 요약 알림 스케줄링
    if (expiringItems.isNotEmpty || expiredItems.isNotEmpty) {
      await _scheduleDailySummaryNotification(
        expiringCount: expiringItems.length,
        expiredCount: expiredItems.length,
      );
    }

    // 개별 식품 만료 당일 알림 스케줄링
    for (var i = 0; i < expiringItems.length && i < 50; i++) {
      final item = expiringItems[i];
      await _scheduleItemExpirationNotification(item, _expiringBaseId + i);
    }
  }

  /// 매일 요약 알림 스케줄링
  Future<void> _scheduleDailySummaryNotification({
    required int expiringCount,
    required int expiredCount,
  }) async {
    final now = DateTime.now();
    var scheduledDate = DateTime(
      now.year,
      now.month,
      now.day,
      _settings.notificationHour,
      _settings.notificationMinute,
    );

    // 이미 지난 시간이면 다음 날로
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    String body;
    if (expiredCount > 0 && expiringCount > 0) {
      body = '⚠️ 만료된 식품 ${expiredCount}개, 임박한 식품 ${expiringCount}개가 있습니다.';
    } else if (expiredCount > 0) {
      body = '⚠️ 만료된 식품이 ${expiredCount}개 있습니다. 확인해주세요!';
    } else {
      body = '📅 ${_settings.daysBeforeExpiration}일 내 만료 예정인 식품이 ${expiringCount}개 있습니다.';
    }

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.zonedSchedule(
      _dailyNotificationId,
      '🥗 식재료 유통기한 알림',
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // 매일 반복
    );
  }

  /// 개별 식품 만료일 알림 스케줄링
  Future<void> _scheduleItemExpirationNotification(
    FoodItem item,
    int notificationId,
  ) async {
    if (item.expirationDate == null) return;

    // 만료 당일 오전에 알림
    final expirationDay = DateTime(
      item.expirationDate!.year,
      item.expirationDate!.month,
      item.expirationDate!.day,
      _settings.notificationHour,
      _settings.notificationMinute,
    );

    // 이미 지난 날짜면 스킵
    if (expirationDay.isBefore(DateTime.now())) return;

    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.zonedSchedule(
      notificationId,
      '⏰ 오늘 만료되는 식재료',
      '${item.name}의 유통기한이 오늘입니다!',
      tz.TZDateTime.from(expirationDay, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: item.id,
    );
  }

  /// 모든 알림 취소
  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }

  /// 특정 알림 취소
  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }

  /// 예약된 알림 목록 조회
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _plugin.pendingNotificationRequests();
  }
}
