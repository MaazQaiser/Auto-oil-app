import 'package:equatable/equatable.dart';

import 'reminder_enums.dart';

/// Domain entity for a maintenance reminder.
class MaintenanceReminder extends Equatable {
  const MaintenanceReminder({
    required this.id,
    required this.vehicleId,
    required this.serviceRecordId,
    required this.currentOdometer,
    this.nextServiceOdometer,
    required this.lastServiceDate,
    this.nextServiceDate,
    required this.reminderType,
    required this.status,
    this.lastReminderSent,
    this.notificationEnabled = true,
    this.whatsappEnabled = false,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.vehicleDisplayName,
    this.registrationNumber,
    this.ownerName,
    this.customerId,
  });

  final String id;
  final String vehicleId;
  final String serviceRecordId;
  final int currentOdometer;
  final int? nextServiceOdometer;
  final DateTime lastServiceDate;
  final DateTime? nextServiceDate;
  final ReminderType reminderType;
  final ReminderStatus status;
  final DateTime? lastReminderSent;
  final bool notificationEnabled;
  final bool whatsappEnabled;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Joined display fields.
  final String? vehicleDisplayName;
  final String? registrationNumber;
  final String? ownerName;
  final String? customerId;

  int? get remainingKm {
    if (nextServiceOdometer == null) return null;
    return nextServiceOdometer! - currentOdometer;
  }

  int? get remainingDays {
    if (nextServiceDate == null) return null;
    final DateTime today = DateTime.now();
    final DateTime start = DateTime(today.year, today.month, today.day);
    final DateTime next = DateTime(
      nextServiceDate!.year,
      nextServiceDate!.month,
      nextServiceDate!.day,
    );
    return next.difference(start).inDays;
  }

  MaintenanceReminder copyWith({
    String? id,
    String? vehicleId,
    String? serviceRecordId,
    int? currentOdometer,
    int? nextServiceOdometer,
    DateTime? lastServiceDate,
    DateTime? nextServiceDate,
    ReminderType? reminderType,
    ReminderStatus? status,
    DateTime? lastReminderSent,
    bool? notificationEnabled,
    bool? whatsappEnabled,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? vehicleDisplayName,
    String? registrationNumber,
    String? ownerName,
    String? customerId,
  }) {
    return MaintenanceReminder(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      serviceRecordId: serviceRecordId ?? this.serviceRecordId,
      currentOdometer: currentOdometer ?? this.currentOdometer,
      nextServiceOdometer: nextServiceOdometer ?? this.nextServiceOdometer,
      lastServiceDate: lastServiceDate ?? this.lastServiceDate,
      nextServiceDate: nextServiceDate ?? this.nextServiceDate,
      reminderType: reminderType ?? this.reminderType,
      status: status ?? this.status,
      lastReminderSent: lastReminderSent ?? this.lastReminderSent,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
      whatsappEnabled: whatsappEnabled ?? this.whatsappEnabled,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      vehicleDisplayName: vehicleDisplayName ?? this.vehicleDisplayName,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      ownerName: ownerName ?? this.ownerName,
      customerId: customerId ?? this.customerId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        vehicleId,
        serviceRecordId,
        currentOdometer,
        nextServiceOdometer,
        lastServiceDate,
        nextServiceDate,
        reminderType,
        status,
        lastReminderSent,
        notificationEnabled,
        whatsappEnabled,
        notes,
        createdAt,
        updatedAt,
        vehicleDisplayName,
        registrationNumber,
        ownerName,
        customerId,
      ];
}

/// Aggregated counts for dashboard / summary chips.
class ReminderSummary extends Equatable {
  const ReminderSummary({
    this.dueToday = 0,
    this.upcoming = 0,
    this.overdue = 0,
    this.completed = 0,
    this.next7Days = 0,
  });

  final int dueToday;
  final int upcoming;
  final int overdue;
  final int completed;
  final int next7Days;

  int get activeTotal => dueToday + upcoming + overdue;

  @override
  List<Object?> get props =>
      [dueToday, upcoming, overdue, completed, next7Days];
}
