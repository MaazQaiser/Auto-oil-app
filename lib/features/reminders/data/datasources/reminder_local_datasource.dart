import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/maintenance_reminder.dart';
import '../../domain/entities/reminder_enums.dart';
import '../../domain/services/reminder_calculator.dart';

class ReminderLocalDataSource {
  ReminderLocalDataSource(this._db, {ReminderCalculator? calculator})
      : _calculator = calculator ?? const ReminderCalculator();

  final AppDatabase _db;
  final ReminderCalculator _calculator;

  MaintenanceReminder _toEntity(
    MaintenanceReminderRow row, {
    String? vehicleName,
    String? reg,
    String? owner,
    String? customerId,
  }) {
    return MaintenanceReminder(
      id: row.id,
      vehicleId: row.vehicleId,
      serviceRecordId: row.serviceRecordId,
      currentOdometer: row.currentOdometer,
      nextServiceOdometer: row.nextServiceOdometer,
      lastServiceDate: row.lastServiceDate,
      nextServiceDate: row.nextServiceDate,
      reminderType: ReminderType.fromStorage(row.reminderType),
      status: ReminderStatus.fromStorage(row.status),
      lastReminderSent: row.lastReminderSent,
      notificationEnabled: row.notificationEnabled,
      whatsappEnabled: row.whatsappEnabled,
      notes: row.notes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      vehicleDisplayName: vehicleName,
      registrationNumber: reg,
      ownerName: owner,
      customerId: customerId,
    );
  }

  MaintenanceRemindersCompanion _toCompanion(MaintenanceReminder r) {
    return MaintenanceRemindersCompanion(
      id: Value(r.id),
      vehicleId: Value(r.vehicleId),
      serviceRecordId: Value(r.serviceRecordId),
      currentOdometer: Value(r.currentOdometer),
      nextServiceOdometer: Value(r.nextServiceOdometer),
      lastServiceDate: Value(r.lastServiceDate),
      nextServiceDate: Value(r.nextServiceDate),
      reminderType: Value(r.reminderType.name),
      status: Value(r.status.name),
      lastReminderSent: Value(r.lastReminderSent),
      notificationEnabled: Value(r.notificationEnabled),
      whatsappEnabled: Value(r.whatsappEnabled),
      notes: Value(r.notes),
      createdAt: Value(r.createdAt),
      updatedAt: Value(r.updatedAt),
    );
  }

  JoinedSelectStatement _joinedQuery() {
    return _db.select(_db.maintenanceReminders).join([
      innerJoin(
        _db.vehicles,
        _db.vehicles.id.equalsExp(_db.maintenanceReminders.vehicleId),
      ),
      innerJoin(
        _db.customers,
        _db.customers.id.equalsExp(_db.vehicles.customerId),
      ),
    ]);
  }

  MaintenanceReminder _mapJoined(TypedResult row) {
    final r = row.readTable(_db.maintenanceReminders);
    final v = row.readTable(_db.vehicles);
    final c = row.readTable(_db.customers);
    return _toEntity(
      r,
      vehicleName: '${v.make} ${v.model}',
      reg: v.registrationNumber,
      owner: c.fullName,
      customerId: c.id,
    );
  }

  Future<MaintenanceReminder> insert(MaintenanceReminder reminder) async {
    try {
      await _db
          .into(_db.maintenanceReminders)
          .insert(_toCompanion(reminder));
      return (await getById(reminder.id)) ?? reminder;
    } catch (e) {
      throw DatabaseException('Failed to create reminder: $e');
    }
  }

  Future<MaintenanceReminder> update(MaintenanceReminder reminder) async {
    try {
      final int n = await (_db.update(_db.maintenanceReminders)
            ..where((t) => t.id.equals(reminder.id)))
          .write(_toCompanion(reminder));
      if (n == 0) throw const NotFoundException('Reminder not found');
      return (await getById(reminder.id)) ?? reminder;
    } on NotFoundException {
      rethrow;
    } catch (e) {
      throw DatabaseException('Failed to update reminder: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      final int n = await (_db.delete(_db.maintenanceReminders)
            ..where((t) => t.id.equals(id)))
          .go();
      if (n == 0) throw const NotFoundException('Reminder not found');
    } on NotFoundException {
      rethrow;
    } catch (e) {
      throw DatabaseException('Failed to delete reminder: $e');
    }
  }

