import 'package:uuid/uuid.dart';

import '../../../../core/utils/logger.dart';
import '../../../service_records/domain/entities/service_record.dart';
import '../../domain/entities/maintenance_reminder.dart';
import '../../domain/entities/reminder_enums.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../../domain/services/reminder_calculator.dart';

/// Orchestrates reminder create/update/delete from service records.
class ReminderService {
  ReminderService(
    this._repository, {
    ReminderCalculator? calculator,
  }) : _calculator = calculator ?? const ReminderCalculator();

  final ReminderRepository _repository;
  final ReminderCalculator _calculator;
  static const _uuid = Uuid();

  /// Creates or updates a reminder when a service record is saved.
  Future<MaintenanceReminder?> syncFromServiceRecord(
    ServiceRecord record,
  ) async {
    if (!record.reminderEnabled || record.reminderType == null) {
      await _repository.deleteByServiceRecordId(record.id);
      AppLogger.info('Reminder skipped/removed for service ${record.id}');
      return null;
    }

    final ReminderType type = record.reminderType!;
    if (type == ReminderType.km && record.nextServiceOdometer == null) {
      return null;
    }
    if (type == ReminderType.date && record.nextServiceDate == null) {
      return null;
    }
    if (type == ReminderType.both &&
        record.nextServiceOdometer == null &&
        record.nextServiceDate == null) {
      return null;
    }

    final ReminderStatus status = _calculator.calculateStatus(
      type: type,
      currentOdometer: record.odometerReading,
      nextServiceOdometer: record.nextServiceOdometer,
      nextServiceDate: record.nextServiceDate,
    );

    final existing = await _repository.getByServiceRecordId(record.id);
    final DateTime now = DateTime.now();

    if (existing != null) {
      final updated = existing.copyWith(
        vehicleId: record.vehicleId,
        currentOdometer: record.odometerReading,
        nextServiceOdometer: record.nextServiceOdometer,
        lastServiceDate: record.serviceDate,
        nextServiceDate: record.nextServiceDate,
        reminderType: type,
        status: existing.status == ReminderStatus.completed
            ? ReminderStatus.completed
            : status,
        notificationEnabled: record.reminderEnabled,
        whatsappEnabled: record.whatsappEnabled,
        updatedAt: now,
      );
      return _repository.updateReminder(updated);
    }

    final reminder = MaintenanceReminder(
      id: _uuid.v4(),
      vehicleId: record.vehicleId,
      serviceRecordId: record.id,
      currentOdometer: record.odometerReading,
      nextServiceOdometer: record.nextServiceOdometer,
      lastServiceDate: record.serviceDate,
      nextServiceDate: record.nextServiceDate,
      reminderType: type,
      status: status,
      notificationEnabled: record.reminderEnabled,
      whatsappEnabled: record.whatsappEnabled,
      createdAt: now,
      updatedAt: now,
    );
    return _repository.createReminder(reminder);
  }

  Future<void> deleteForServiceRecord(String serviceRecordId) {
    return _repository.deleteByServiceRecordId(serviceRecordId);
  }

  Future<MaintenanceReminder> markCompleted(String reminderId) async {
    final existing = await _repository.getById(reminderId);
    if (existing == null) {
      throw StateError('Reminder not found');
    }
    return _repository.updateReminder(
      existing.copyWith(
        status: ReminderStatus.completed,
        updatedAt: DateTime.now(),
      ),
    );
  }

  Future<MaintenanceReminder> updateReminder(MaintenanceReminder reminder) {
    final status = reminder.status == ReminderStatus.completed
        ? ReminderStatus.completed
        : _calculator.calculateStatus(
            type: reminder.reminderType,
            currentOdometer: reminder.currentOdometer,
            nextServiceOdometer: reminder.nextServiceOdometer,
            nextServiceDate: reminder.nextServiceDate,
          );
    return _repository.updateReminder(
      reminder.copyWith(status: status, updatedAt: DateTime.now()),
    );
  }
}
