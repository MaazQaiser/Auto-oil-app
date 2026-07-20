import '../entities/customer.dart';

/// Contract for customer persistence operations.
abstract class CustomerRepository {
  Future<Customer> createCustomer(Customer customer);

  Future<Customer> updateCustomer(Customer customer);

  /// Soft-deletes a customer (sets [Customer.isArchived] to true).
  Future<void> deleteCustomer(String id);

  Future<void> archiveCustomer(String id);

  Future<void> restoreCustomer(String id);

  Future<Customer?> getCustomerById(String id);

  Future<List<Customer>> getAllCustomers({bool archived = false});

  Future<List<Customer>> searchCustomers(
    String query, {
    bool archived = false,
  });

  /// Reactive stream of active (non-archived) customers.
  Stream<List<Customer>> watchActiveCustomers();

  /// Reactive stream of archived customers.
  Stream<List<Customer>> watchArchivedCustomers();

  /// Returns true if [phoneNumber] is already used by another customer.
  Future<bool> isPhoneTaken(String phoneNumber, {String? excludeId});
}
