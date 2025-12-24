import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/notification_service.dart';
import '../../../../core/services/notification_settings.dart';

/// 알림 설정 상태 Provider
final notificationSettingsProvider =
    StateNotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
  (ref) => NotificationSettingsNotifier(),
);

class NotificationSettingsNotifier extends StateNotifier<NotificationSettings> {
  NotificationSettingsNotifier() : super(const NotificationSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    state = await NotificationSettings.load();
  }

  Future<void> updateSettings(NotificationSettings settings) async {
    state = settings;
    await settings.save();
    await NotificationService().updateSettings(settings);
  }

  Future<void> setEnabled(bool enabled) async {
    await updateSettings(state.copyWith(enabled: enabled));
  }

  Future<void> setDaysBeforeExpiration(int days) async {
    await updateSettings(state.copyWith(daysBeforeExpiration: days));
  }

  Future<void> setNotificationTime(int hour, int minute) async {
    await updateSettings(state.copyWith(
      notificationHour: hour,
      notificationMinute: minute,
    ));
  }

  Future<void> setNotifyExpired(bool notify) async {
    await updateSettings(state.copyWith(notifyExpired: notify));
  }
}

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationSettingsProvider);
    final notifier = ref.read(notificationSettingsProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
      ),
      body: ListView(
        children: [
          // 알림 설정 섹션
          _buildSectionHeader(context, '알림 설정'),

          // 알림 활성화 토글
          SwitchListTile(
            title: const Text('유통기한 알림'),
            subtitle: const Text('유통기한 임박 식품에 대한 알림을 받습니다'),
            value: settings.enabled,
            onChanged: (value) async {
              if (value) {
                final granted = await NotificationService().requestPermission();
                if (!granted) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('알림 권한이 필요합니다. 설정에서 권한을 허용해주세요.'),
                      ),
                    );
                  }
                  return;
                }
              }
              await notifier.setEnabled(value);
            },
            secondary: Icon(
              settings.enabled
                  ? Icons.notifications_active
                  : Icons.notifications_off,
              color: settings.enabled ? theme.colorScheme.primary : null,
            ),
          ),

          // 알림 세부 설정 (활성화된 경우에만 표시)
          if (settings.enabled) ...[
            const Divider(height: 1),

            // 며칠 전 알림 설정
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('사전 알림 기간'),
              subtitle: Text('유통기한 ${settings.daysBeforeExpiration}일 전에 알림'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showDaysPickerDialog(context, settings, notifier),
            ),

            const Divider(height: 1),

            // 알림 시간 설정
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('알림 시간'),
              subtitle: Text(_formatTime(
                settings.notificationHour,
                settings.notificationMinute,
              )),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showTimePickerDialog(context, settings, notifier),
            ),

            const Divider(height: 1),

            // 만료 식품 알림 토글
            SwitchListTile(
              title: const Text('만료 식품 알림'),
              subtitle: const Text('이미 유통기한이 지난 식품도 알림에 포함'),
              value: settings.notifyExpired,
              onChanged: (value) => notifier.setNotifyExpired(value),
              secondary: const Icon(Icons.warning_amber),
            ),

            const Divider(height: 1),

            // 테스트 알림 버튼
            ListTile(
              leading: const Icon(Icons.send),
              title: const Text('테스트 알림 보내기'),
              subtitle: const Text('알림이 정상적으로 작동하는지 확인'),
              onTap: () async {
                await NotificationService().showImmediateNotification(
                  title: '테스트 알림',
                  body: '알림이 정상적으로 작동합니다!',
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('테스트 알림을 보냈습니다')),
                  );
                }
              },
            ),
          ],

          const SizedBox(height: 24),

          // 앱 정보 섹션
          _buildSectionHeader(context, '앱 정보'),

          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('버전'),
            subtitle: const Text('1.0.0'),
          ),

          const Divider(height: 1),

          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('오픈소스 라이선스'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showLicensePage(
                context: context,
                applicationName: '식재료 관리',
                applicationVersion: '1.0.0',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  String _formatTime(int hour, int minute) {
    final period = hour >= 12 ? '오후' : '오전';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    final displayMinute = minute.toString().padLeft(2, '0');
    return '$period $displayHour:$displayMinute';
  }

  Future<void> _showDaysPickerDialog(
    BuildContext context,
    NotificationSettings settings,
    NotificationSettingsNotifier notifier,
  ) async {
    final days = [1, 2, 3, 5, 7, 14];

    await showDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('사전 알림 기간 선택'),
        children: days.map((d) {
          return RadioListTile<int>(
            title: Text('$d일 전'),
            value: d,
            groupValue: settings.daysBeforeExpiration,
            onChanged: (value) {
              if (value != null) {
                notifier.setDaysBeforeExpiration(value);
                Navigator.pop(context);
              }
            },
          );
        }).toList(),
      ),
    );
  }

  Future<void> _showTimePickerDialog(
    BuildContext context,
    NotificationSettings settings,
    NotificationSettingsNotifier notifier,
  ) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: settings.notificationHour,
        minute: settings.notificationMinute,
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child!,
        );
      },
    );

    if (time != null) {
      await notifier.setNotificationTime(time.hour, time.minute);
    }
  }
}
