import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_enums.dart';

class InvoiceLocalDataSource {
  InvoiceLocalDataSource(this._db);

  final AppDatabase _db;

  Invoice _map(
    InvoiceRow row, {
    String? customerName,
    String? customerPhone,
    String? customerAddress,
    String? vehicleName,
    String? registration,
  }) {
    return Invoice(
      id: row.id,
      serviceRecordId: row.serviceRecordId,
      customerId: row.customerId,
      vehicleId: row.vehicleId,
      invoiceNumber: row.invoiceNumber,
      invoiceDate: row.invoiceDate,
      subtotal: row.subtotal,
      discount: row.discount,
      tax: row.tax,
      grandTotal: row.grandTotal,
      paymentMethod: PaymentMethod.fromStorage(row.paymentMethod),
      paymentStatus: PaymentStatus.fromStorage(row.paymentStatus),
      paidDate: row.paidDate,
      currency: row.currency,
      notes: row.notes,
      labourDescription: row.labourDescription,
      labourAmount: row.labourAmount,
      partsDescription: row.partsDescription,
      partsAmount: row.partsAmount,
      serviceDescription: row.serviceDescription,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      customerName: customerName,
      customerPhone: customerPhone,
      customerAddress: customerAddress,
      vehicleDisplayName: vehicleName,
      registrationNumber: registration,
    );
  }

  InvoicesCompanion _toCompanion(Invoice invoice) {
    return InvoicesCompanion(
      id: Value(invoice.id),
      serviceRecordId: Value(invoice.serviceRecordId),
      customerId: Value(invoice.customerId),
      vehicleId: Value(invoice.vehicleId),
      invoiceNumber: Value(invoice.invoiceNumber),
      invoiceDate: Value(invoice.invoiceDate),
      subtotal: Value(invoice.subtotal),
      discount: Value(invoice.discount),
      tax: Value(invoice.tax),
      grandTotal: Value(invoice.grandTotal),
      paymentMethod: Value(invoice.paymentMethod.storageValue),
      paymentStatus: Value(invoice.paymentStatus.storageValue),
      paidDate: Value(invoice.paidDate),
      currency: Value(invoice.currency),
      notes: Value(invoice.notes),
      labourDescription: Value(invoice.labourDescription),
      labourAmount: Value(invoice.labourAmount),
      partsDescription: Value(invoice.partsDescription),
      partsAmount: Value(invoice.partsAmount),
      serviceDescription: Value(invoice.serviceDescription),
      createdAt: Value(invoice.createdAt),
      updatedAt: Value(invoice.updatedAt),
    );
  }

  Future<List<Invoice>> _mapJoined(List<TypedResult> rows) async {
    return rows.map((row) {
      final inv = row.readTable(_db.invoices);
      final c = row.readTableOrNull(_db.customers);
      final v = row.readTableOrNull(_db.vehicles);
      return _map(
        inv,
        customerName: c?.fullName,
        customerPhone: c?.phoneNumber,
        customerAddress: [
          if (c?.address != null && c!.address!.isNotEmpty) c.address!,
          if (c?.city != null && c!.city!.isNotEmpty) c.city!,
        ].join(', '),
        vehicleName: v == null ? null : '${v.make} ${v.model}',
        registration: v?.registrationNumber,
      );
    }).toList();
  }

  Future<Invoice> insert(Invoice invoice) async {
    try {
      await _db.into(_db.invoices).insert(_toCompanion(invoice));
      return (await getById(invoice.id))!;
    } catch (e) {
      throw DatabaseException('Failed to create invoice: $e');
    }
  }

  Future<Invoice> update(Invoice invoice) async {
    try {
      await (_db.update(_db.invoices)..where((t) => t.id.equals(invoice.id)))
          .write(_toCompanion(invoice.copyWith(updatedAt: DateTime.now())));
      return (await getById(invoice.id))!;
    } catch (e) {
      throw DatabaseException('Failed to update invoice: $e');
    }
  }

  Future<void> delete(String id) async {
    await (_db.delete(_db.invoices)..where((t) => t.id.equals(id))).go();
  }

  Future<Invoice?> getById(String id) async {
    final query = _db.select(_db.invoices).join([
      leftOuterJoin(
        _db.customers,
        _db.customers.id.equalsExp(_db.invoices.customerId),
      ),
      leftOuterJoin(
        _db.vehicles,
        _db.vehicles.id.equalsExp(_db.invoices.vehicleId),
      ),
    ])
      ..where(_db.invoices.id.equals(id));
    final rows = await query.get();
    if (rows.isEmpty) return null;
    return (await _mapJoined(rows)).first;
  }

