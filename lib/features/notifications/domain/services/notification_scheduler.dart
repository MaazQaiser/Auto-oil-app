import '../../../../core/sync/sync_outbox_datasource.dart';
import '../../../../core/utils/logger.dart';
import 'notification_service.dart';

/// Schedules recurring summary notifications and tracks dedupe keys locally.
class NotificationScheduler {
  NotificationScheduler(this._notifications, this._deviceState);

  final NotificationService _notifications;
  final SyncOutboxDataSource _deviceState;

  static const String _dedupePrefix = 'notif_dedupe_';
  static const int dailyCheckNotifId = 9001;
  static const int weeklySummaryNotifId = 9002;
  static const int monthlySummaryNotifId = 9003;

  /// Returns true if this [key] has not been used within [cooldown].
  Future<bool> shouldNotify(
    String key, {
    Duration cooldown = const Duration(hours: 20),
  }) async {
    final String prefKey = '$_dedupePrefix$key';
    final String? raw = await _deviceState.getMeta(prefKey);
    if (raw == null) return true;
    final int? millis = int.tryParse(raw);
    if (millis == null) return true;
    final DateTime last =
        DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true);
    return DateTime.now().toUtc().difference(last) >= cooldown;
  }

  Future<void> markNotified(String key) async {
    await _deviceState.setMeta(
      '$_dedupePrefix$key',
      DateTime.now().toUtc().millisecondsSinceEpoch.toString(),
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
