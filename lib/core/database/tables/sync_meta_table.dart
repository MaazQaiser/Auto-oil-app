import 'package:drift/drift.dart';

/// Key/value sync metadata (last pull time, seed flags, etc.).
@DataClassName('SyncMetaRow')
class SyncMeta extends Table {
  TextColumn get key => text()();

  TextColumn get value => text()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}
