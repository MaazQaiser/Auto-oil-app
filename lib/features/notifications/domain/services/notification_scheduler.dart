import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/utils/logger.dart';
import 'notification_service.dart';

/// Schedules recurring summary notifications and tracks dedupe keys.
class NotificationScheduler {
  NotificationScheduler(this._notifications, this._prefs);

  final NotificationService _notifications;
  final SharedPreferences _prefs;

  static const String _dedupePrefix = 'notif_dedupe_';
  static const int dailyCheckNotifId = 9001;
  static const int weeklySummaryNotifId = 9002;
  static const int monthlySummaryNotifId = 9003;

  /// Returns true if this [key] has not been used today (or ever for non-daily).
  bool shouldNotify(String key, {Duration cooldown = const Duration(hours: 20)}) {
    final String prefKey = '$_dedupePrefix$key';
    final int? millis = _prefs.getInt(prefKey);
    if (millis == null) return true;
    final DateTime last =
        DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true);
    return DateTime.now().toUtc().difference(last) >= cooldown;
  }

  Future<void> markNotified(String key) async {
    await _prefs.setInt(
      '$_dedupePrefix$key',
      DateTime.now().toUtc().millisecondsSinceEpoch,
    );
  }

  Future<void> scheduleMorningSummary({
    required int hour,
    required int minute,
  }) async {
    await _notifications.scheduleDailyCheck(
      id: dailyCheckNotifId,
      hour: hour,
      minute: minute,
      title: 'Morning Service Check',
      body: 'Open Muzammil Autos to review today\'s due vehicles.',
      payload: const NotificationPayload(
        type: 'morning_summary',
        route: '/reminders',
      ),
    );
    AppLogger.info('Morning summary scheduled at $hour:$minute');
  }

  Future<void> cancelScheduledSummaries() async {
    await _notifications.cancel(dailyCheckNotifId);
    await _notifications.cancel(weeklySummaryNotifId);
    await _notifications.cancel(monthlySummaryNotifId);
  }
}
