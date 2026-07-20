import 'package:drift/drift.dart';

import 'customers_table.dart';

/// Vehicles table — each vehicle belongs to one customer.
@TableIndex(name: 'idx_vehicles_customer_id', columns: {#customerId})
@TableIndex(name: 'idx_vehicles_registration', columns: {#registrationNumber})
@TableIndex(name: 'idx_vehicles_make', columns: {#make})
@DataClassName('VehicleRow')
class Vehicles extends Table {
  TextColumn get id => text()();

  TextColumn get customerId => text().references(Customers, #id)();

  TextColumn get make => text()();

  TextColumn get model => text()();

  TextColumn get variant => text().nullable()();

  IntColumn get year => integer().nullable()();

  TextColumn get registrationNumber => text()();

  TextColumn get vinNumber => text().nullable()();

  TextColumn get engineNumber => text().nullable()();

  TextColumn get engineCapacity => text().nullable()();

  /// petrol | diesel | hybrid | electric
  TextColumn get fuelType => text()();

  /// automatic | manual | cvt
  TextColumn get transmission => text()();

  TextColumn get color => text().nullable()();

  IntColumn get currentOdo => integer()();

  DateTimeColumn get purchaseDate => dateTime().nullable()();

  DateTimeColumn get insuranceExpiry => dateTime().nullable()();

  DateTimeColumn get registrationExpiry => dateTime().nullable()();

  TextColumn get imagePath => text().nullable()();

  TextColumn get notes => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  BoolColumn get isArchived =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