  Stream<List<Invoice>> watchAll() {
    final query = _db.select(_db.invoices).join([
      leftOuterJoin(
        _db.customers,
        _db.customers.id.equalsExp(_db.invoices.customerId),
      ),
      leftOuterJoin(
        _db.vehicles,
        _db.vehicles.id.equalsExp(_db.invoices.vehicleId),
      ),
    ])
      ..orderBy([OrderingTerm.desc(_db.invoices.invoiceDate)]);
    return query.watch().asyncMap(_mapJoined);
  }

  Future<List<Invoice>> getRecent({int limit = 10}) async {
    final query = _db.select(_db.invoices).join([
      leftOuterJoin(
        _db.customers,
        _db.customers.id.equalsExp(_db.invoices.customerId),
      ),
      leftOuterJoin(
        _db.vehicles,
        _db.vehicles.id.equalsExp(_db.invoices.vehicleId),
      ),
    ])
      ..orderBy([OrderingTerm.desc(_db.invoices.invoiceDate)])
      ..limit(limit);
    return _mapJoined(await query.get());
  }

  Future<List<Invoice>> search(String query) async {
    final String q = '%${query.trim().toLowerCase()}%';
    if (query.trim().isEmpty) return [];
    final rows = await (_db.select(_db.invoices).join([
          leftOuterJoin(
            _db.customers,
            _db.customers.id.equalsExp(_db.invoices.customerId),
          ),
          leftOuterJoin(
            _db.vehicles,
            _db.vehicles.id.equalsExp(_db.invoices.vehicleId),
          ),
        ])
          ..where(
            _db.invoices.invoiceNumber.lower().like(q) |
                _db.customers.fullName.lower().like(q) |
                _db.vehicles.make.lower().like(q) |
                _db.vehicles.model.lower().like(q) |
                _db.vehicles.registrationNumber.lower().like(q),
          )
          ..orderBy([OrderingTerm.desc(_db.invoices.invoiceDate)])
          ..limit(100))
        .get();
    return _mapJoined(rows);
  }

  Future<List<Invoice>> filter({
    DateTime? start,
    DateTime? end,
    PaymentStatus? status,
    String? customerId,
    String? vehicleId,
  }) async {
    final query = _db.select(_db.invoices).join([
      leftOuterJoin(
        _db.customers,
        _db.customers.id.equalsExp(_db.invoices.customerId),
      ),
      leftOuterJoin(
        _db.vehicles,
        _db.vehicles.id.equalsExp(_db.invoices.vehicleId),
      ),
    ]);

    Expression<bool>? where;
    void and(Expression<bool> expr) {
      where = where == null ? expr : where! & expr;
    }

    if (start != null) {
      and(_db.invoices.invoiceDate.isBiggerOrEqualValue(start));
    }
    if (end != null) {
      and(_db.invoices.invoiceDate.isSmallerThanValue(end));
    }
    if (status != null) {
      and(_db.invoices.paymentStatus.equals(status.storageValue));
    }
    if (customerId != null) {
      and(_db.invoices.customerId.equals(customerId));
    }
    if (vehicleId != null) {
      and(_db.invoices.vehicleId.equals(vehicleId));
    }
    if (where != null) query.where(where!);
    query.orderBy([OrderingTerm.desc(_db.invoices.invoiceDate)]);
    return _mapJoined(await query.get());
  }

  Future<int> countAll() async {
    final countExp = _db.invoices.id.count();
    final row = await (_db.selectOnly(_db.invoices)..addColumns([countExp]))
        .getSingle();
    return row.read(countExp) ?? 0;
  }

  Future<double> sumByStatus(PaymentStatus status) async {
    final sumExp = _db.invoices.grandTotal.sum();
    final row = await (_db.selectOnly(_db.invoices)
          ..addColumns([sumExp])
          ..where(_db.invoices.paymentStatus.equals(status.storageValue)))
        .getSingle();
    return row.read(sumExp) ?? 0;
  }

  Future<double> sumPaidInRange(DateTime start, DateTime end) async {
    final sumExp = _db.invoices.grandTotal.sum();
    final row = await (_db.selectOnly(_db.invoices)
          ..addColumns([sumExp])
          ..where(
            _db.invoices.paymentStatus.equals(PaymentStatus.paid.storageValue) &
                _db.invoices.invoiceDate.isBiggerOrEqualValue(start) &
                _db.invoices.invoiceDate.isSmallerThanValue(end),
          ))
        .getSingle();
    return row.read(sumExp) ?? 0;
  }

  Future<String> peekNextInvoiceNumber({
    required String prefix,
    required int nextNumber,
  }) async {
    return '$prefix-${nextNumber.toString().padLeft(5, '0')}';
  }
}
