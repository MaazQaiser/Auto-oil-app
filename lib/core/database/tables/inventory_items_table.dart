import 'package:drift/drift.dart';

/// Catalog of parts, oils, and services with stock and pricing.
@TableIndex(name: 'idx_inventory_type', columns: {#itemType})
@TableIndex(name: 'idx_inventory_name', columns: {#name})
@DataClassName('InventoryItemRow')
class InventoryItems extends Table {
  TextColumn get id => text()();

  /// One of: part, oil, service
  TextColumn get itemType => text()();

  TextColumn get name => text().withLength(min: 1, max: 200)();

  TextColumn get description => text().nullable()();

  RealColumn get price => real().withDefault(const Constant(0.0))();

  IntColumn get quantityAvailable => integer().withDefault(const Constant(0))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
