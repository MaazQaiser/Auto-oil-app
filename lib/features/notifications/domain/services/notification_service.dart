import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../../../core/utils/logger.dart';

/// Notification action identifiers.
class NotificationActions {
  const NotificationActions._();

  static const String markComplete = 'mark_complete';
  static const String openVehicle = 'open_vehicle';
  static const String dismiss = 'dismiss';
  static const String openReminders = 'open_reminders';
}

/// Payload carried inside local notifications.
class NotificationPayload {
  const NotificationPayload({
    required this.type,
    this.reminderId,
    this.vehicleId,
    this.route,
  });

  final String type;
  final String? reminderId;
  final String? vehicleId;
  final String? route;

  Map<String, dynamic> toJson() => {
        'type': type,
        if (reminderId != null) 'reminderId': reminderId,
        if (vehicleId != null) 'vehicleId': vehicleId,
        if (route != null) 'route': route,
      };

  String encode() => jsonEncode(toJson());

  static NotificationPayload? tryParse(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final Map<String, dynamic> map =
          jsonDecode(raw) as Map<String, dynamic>;
      return NotificationPayload(
        type: map['type'] as String? ?? 'unknown',
        reminderId: map['reminderId'] as String?,
        vehicleId: map['vehicleId'] as String?,
        route: map['route'] as String?,
      );
    } catch (_) {
      return null;
    }
  }
}

typedef NotificationTapCallback = void Function(
  NotificationPayload? payload,
  String? actionId,
);

/// Low-level wrapper around flutter_local_notifications.
class NotificationService {
  NotificationService();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  NotificationTapCallback? onTap;

  bool get isInitialized => _initialized;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'autocare_reminders',
    'Service Reminders',
    description: 'Due, overdue, and summary maintenance reminders',
    importance: Importance.high,
  );

  Future<void> initialize({NotificationTapCallback? onTap}) async {
    if (_initialized) return;
    this.onTap = onTap;

    try {
      tz_data.initializeTimeZones();
      try {
        tz.setLocalLocation(tz.getLocation('UTC'));
      } catch (_) {
        // Fallback — device local zone may already be set.
      }

      const AndroidInitializationSettings android =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings darwin = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );

      const InitializationSettings settings = InitializationSettings(
        android: android,
        iOS: darwin,
        macOS: darwin,
      );

      await _plugin.initialize(
        settings: settings,
        onDidReceiveNotificationResponse: _onResponse,
        onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      );

      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
        final AndroidFlutterLocalNotificationsPlugin? androidPlugin = _plugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        await androidPlugin?.createNotificationChannel(_channel);
      }

      _initialized = true;
      AppLogger.info('NotificationService initialized');
    } catch (e, st) {
      AppLogger.error(
        'NotificationService init failed',
        error: e,
        stackTrace: st,
      );
    }
  }

  void _onResponse(NotificationResponse response) {
    final payload = NotificationPayload.tryParse(response.payload);
    onTap?.call(payload, response.actionId);
  }

  Future<void> show({
    required int id,
    required String title,
    required String body,
    NotificationPayload? payload,
    bool withActions = true,
  }) async {
    if (!_initialized) {
      AppLogger.warning('NotificationService not initialized — skip show');
      return;
    }

    final AndroidNotificationDetails android = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.high,
      priority: Priority.high,
      actions: withActions
          ? const <AndroidNotificationAction>[
              AndroidNotificationAction(
                NotificationActions.markComplete,
                'Mark Complete',
                showsUserInterface: true,
              ),
              AndroidNotificationAction(
                NotificationActions.openVehicle,
                'Open Vehicle',
                showsUserInterface: true,
              ),
              AndroidNotificationAction(
                NotificationActions.dismiss,
                'Dismiss',
                cancelNotification: true,
              ),
            ]
          : null,
    );

    const DarwinNotificationDetails darwin = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: android,
        iOS: darwin,
        macOS: darwin,
      ),
      payload: payload?.encode(),
    );
  }

  Future<void> cancel(int id) => _plugin.cancel(id: id);

  Future<void> cancelAll() => _plugin.cancelAll();

  /// Schedule a daily reminder at [hour]:[minute] local time (best-effort).
  Future<void> scheduleDailyCheck({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
    NotificationPayload? payload,
  }) async {
    if (!_initialized || kIsWeb) return;

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    try {
      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduled,
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload?.encode(),
      );
    } catch (e, st) {
      AppLogger.error('scheduleDailyCheck failed', error: e, stackTrace: st);
    }
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  // Background isolate — keep lightweight; foreground handler covers UI.
  AppLogger.info(
    'Background notification action: ${response.actionId} '
    'payload=${response.payload}',
  );
}
