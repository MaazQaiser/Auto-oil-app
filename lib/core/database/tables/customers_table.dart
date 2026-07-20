import 'package:drift/drift.dart';

/// Customers table — each customer may own multiple vehicles in later phases.
@TableIndex(name: 'idx_customers_phone', columns: {#phoneNumber})
@TableIndex(name: 'idx_customers_full_name', columns: {#fullName})
@DataClassName('CustomerRow')
class Customers extends Table {
  TextColumn get id => text()();

  TextColumn get fullName => text().withLength(min: 1, max: 200)();

  TextColumn get phoneNumber => text()();

  TextColumn get whatsappNumber => text().nullable()();

  TextColumn get email => text().nullable()();

  TextColumn get address => text().nullable()();

  TextColumn get city => text().nullable()();

  TextColumn get notes => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  BoolColumn get isArchived =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
