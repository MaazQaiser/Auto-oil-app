import 'package:drift/drift.dart';

/// Pending mutations to push to Firestore when online.
@DataClassName('SyncOutboxRow')
@TableIndex(name: 'idx_sync_outbox_created', columns: {#createdAt})
class SyncOutbox extends Table {
  TextColumn get id => text()();

  /// Collection name, e.g. customers, vehicles.
  TextColumn get collection => text()();

  /// Document id within the collection.
  TextColumn get documentId => text()();

  /// upsert | delete
  TextColumn get operation => text()();

  /// JSON payload for upsert (null for delete).
  TextColumn get payloadJson => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  IntColumn get attempts => integer().withDefault(const Constant(0))();

  TextColumn get lastError => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
