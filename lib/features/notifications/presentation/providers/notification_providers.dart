import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/services/background/background_work.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../../../shared/providers/database_provider.dart';
import '../../../customers/presentation/providers/customer_providers.dart';
import '../../../reminders/domain/entities/maintenance_reminder.dart';
import '../../../reminders/presentation/providers/reminder_providers.dart';
import '../../../settings/providers/settings_provider.dart';
import '../../data/datasources/message_template_datasource.dart';
import '../../data/datasources/reminder_history_datasource.dart';
import '../../domain/entities/message_context.dart';
import '../../domain/entities/message_template.dart';
import '../../domain/entities/reminder_history_entry.dart';
import '../../domain/services/local_whatsapp_service.dart';
import '../../domain/services/message_composer.dart';
import '../../domain/services/messaging_service.dart';
import '../../domain/services/notification_manager.dart';
import '../../domain/services/notification_permission_service.dart';
import '../../domain/services/notification_scheduler.dart';
import '../../domain/services/notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final notificationPermissionServiceProvider =
    Provider<NotificationPermissionService>((ref) {
  return NotificationPermissionService();
});

final notificationSchedulerProvider = Provider<NotificationScheduler>((ref) {
  return NotificationScheduler(
    ref.watch(notificationServiceProvider),
    ref.watch(syncOutboxDataSourceProvider),
  );
});

final messageTemplateDataSourceProvider =
    Provider<MessageTemplateDataSource>((ref) {
  return MessageTemplateDataSource(
    ref.watch(databaseProvider),
    ref.watch(syncQueueProvider),
  );
});

final reminderHistoryDataSourceProvider =
    Provider<ReminderHistoryDataSource>((ref) {
  return ReminderHistoryDataSource(
    ref.watch(databaseProvider),
    ref.watch(syncQueueProvider),
  );
});

final messagingServiceProvider = Provider<MessagingService>((ref) {
  // Swap to WhatsAppBusinessCloudService when Cloud API is ready.
  return LocalWhatsAppService();
});

final messageComposerProvider = Provider<MessageComposer>((ref) {
  return const MessageComposer();
});

final notificationManagerProvider = Provider<NotificationManager>((ref) {
  final settings = ref.watch(settingsServiceProvider);
  return NotificationManager(
    reminderRepository: ref.watch(reminderRepositoryProvider),
    notificationService: ref.watch(notificationServiceProvider),
    scheduler: ref.watch(notificationSchedulerProvider),
    permissionService: ref.watch(notificationPermissionServiceProvider),
    historyDataSource: ref.watch(reminderHistoryDataSourceProvider),
    notificationsEnabled: () => settings.notificationsEnabled,
    weeklySummaryEnabled: () => settings.weeklySummaryEnabled,
    monthlySummaryEnabled: () => settings.monthlySummaryEnabled,
  );
});

final messageTemplatesProvider = StreamProvider<List<MessageTemplate>>((ref) {
  return ref.watch(messageTemplateDataSourceProvider).watchAll();
});

final reminderHistoryProvider =
    StreamProvider<List<ReminderHistoryEntry>>((ref) {
  return ref.watch(reminderHistoryDataSourceProvider).watchRecent();
});

/// Multi-select queue for bulk WhatsApp / complete / dismiss.
final reminderSelectionProvider =
    StateProvider<Set<String>>((ref) => <String>{});

final reminderSelectionModeProvider = StateProvider<bool>((ref) => false);

class WhatsAppReminderHelper {
  WhatsAppReminderHelper(this._ref);

  final Ref _ref;
  static const Uuid _uuid = Uuid();

  Future<MessageContext> buildContext(MaintenanceReminder reminder) async {
    String? phone;
    String? wa;
    if (reminder.customerId != null) {
      final customer = await _ref
          .read(customerRepositoryProvider)
          .getCustomerById(reminder.customerId!);
      phone = customer?.phoneNumber;
      wa = customer?.whatsappNumber;
    }
    return MessageContext.fromReminder(
      reminder: reminder,
      workshopName: AppConfig.workshopName,
      phoneNumber: phone,
      whatsappNumber: wa,
    );
  }

  Future<String> defaultMessage(MaintenanceReminder reminder) async {
    final ctx = await buildContext(reminder);
    final templates =
        await _ref.read(messageTemplateDataSourceProvider).getAll();
    final settings = _ref.read(settingsServiceProvider);
    MessageTemplate? preferred;
    final String? preferredId = settings.defaultMessageTemplateId;
    if (preferredId != null) {
      preferred = templates.where((t) => t.id == preferredId).firstOrNull;
    }
    preferred ??= templates.where((t) {
      if (reminder.status.name == 'overdue') {
        return t.category == MessageTemplateCategory.overdue;
      }
      return t.category == MessageTemplateCategory.regularMaintenance ||
          t.category == MessageTemplateCategory.oilChange;
    }).firstOrNull;
    preferred ??= templates.isEmpty ? null : templates.first;

    final String body = preferred?.body ?? kDefaultWhatsAppTemplate;
    return _ref.read(messageComposerProvider).compose(body, ctx);
  }