  Future<List<String>> deleteByServiceRecordId(String serviceRecordId) async {
    try {
      final existing = await (_db.select(_db.maintenanceReminders)
            ..where((t) => t.serviceRecordId.equals(serviceRecordId)))
          .get();
      final ids = existing.map((r) => r.id).toList();
      if (ids.isEmpty) return ids;
      await (_db.delete(_db.maintenanceReminders)
            ..where((t) => t.serviceRecordId.equals(serviceRecordId)))
          .go();
      return ids;
    } catch (e) {
      throw DatabaseException('Failed to delete reminder by service: $e');
    }
  }

  Future<MaintenanceReminder?> getById(String id) async {
    try {
      final query = _joinedQuery()
        ..where(_db.maintenanceReminders.id.equals(id));
      final row = await query.getSingleOrNull();
      return row == null ? null : _mapJoined(row);
    } catch (e) {
      throw DatabaseException('Failed to get reminder: $e');
    }
  }

  Future<MaintenanceReminder?> getByServiceRecordId(String serviceRecordId) async {
    try {
      final query = _joinedQuery()
        ..where(
          _db.maintenanceReminders.serviceRecordId.equals(serviceRecordId),
        );
      final row = await query.getSingleOrNull();
      return row == null ? null : _mapJoined(row);
    } catch (e) {
      throw DatabaseException('Failed to get reminder by service: $e');
    }
  }

  Future<List<MaintenanceReminder>> getAll({ReminderStatus? status}) async {
    try {
      final query = _joinedQuery()
        ..orderBy([OrderingTerm.asc(_db.maintenanceReminders.nextServiceDate)]);
      if (status != null) {
        query.where(_db.maintenanceReminders.status.equals(status.name));
      }
      final rows = await query.get();
      return rows.map(_mapJoined).toList();
    } catch (e) {
      throw DatabaseException('Failed to load reminders: $e');
    }
  }

  Future<List<MaintenanceReminder>> getByVehicle(String vehicleId) async {
    try {
      final query = _joinedQuery()
        ..where(_db.maintenanceReminders.vehicleId.equals(vehicleId))
        ..orderBy([OrderingTerm.desc(_db.maintenanceReminders.updatedAt)]);
      final rows = await query.get();
      return rows.map(_mapJoined).toList();
    } catch (e) {
      throw DatabaseException('Failed to load vehicle reminders: $e');
    }
  }

  Future<MaintenanceReminder?> getActiveForVehicle(String vehicleId) async {
    try {
      final query = _joinedQuery()
        ..where(
          _db.maintenanceReminders.vehicleId.equals(vehicleId) &
              _db.maintenanceReminders.status
                  .isNotValue(ReminderStatus.completed.name),
        )
        ..orderBy([OrderingTerm.desc(_db.maintenanceReminders.updatedAt)]);
      final rows = await query.get();
      if (rows.isEmpty) return null;
      // Prefer overdue > due > upcoming
      final list = rows.map(_mapJoined).toList();
      list.sort((a, b) => _statusRank(b.status).compareTo(_statusRank(a.status)));
      return list.first;
    } catch (e) {
      throw DatabaseException('Failed to get active reminder: $e');
    }
  }

  int _statusRank(ReminderStatus s) => switch (s) {
        ReminderStatus.overdue => 3,
        ReminderStatus.due => 2,
        ReminderStatus.upcoming => 1,
        ReminderStatus.completed => 0,
      };

  Stream<List<MaintenanceReminder>> watchAll() {
    final query = _joinedQuery()
      ..orderBy([OrderingTerm.asc(_db.maintenanceReminders.nextServiceDate)]);
    return query.watch().map((rows) => rows.map(_mapJoined).toList());
  }

