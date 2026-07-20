import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/customer.dart';

/// Local Drift data source for customers.
class CustomerLocalDataSource {
  CustomerLocalDataSource(this._db);

  final AppDatabase _db;

  Customer _toEntity(CustomerRow row) {
    return Customer(
      id: row.id,
      fullName: row.fullName,
      phoneNumber: row.phoneNumber,
      whatsappNumber: row.whatsappNumber,
      email: row.email,
      address: row.address,
      city: row.city,
      notes: row.notes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      isArchived: row.isArchived,
    );
  }

  CustomersCompanion _toCompanion(Customer customer) {
    return CustomersCompanion(
      id: Value(customer.id),
      fullName: Value(customer.fullName),
      phoneNumber: Value(customer.phoneNumber),
      whatsappNumber: Value(customer.whatsappNumber),
      email: Value(customer.email),
      address: Value(customer.address),
      city: Value(customer.city),
      notes: Value(customer.notes),
      createdAt: Value(customer.createdAt),
      updatedAt: Value(customer.updatedAt),
      isArchived: Value(customer.isArchived),
    );
  }

  Future<Customer> insert(Customer customer) async {
    try {
      await _db.into(_db.customers).insert(_toCompanion(customer));
      return customer;
    } catch (e) {
      throw DatabaseException('Failed to create customer: $e');
    }
  }

  Future<Customer> update(Customer customer) async {
    try {
      final int updated = await (_db.update(_db.customers)
            ..where((t) => t.id.equals(customer.id)))
          .write(_toCompanion(customer));
      if (updated == 0) {
        throw const NotFoundException('Customer not found');
      }
      return customer;
    } on NotFoundException {
      rethrow;
    } catch (e) {
      throw DatabaseException('Failed to update customer: $e');
    }
  }

  Future<void> setArchived(String id, {required bool archived}) async {
    try {
      final int updated = await (_db.update(_db.customers)
            ..where((t) => t.id.equals(id)))
          .write(
        CustomersCompanion(
          isArchived: Value(archived),
          updatedAt: Value(DateTime.now()),
        ),
      );
      if (updated == 0) {
        throw const NotFoundException('Customer not found');
      }
    } on NotFoundException {
      rethrow;
    } catch (e) {
      throw DatabaseException('Failed to update customer archive state: $e');
    }
  }

  Future<Customer?> getById(String id) async {
    try {
      final query = _db.select(_db.customers)..where((t) => t.id.equals(id));
      final CustomerRow? row = await query.getSingleOrNull();
      return row == null ? null : _toEntity(row);
    } catch (e) {
      throw DatabaseException('Failed to get customer: $e');
    }
  }

  Future<List<Customer>> getAll({required bool archived}) async {
    try {
      final query = _db.select(_db.customers)
        ..where((t) => t.isArchived.equals(archived))
        ..orderBy([
          (t) => OrderingTerm(
                expression: t.updatedAt,
                mode: OrderingMode.desc,
              ),
        ]);
      final rows = await query.get();
      return rows.map(_toEntity).toList();
    } catch (e) {
      throw DatabaseException('Failed to load customers: $e');
    }
  }

  Future<List<Customer>> search(String query, {required bool archived}) async {
    try {
      final String pattern = '%${query.trim().toLowerCase()}%';
      final results = await (_db.select(_db.customers)
            ..where(
              (t) =>
                  t.isArchived.equals(archived) &
                  (t.fullName.lower().like(pattern) |
                      t.phoneNumber.lower().like(pattern) |
                      (t.city.isNotNull() & t.city.lower().like(pattern))),
            )
            ..orderBy([
              (t) => OrderingTerm(
                    expression: t.fullName,
                    mode: OrderingMode.asc,
                  ),
            ]))
          .get();
      return results.map(_toEntity).toList();
    } catch (e) {
      throw DatabaseException('Failed to search customers: $e');
    }
  }

  Stream<List<Customer>> watchAll({required bool archived}) {
    final query = _db.select(_db.customers)
      ..where((t) => t.isArchived.equals(archived))
      ..orderBy([
        (t) => OrderingTerm(
              expression: t.updatedAt,
              mode: OrderingMode.desc,
            ),
      ]);
    return query.watch().map((rows) => rows.map(_toEntity).toList());
  }

  Future<bool> isPhoneTaken(String phoneNumber, {String? excludeId}) async {
    try {
      final String normalized = phoneNumber.trim();
      final query = _db.select(_db.customers)
        ..where((t) => t.phoneNumber.equals(normalized));
      if (excludeId != null) {
        query.where((t) => t.id.equals(excludeId).not());
      }
      final CustomerRow? existing = await query.getSingleOrNull();
      return existing != null;
    } catch (e) {
      throw DatabaseException('Failed to check phone number: $e');
    }
  }
}
