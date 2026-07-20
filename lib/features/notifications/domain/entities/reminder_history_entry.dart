import 'package:equatable/equatable.dart';

enum ReminderHistoryAction {
  reminderSent,
  notificationSent,
  whatsappOpened,
  completed,
  dismissed;

  String get storageValue => switch (this) {
        ReminderHistoryAction.reminderSent => 'reminder_sent',
        ReminderHistoryAction.notificationSent => 'notification_sent',
        ReminderHistoryAction.whatsappOpened => 'whatsapp_opened',
        ReminderHistoryAction.completed => 'completed',
        ReminderHistoryAction.dismissed => 'dismissed',
      };

  String get label => switch (this) {
        ReminderHistoryAction.reminderSent => 'Reminder Sent',
        ReminderHistoryAction.notificationSent => 'Notification Sent',
        ReminderHistoryAction.whatsappOpened => 'WhatsApp Opened',
        ReminderHistoryAction.completed => 'Completed',
        ReminderHistoryAction.dismissed => 'Dismissed',
      };

  static ReminderHistoryAction fromStorage(String value) {
    return ReminderHistoryAction.values.firstWhere(
      (e) => e.storageValue == value,
      orElse: () => ReminderHistoryAction.reminderSent,
    );
  }
}

class ReminderHistoryEntry extends Equatable {
  const ReminderHistoryEntry({
    required this.id,
    this.reminderId,
    this.vehicleId,
    this.customerId,
    required this.actionType,
    this.title,
    this.details,
    required this.createdAt,
  });

  final String id;
  final String? reminderId;
  final String? vehicleId;
  final String? customerId;
  final ReminderHistoryAction actionType;
  final String? title;
  final String? details;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        id,
        reminderId,
        vehicleId,
        customerId,
        actionType,
        title,
        details,
        createdAt,
      ];
}