  Future<bool> openWhatsApp({
    required MaintenanceReminder reminder,
    required String message,
  }) async {
    final ctx = await buildContext(reminder);
    final phone = ctx.preferredPhone;
    if (phone.isEmpty) return false;

    final messaging = _ref.read(messagingServiceProvider);
    final ok = await messaging.sendMessage(phone: phone, message: message);
    if (ok) {
      await _ref.read(reminderHistoryDataSourceProvider).insert(
            ReminderHistoryEntry(
              id: _uuid.v4(),
              reminderId: reminder.id,
              vehicleId: reminder.vehicleId,
              customerId: reminder.customerId,
              actionType: ReminderHistoryAction.whatsappOpened,
              title: 'WhatsApp Opened',
              details: reminder.registrationNumber,
              createdAt: DateTime.now(),
            ),
          );
      final updated = reminder.copyWith(lastReminderSent: DateTime.now());
      await _ref.read(reminderRepositoryProvider).updateReminder(updated);
    }
    return ok;
  }

  Future<void> logCompleted(MaintenanceReminder reminder) async {
    await _ref.read(reminderHistoryDataSourceProvider).insert(
          ReminderHistoryEntry(
            id: _uuid.v4(),
            reminderId: reminder.id,
            vehicleId: reminder.vehicleId,
            customerId: reminder.customerId,
            actionType: ReminderHistoryAction.completed,
            title: 'Completed',
            details: reminder.registrationNumber,
            createdAt: DateTime.now(),
          ),
        );
  }

  Future<void> logDismissed(MaintenanceReminder reminder) async {
    await _ref.read(reminderHistoryDataSourceProvider).insert(
          ReminderHistoryEntry(
            id: _uuid.v4(),
            reminderId: reminder.id,
            vehicleId: reminder.vehicleId,
            customerId: reminder.customerId,
            actionType: ReminderHistoryAction.dismissed,
            title: 'Dismissed',
            details: reminder.registrationNumber,
            createdAt: DateTime.now(),
          ),
        );
  }
}

final whatsAppReminderHelperProvider = Provider<WhatsAppReminderHelper>((ref) {
  return WhatsAppReminderHelper(ref);
});

/// Bootstraps notifications, templates, and background tasks once.
final notificationBootstrapProvider = FutureProvider<void>((ref) async {
  final settings = ref.read(settingsServiceProvider);
  final notifications = ref.read(notificationServiceProvider);
  final permissions = ref.read(notificationPermissionServiceProvider);
  final templates = ref.read(messageTemplateDataSourceProvider);
  final manager = ref.read(notificationManagerProvider);
  final scheduler = ref.read(notificationSchedulerProvider);

  await templates.seedDefaultsIfEmpty();
  await notifications.initialize(
    onTap: (payload, actionId) {
      // Navigation handled via pending payload provider below.
      ref.read(pendingNotificationPayloadProvider.notifier).state =
          PendingNotification(payload: payload, actionId: actionId);
    },
  );

  if (settings.notificationsEnabled) {
    await permissions.ensureGranted();
    await initializeBackgroundWork();
    await registerBackgroundTasks(
      dailyHour: settings.dailyReminderHour,
      dailyMinute: settings.dailyReminderMinute,
    );
    await scheduler.scheduleMorningSummary(
      hour: settings.dailyReminderHour,
      minute: settings.dailyReminderMinute,
    );
  }

  await manager.runReminderCheck();
});

class PendingNotification {
  const PendingNotification({this.payload, this.actionId});
  final NotificationPayload? payload;
  final String? actionId;
}

final pendingNotificationPayloadProvider =
    StateProvider<PendingNotification?>((ref) => null);

String resolveNotificationRoute(PendingNotification pending) {
  final payload = pending.payload;
  if (payload?.route != null) return payload!.route!;
  if (payload?.reminderId != null) {
    return AppRoutes.reminderDetailPath(payload!.reminderId!);
  }
  if (pending.actionId == NotificationActions.openVehicle &&
      payload?.vehicleId != null) {
    return AppRoutes.vehicleDetailPath(payload!.vehicleId!);
  }
  return AppRoutes.reminders;
}
