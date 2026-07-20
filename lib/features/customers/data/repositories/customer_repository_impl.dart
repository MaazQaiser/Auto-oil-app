import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/sync/sync_collections.dart';
import '../../../../core/sync/sync_queue.dart';
import '../../../../core/sync/sync_serializers.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/customer_local_datasource.dart';

/// Drift-backed implementation of [CustomerRepository] with Firebase sync.
class CustomerRepositoryImpl implements CustomerRepository {
  CustomerRepositoryImpl(this._dataSource, [this._sync = const NoopSyncQueue()]);

  final CustomerLocalDataSource _dataSource;
  final SyncQueue _sync;

  Future<void> _enqueue(Customer customer) {
    return _sync.enqueueUpsert(
      SyncCollections.customers,
      customer.id,
      SyncSerializers.customerToMap(customer),
    );
  }

  @override
  Future<Customer> createCustomer(Customer customer) async {
    try {
      final bool taken = await _dataSource.isPhoneTaken(customer.phoneNumber);
      if (taken) {
        throw const ValidationException(
          'A customer with this phone number already exists',
          code: 'duplicate_phone',
        );
      }
      final Customer created = await _dataSource.insert(customer);
      await _enqueue(created);
      AppLogger.info('Customer created: ${created.id}');
      return created;
    } on AppException {
      rethrow;
    } catch (e, st) {
      AppLogger.error('createCustomer failed', error: e, stackTrace: st);
      throw const DatabaseException('Failed to create customer');
    }
  }

  @override
  Future<Customer> updateCustomer(Customer customer) async {
    try {
      final bool taken = await _dataSource.isPhoneTaken(
        customer.phoneNumber,
        excludeId: customer.id,
      );
      if (taken) {
        throw const ValidationException(
          'A customer with this phone number already exists',
          code: 'duplicate_phone',
        );
      }
      final Customer updated = await _dataSource.update(
        customer.copyWith(updatedAt: DateTime.now()),
      );
      await _enqueue(updated);
      AppLogger.info('Customer updated: ${updated.id}');
      return updated;
    } on AppException {
      rethrow;
    } catch (e, st) {
      AppLogger.error('updateCustomer failed', error: e, stackTrace: st);
      throw const DatabaseException('Failed to update customer');
    }
  }

  @override
  Future<void> deleteCustomer(String id) => archiveCustomer(id);

  @override
  Future<void> archiveCustomer(String id) async {
    try {
      await _dataSource.setArchived(id, archived: true);
      final Customer? customer = await _dataSource.getById(id);
      if (customer != null) await _enqueue(customer);
      AppLogger.info('Customer archived: $id');
    } on AppException {
      rethrow;
    } catch (e, st) {
      AppLogger.error('archiveCustomer failed', error: e, stackTrace: st);
      throw const DatabaseException('Failed to archive customer');
    }
  }

  @override
  Future<void> restoreCustomer(String id) async {
    try {
      await _dataSource.setArchived(id, archived: false);
      final Customer? customer = await _dataSource.getById(id);
      if (customer != null) await _enqueue(customer);
      AppLogger.info('Customer restored: $id');
    } on AppException {
      rethrow;
    } catch (e, st) {
      AppLogger.error('restoreCustomer failed', error: e, stackTrace: st);
      throw const DatabaseException('Failed to restore customer');
    }
  }

  @override
  Future<Customer?> getCustomerById(String id) async {
    try {
      return await _dataSource.getById(id);
    } on AppException {
      rethrow;
    } catch (e, st) {
      AppLogger.error('getCustomerById failed', error: e, stackTrace: st);
      throw const DatabaseException('Failed to get customer');
    }
  }

  @override
  Future<List<Customer>> getAllCustomers({bool archived = false}) async {
    try {
      return await _dataSource.getAll(archived: archived);
    } on AppException {
      rethrow;
    } catch (e, st) {
      AppLogger.error('getAllCustomers failed', error: e, stackTrace: st);
      throw const DatabaseException('Failed to load customers');
    }
  }

  @override
  Future<List<Customer>> searchCustomers(
    String query, {
    bool archived = false,
  }) async {
    try {
      if (query.trim().isEmpty) {
        return getAllCustomers(archived: archived);
      }
      return await _dataSource.search(query, archived: archived);
    } on AppException {
      rethrow;
    } catch (e, st) {
      AppLogger.error('searchCustomers failed', error: e, stackTrace: st);
      throw const DatabaseException('Failed to search customers');
    }
  }

  @override
  Stream<List<Customer>> watchActiveCustomers() {
    return _dataSource.watchAll(archived: false);
  }

  @override
  Stream<List<Customer>> watchArchivedCustomers() {
    return _dataSource.watchAll(archived: true);
  }

  @override
  Future<bool> isPhoneTaken(String phoneNumber, {String? excludeId}) {
    return _dataSource.isPhoneTaken(phoneNumber, excludeId: excludeId);
  }
}

/// Maps [AppException] to a [Failure] for presentation layers.
Failure mapCustomerException(Object error) {
  if (error is ValidationException) {
    return ValidationFailure(message: error.message, code: error.code);
  }
  if (error is NotFoundException) {
    return UnexpectedFailure(message: error.message, code: error.code);
  }
  if (error is DatabaseException) {
    return DatabaseFailure(message: error.message, code: error.code);
  }
  return const UnexpectedFailure();
}
