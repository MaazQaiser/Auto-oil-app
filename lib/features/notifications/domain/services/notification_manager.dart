import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../reminders/domain/entities/maintenance_reminder.dart';
import '../../../reminders/domain/entities/reminder_enums.dart';
import '../../../reminders/domain/repositories/reminder_repository.dart';
import '../../data/datasources/reminder_history_datasource.dart';
import '../entities/reminder_history_entry.dart';
import 'notification_permission_service.dart';
import 'notification_scheduler.dart';
import 'notification_service.dart';

/// High-level orchestrator: runs reminder checks and fires local notifications.
class NotificationManager {
  NotificationManager({
    required ReminderRepository reminderRepository,
    required NotificationService notificationService,
    required NotificationScheduler scheduler,
    required NotificationPermissionService permissionService,
    required ReminderHistoryDataSource historyDataSource,
    required bool Function() notificationsEnabled,
    required bool Function() weeklySummaryEnabled,
    required bool Function() monthlySummaryEnabled,
  })  : _reminders = reminderRepository,
        _notifications = notificationService,
        _scheduler = scheduler,
        _permissions = permissionService,
        _history = historyDataSource,
        _notificationsEnabled = notificationsEnabled,
        _weeklySummaryEnabled = weeklySummaryEnabled,
        _monthlySummaryEnabled = monthlySummaryEnabled;

  final ReminderRepository _reminders;
  final NotificationService _notifications;
  final NotificationScheduler _scheduler;
  final NotificationPermissionService _permissions;
  final ReminderHistoryDataSource _history;
  final bool Function() _notificationsEnabled;
  final bool Function() _weeklySummaryEnabled;
  final bool Function() _monthlySummaryEnabled;

  static const Uuid _uuid = Uuid();

  /// Recalculate statuses then emit due/overdue/upcoming/summary notifications.
  Future<int> runReminderCheck({bool forceSummaries = false}) async {
    final int updated = await _reminders.recalculateAllStatuses();
    await maybeNotifyActiveReminders(forceSummaries: forceSummaries);
    return updated;
  }

  Future<void> maybeNotifyActiveReminders({bool forceSummaries = false}) async {
    if (!_notificationsEnabled()) return;
    if (!await _permissions.isGranted()) return;
    if (!_notifications.isInitialized) return;

    final List<MaintenanceReminder> all = await _reminders.getAll();
    final List<MaintenanceReminder> active = all
        .where((r) => r.status != ReminderStatus.completed)
        .where((r) => r.notificationEnabled)
        .toList();

    final due = active.where((r) => r.status == ReminderStatus.due).toList();
    final overdue =
        active.where((r) => r.status == ReminderStatus.overdue).toList();
    final upcomingOneDay = active.where((r) {
      if (r.status != ReminderStatus.upcoming) return false;
      final days = r.remainingDays;
      return days != null && days == 1;
    }).toList();

    final String todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (due.isNotEmpty &&
        (forceSummaries ||
            await _scheduler.shouldNotify('due_today_$todayKey'))) {
      await _notifications.show(
        id: 1001,
        title: 'Maintenance Due Today',
        body:
            '${due.length} vehicle${due.length == 1 ? '' : 's'} require maintenance today.',
        payload: const NotificationPayload(
          type: 'due_today',
          route: '/reminders',
        ),
        withActions: false,
      );
      await _scheduler.markNotified('due_today_$todayKey');
      await _logNotification(
        title: 'Maintenance Due Today',
        details: '${due.length} due today',
      );
    }

    for (final r in overdue.take(5)) {
      final String key = 'overdue_${r.id}_$todayKey';
      if (!forceSummaries && !await _scheduler.shouldNotify(key)) continue;
      final int daysLate = -(r.remainingDays ?? 0);
      await _notifications.show(
        id: _stableId('overdue_${r.id}'),
        title: 'Vehicle Overdue',
        body:
            '${r.vehicleDisplayName ?? 'Vehicle'} ${r.registrationNumber ?? ''} '
            'is overdue${daysLate > 0 ? ' by $daysLate days' : ''}.'
                .replaceAll(RegExp(r'\s+'), ' ')
                .trim(),
        payload: NotificationPayload(
          type: 'overdue',
          reminderId: r.id,
          vehicleId: r.vehicleId,
          route: '/reminders/${r.id}',
        ),
      );
      await _scheduler.markNotified(key);
      await _logNotification(
        reminderId: r.id,
        vehicleId: r.vehicleId,
        customerId: r.customerId,
        title: 'Vehicle Overdue',
        details: r.registrationNumber,
      );
    }

    for (final r in upcomingOneDay.take(5)) {
      final String key = 'upcoming1_${r.id}_$todayKey';
      if (!forceSummaries && !await _scheduler.shouldNotify(key)) continue;
      await _notifications.show(
        id: _stableId('upcoming_${r.id}'),
        title: 'Maintenance Tomorrow',
        body:
            '${r.vehicleDisplayName ?? 'Vehicle'} (${r.registrationNumber ?? '—'}) '
            'is due tomorrow.',
        payload: NotificationPayload(
          type: 'upcoming',
          reminderId: r.id,
          vehicleId: r.vehicleId,
          route: '/reminders/${r.id}',
        ),
      );
      await _scheduler.markNotified(key);
      await _logNotification(
        reminderId: r.id,
        vehicleId: r.vehicleId,
        customerId: r.customerId,
        title: 'Maintenance Tomorrow',
        details: r.registrationNumber,
      );
    }

    await _maybeWeeklySummary(all, force: forceSummaries);
    await _maybeMonthlySummary(all, force: forceSummaries);
  }

