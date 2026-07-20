import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/maintenance_log.dart';

class MaintenanceLogLocalDataSource {
  MaintenanceLogLocalDataSource(this._db);

  final AppDatabase _db;

  MaintenanceLog _toEntity(MaintenanceLogRow row) {
    return MaintenanceLog(
      id: row.id,
      vehicleId: row.vehicleId,
      note: row.note,
      createdAt: row.createdAt,
    );
  }

  Future<MaintenanceLog> insert(MaintenanceLog log) async {
    try {
      await _db.into(_db.maintenanceLogs).insert(
        MaintenanceLogsCompanion(
          id: Value(log.id),
          vehicleId: Value(log.vehicleId),
          note: Value(log.note),
          createdAt: Value(log.createdAt),
        ),
      );
      return log;
    } catch (e) {
      throw DatabaseException('Failed to add maintenance note: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      final deleted = await (_db.delete(_db.maintenanceLogs)
            ..where((t) => t.id.equals(id)))
          .go();
      if (deleted == 0) {
        throw const NotFoundException('Maintenance note not found');
      }
    } on NotFoundException {
      rethrow;
    } catch (e) {
      throw DatabaseException('Failed to delete maintenance note: $e');
    }
  }

  Stream<List<MaintenanceLog>> watchByVehicle(String vehicleId) {
    final query = _db.select(_db.maintenanceLogs)
      ..where((t) => t.vehicleId.equals(vehicleId))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    return query.watch().map((rows) => rows.map(_toEntity).toList());
  }
}
