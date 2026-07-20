import 'package:drift/drift.dart';

/// Workshop invoices linked to service records / customers / vehicles.
@TableIndex(name: 'idx_invoices_number', columns: {#invoiceNumber})
@TableIndex(name: 'idx_invoices_date', columns: {#invoiceDate})
@TableIndex(name: 'idx_invoices_customer', columns: {#customerId})
@DataClassName('InvoiceRow')
class Invoices extends Table {
  TextColumn get id => text()();

  TextColumn get serviceRecordId => text().nullable()();

  TextColumn get customerId => text()();

  TextColumn get vehicleId => text()();

  TextColumn get invoiceNumber => text()();

  DateTimeColumn get invoiceDate => dateTime()();

  RealColumn get subtotal => real().withDefault(const Constant(0))();

  RealColumn get discount => real().withDefault(const Constant(0))();

  RealColumn get tax => real().withDefault(const Constant(0))();

  RealColumn get grandTotal => real().withDefault(const Constant(0))();

  /// cash | card | bank_transfer | online | other
  TextColumn get paymentMethod =>
      text().withDefault(const Constant('cash'))();

  /// paid | pending | partially_paid | cancelled
  TextColumn get paymentStatus =>
      text().withDefault(const Constant('pending'))();

  DateTimeColumn get paidDate => dateTime().nullable()();

  TextColumn get currency => text().withDefault(const Constant('USD'))();

  TextColumn get notes => text().nullable()();

  /// Snapshot fields for offline invoice rendering.
  TextColumn get labourDescription => text().nullable()();

  RealColumn get labourAmount => real().withDefault(const Constant(0))();

  TextColumn get partsDescription => text().nullable()();

  RealColumn get partsAmount => real().withDefault(const Constant(0))();

  TextColumn get serviceDescription => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