  Stream<List<MaintenanceReminder>> watchByStatus(ReminderStatus status) {
    final query = _joinedQuery()
      ..where(_db.maintenanceReminders.status.equals(status.name))
      ..orderBy([OrderingTerm.asc(_db.maintenanceReminders.nextServiceDate)]);
    return query.watch().map((rows) => rows.map(_mapJoined).toList());
  }

  Future<List<MaintenanceReminder>> search(String queryText) async {
    try {
      final String pattern = '%${queryText.trim().toLowerCase()}%';
      final query = _joinedQuery()
        ..where(
          _db.vehicles.registrationNumber.lower().like(pattern) |
              _db.vehicles.make.lower().like(pattern) |
              _db.vehicles.model.lower().like(pattern) |
              _db.customers.fullName.lower().like(pattern),
        )
        ..orderBy([OrderingTerm.asc(_db.maintenanceReminders.nextServiceDate)]);
      final rows = await query.get();
      return rows.map(_mapJoined).toList();
    } catch (e) {
      throw DatabaseException('Failed to search reminders: $e');
    }
  }

  Future<int> countByStatus(ReminderStatus status) async {
    try {
      final countExp = _db.maintenanceReminders.id.count();
      final query = _db.selectOnly(_db.maintenanceReminders)
        ..addColumns([countExp])
        ..where(_db.maintenanceReminders.status.equals(status.name));
      final row = await query.getSingle();
      return row.read(countExp) ?? 0;
    } catch (e) {
      throw DatabaseException('Failed to count reminders: $e');
    }
  }

  Future<ReminderSummary> getSummary() async {
    try {
      final all = await getAll();
      final DateTime today = DateTime.now();
      final DateTime todayOnly =
          DateTime(today.year, today.month, today.day);
      final DateTime weekEnd = todayOnly.add(const Duration(days: 7));

      int dueToday = 0;
      int upcoming = 0;
      int overdue = 0;
      int completed = 0;
      int next7Days = 0;

      for (final r in all) {
        switch (r.status) {
          case ReminderStatus.due:
            dueToday++;
          case ReminderStatus.upcoming:
            upcoming++;
            if (r.nextServiceDate != null) {
              final d = DateTime(
                r.nextServiceDate!.year,
                r.nextServiceDate!.month,
                r.nextServiceDate!.day,
              );
              if (!d.isBefore(todayOnly) && !d.isAfter(weekEnd)) {
                next7Days++;
              }
            }
          case ReminderStatus.overdue:
            overdue++;
          case ReminderStatus.completed:
            completed++;
        }
      }

      // Also count due-today by date equality among due status
      return ReminderSummary(
        dueToday: dueToday,
        upcoming: upcoming,
        overdue: overdue,
        completed: completed,
        next7Days: next7Days,
      );
    } catch (e) {
      throw DatabaseException('Failed to build reminder summary: $e');
    }
  }

  Future<int> recalculateAllStatuses() async {
    try {
      final rows = await (_db.select(_db.maintenanceReminders)
            ..where(
              (t) => t.status.isNotValue(ReminderStatus.completed.name),
            ))
          .get();

      int updated = 0;
      for (final row in rows) {
        final vehicle = await (_db.select(_db.vehicles)
              ..where((t) => t.id.equals(row.vehicleId)))
            .getSingleOrNull();
        final int currentOdo = vehicle?.currentOdo ?? row.currentOdometer;
        final ReminderStatus newStatus = _calculator.calculateStatus(
          type: ReminderType.fromStorage(row.reminderType),
          currentOdometer: currentOdo,
          nextServiceOdometer: row.nextServiceOdometer,
          nextServiceDate: row.nextServiceDate,
          existingStatus: ReminderStatus.fromStorage(row.status),
        );

        if (newStatus.name != row.status || currentOdo != row.currentOdometer) {
          await (_db.update(_db.maintenanceReminders)
                ..where((t) => t.id.equals(row.id)))
              .write(
            MaintenanceRemindersCompanion(
              currentOdometer: Value(currentOdo),
              status: Value(newStatus.name),
              updatedAt: Value(DateTime.now()),
            ),
          );
          updated++;
        }
      }
      return updated;
    } catch (e) {
      throw DatabaseException('Failed to recalculate reminders: $e');
    }
  }
}