  Future<void> _maybeWeeklySummary(
    List<MaintenanceReminder> all, {
    required bool force,
  }) async {
    if (!_weeklySummaryEnabled()) return;
    final DateTime now = DateTime.now();
    // Monday morning summary window
    if (!force && now.weekday != DateTime.monday) return;
    final String weekKey =
        'weekly_${now.year}_w${_weekOfYear(now)}';
    if (!force &&
        !await _scheduler.shouldNotify(weekKey, cooldown: const Duration(days: 6))) {
      return;
    }

    final due = all.where((r) => r.status == ReminderStatus.due).length;
    final overdue = all.where((r) => r.status == ReminderStatus.overdue).length;
    final upcoming =
        all.where((r) => r.status == ReminderStatus.upcoming).length;

    await _notifications.show(
      id: NotificationScheduler.weeklySummaryNotifId,
      title: 'Weekly Reminder Summary',
      body: 'Due: $due · Overdue: $overdue · Upcoming: $upcoming',
      payload: const NotificationPayload(
        type: 'weekly_summary',
        route: '/reminders',
      ),
      withActions: false,
    );
    await _scheduler.markNotified(weekKey);
    await _logNotification(
      title: 'Weekly Reminder Summary',
      details: 'Due $due, Overdue $overdue, Upcoming $upcoming',
    );
  }

  Future<void> _maybeMonthlySummary(
    List<MaintenanceReminder> all, {
    required bool force,
  }) async {
    if (!_monthlySummaryEnabled()) return;
    final DateTime now = DateTime.now();
    if (!force && now.day != 1) return;
    final String monthKey = 'monthly_${now.year}_${now.month}';
    if (!force &&
        !await _scheduler.shouldNotify(monthKey, cooldown: const Duration(days: 27))) {
      return;
    }

    final completed =
        all.where((r) => r.status == ReminderStatus.completed).length;
    final active = all.where((r) => r.status != ReminderStatus.completed).length;

    await _notifications.show(
      id: NotificationScheduler.monthlySummaryNotifId,
      title: 'Monthly Reminder Summary',
      body: 'Active reminders: $active · Completed: $completed',
      payload: const NotificationPayload(
        type: 'monthly_summary',
        route: '/reminders',
      ),
      withActions: false,
    );
    await _scheduler.markNotified(monthKey);
    await _logNotification(
      title: 'Monthly Reminder Summary',
      details: 'Active $active, Completed $completed',
    );
  }

  Future<void> notifySingle(MaintenanceReminder reminder) async {
    if (!_notificationsEnabled()) return;
    if (!reminder.notificationEnabled) return;
    if (!await _permissions.ensureGranted()) return;

    await _notifications.show(
      id: _stableId('manual_${reminder.id}'),
      title: 'Service Reminder',
      body:
          '${reminder.vehicleDisplayName ?? 'Vehicle'} · '
          '${reminder.registrationNumber ?? ''}',
      payload: NotificationPayload(
        type: 'manual',
        reminderId: reminder.id,
        vehicleId: reminder.vehicleId,
        route: '/reminders/${reminder.id}',
      ),
    );
    await _logNotification(
      reminderId: reminder.id,
      vehicleId: reminder.vehicleId,
      customerId: reminder.customerId,
      title: 'Service Reminder',
      details: 'Manual notify',
    );
  }

  Future<void> _logNotification({
    String? reminderId,
    String? vehicleId,
    String? customerId,
    String? title,
    String? details,
  }) async {
    await _history.insert(
      ReminderHistoryEntry(
        id: _uuid.v4(),
        reminderId: reminderId,
        vehicleId: vehicleId,
        customerId: customerId,
        actionType: ReminderHistoryAction.notificationSent,
        title: title,
        details: details,
        createdAt: DateTime.now(),
      ),
    );
  }

  int _stableId(String key) => key.hashCode & 0x7fffffff;

  int _weekOfYear(DateTime date) {
    final DateTime firstDay = DateTime(date.year);
    final int days = date.difference(firstDay).inDays;
    return (days / 7).floor() + 1;
  }
}
