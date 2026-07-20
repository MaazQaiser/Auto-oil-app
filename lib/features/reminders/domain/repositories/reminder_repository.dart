import '../entities/maintenance_reminder.dart';
import '../entities/reminder_enums.dart';

abstract class ReminderRepository {
  Future<MaintenanceReminder> createReminder(MaintenanceReminder reminder);

  Future<MaintenanceReminder> updateReminder(MaintenanceReminder reminder);

  Future<void> deleteReminder(String id);

  Future<void> deleteByServiceRecordId(String serviceRecordId);

  Future<MaintenanceReminder?> getById(String id);

  Future<MaintenanceReminder?> getByServiceRecordId(String serviceRecordId);

  Future<List<MaintenanceReminder>> getAll({ReminderStatus? status});

  Future<List<MaintenanceReminder>> getByVehicle(String vehicleId);

  Future<MaintenanceReminder?> getActiveForVehicle(String vehicleId);

  Stream<List<MaintenanceReminder>> watchAll();

  Stream<List<MaintenanceReminder>> watchByStatus(ReminderStatus status);

  Future<ReminderSummary> getSummary();

  Future<List<MaintenanceReminder>> search(String query);

  Future<int> countByStatus(ReminderStatus status);

  /// Updates currentOdometer from vehicle and recalculates status for all
  /// non-completed reminders.
  Future<int> recalculateAllStatuses();
}
