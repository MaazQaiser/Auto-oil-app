import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/providers/database_provider.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../data/datasources/customer_local_datasource.dart';
import '../../data/repositories/customer_repository_impl.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';

const _uuid = Uuid();

/// Provides the local customer data source.
final customerLocalDataSourceProvider = Provider<CustomerLocalDataSource>((
  ref,
) {
  return CustomerLocalDataSource(ref.watch(databaseProvider));
});

/// Provides the customer repository.
final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  return CustomerRepositoryImpl(
    ref.watch(customerLocalDataSourceProvider),
    ref.watch(syncQueueProvider),
  );
});

/// Search query for the active customers list.
final customerSearchQueryProvider = StateProvider<String>((ref) => '');

/// Search query for the archived customers list.
final archivedCustomerSearchQueryProvider = StateProvider<String>((ref) => '');

/// Selection mode flag (placeholder for future multi-select).
final customerSelectionModeProvider = StateProvider<bool>((ref) => false);

/// Watches active customers from Drift.
final activeCustomersStreamProvider = StreamProvider<List<Customer>>((ref) {
  return ref.watch(customerRepositoryProvider).watchActiveCustomers();
});

/// Watches archived customers from Drift.
final archivedCustomersStreamProvider = StreamProvider<List<Customer>>((ref) {
  return ref.watch(customerRepositoryProvider).watchArchivedCustomers();
});

/// Filtered active customers based on [customerSearchQueryProvider].
final filteredCustomersProvider = Provider<AsyncValue<List<Customer>>>((ref) {
  final AsyncValue<List<Customer>> customers = ref.watch(
    activeCustomersStreamProvider,
  );
  final String query = ref
      .watch(customerSearchQueryProvider)
      .trim()
      .toLowerCase();

  return customers.whenData((list) {
    if (query.isEmpty) return list;
    return list.where((c) {
      return c.fullName.toLowerCase().contains(query) ||
          c.phoneNumber.toLowerCase().contains(query) ||
          (c.city?.toLowerCase().contains(query) ?? false);
    }).toList();
  });
});

/// Filtered archived customers.
final filteredArchivedCustomersProvider = Provider<AsyncValue<List<Customer>>>((
  ref,
) {
  final AsyncValue<List<Customer>> customers = ref.watch(
    archivedCustomersStreamProvider,
  );
  final String query = ref
      .watch(archivedCustomerSearchQueryProvider)
      .trim()
      .toLowerCase();

  return customers.whenData((list) {
    if (query.isEmpty) return list;
    return list.where((c) {
      return c.fullName.toLowerCase().contains(query) ||
          c.phoneNumber.toLowerCase().contains(query) ||
          (c.city?.toLowerCase().contains(query) ?? false);
    }).toList();
  });
});

/// Loads a single customer by id.
final customerByIdProvider = FutureProvider.family<Customer?, String>((
  ref,
  id,
) async {
  return ref.watch(customerRepositoryProvider).getCustomerById(id);
});

/// Active customer count for dashboard placeholder cards.
final activeCustomerCountProvider = Provider<int>((ref) {
  return ref
      .watch(activeCustomersStreamProvider)
      .maybeWhen(data: (list) => list.length, orElse: () => 0);
});

/// Form input snapshot used when creating / updating a customer.
class CustomerFormData extends Equatable {
  const CustomerFormData({
    required this.fullName,
    required this.phoneNumber,
    this.whatsappNumber,
    this.email,
    this.address,
    this.city,
    this.notes,
    this.vehicleName,
    this.registrationNumber,
    this.vehicleMake,
    this.vehicleModel,
    this.vehicleVariant,
    this.recommendedOil,
    this.odometerReading,
    this.nextServiceOdometer,
    this.nextServiceDate,
  });

  final String fullName;
  final String phoneNumber;
  final String? whatsappNumber;
  final String? email;
  final String? address;
  final String? city;
  final String? notes;
  final String? vehicleName;
  final String? registrationNumber;
  final String? vehicleMake;
  final String? vehicleModel;
  final String? vehicleVariant;
  final String? recommendedOil;
  final int? odometerReading;
  final int? nextServiceOdometer;
  final DateTime? nextServiceDate;

  bool get hasVehicleDetails {
    final make = vehicleMake?.trim() ?? '';
    final model = vehicleModel?.trim() ?? '';
    final name = vehicleName?.trim() ?? '';
    final reg = registrationNumber?.trim() ?? '';
    final oil = recommendedOil?.trim() ?? '';
    return make.isNotEmpty ||
        model.isNotEmpty ||
        name.isNotEmpty ||
        reg.isNotEmpty ||
        oil.isNotEmpty ||
        odometerReading != null;
  }

  @override
  List<Object?> get props => [
    fullName,
    phoneNumber,
    whatsappNumber,
    email,
    address,
    city,
    notes,
    vehicleName,
    registrationNumber,
    vehicleMake,
    vehicleModel,
    vehicleVariant,
    recommendedOil,
    odometerReading,
    nextServiceOdometer,
    nextServiceDate,
  ];
}

/// Mutation results / loading state for create, update, archive, restore.
class CustomerActionState extends Equatable {
  const CustomerActionState({
    this.isLoading = false,
    this.errorMessage,
    this.lastAction,
  });

  final bool isLoading;
  final String? errorMessage;
  final String? lastAction;

  CustomerActionState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? lastAction,
    bool clearError = false,
  }) {
    return CustomerActionState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastAction: lastAction ?? this.lastAction,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, lastAction];
}

/// Handles create / update / archive / restore mutations.
class CustomerActionsNotifier extends StateNotifier<CustomerActionState> {
  CustomerActionsNotifier(this._repository)
    : super(const CustomerActionState());

  final CustomerRepository _repository;

  Future<Customer?> create(CustomerFormData data) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final DateTime now = DateTime.now();
      final Customer customer = Customer(
        id: _uuid.v4(),
        fullName: data.fullName.trim(),
        phoneNumber: data.phoneNumber.trim(),
        whatsappNumber: _nullableTrim(data.whatsappNumber),
        email: _nullableTrim(data.email),
        address: _nullableTrim(data.address),
        city: _nullableTrim(data.city),
        notes: _nullableTrim(data.notes),
        createdAt: now,
        updatedAt: now,
      );
      final Customer created = await _repository.createCustomer(customer);
      state = state.copyWith(isLoading: false, lastAction: 'created');
      return created;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: mapCustomerException(e).message,
      );
      return null;
    }
  }

  Future<Customer?> update(String id, CustomerFormData data) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final Customer? existing = await _repository.getCustomerById(id);
      if (existing == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Customer not found',
        );
        return null;
      }
      final Customer updated = await _repository.updateCustomer(
        Customer(
          id: existing.id,
          fullName: data.fullName.trim(),
          phoneNumber: data.phoneNumber.trim(),
          whatsappNumber: _nullableTrim(data.whatsappNumber),
          email: _nullableTrim(data.email),
          address: _nullableTrim(data.address),
          city: _nullableTrim(data.city),
          notes: _nullableTrim(data.notes),
          createdAt: existing.createdAt,
          updatedAt: DateTime.now(),
          isArchived: existing.isArchived,
        ),
      );
      state = state.copyWith(isLoading: false, lastAction: 'updated');
      return updated;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: mapCustomerException(e).message,
      );
      return null;
    }
  }

  Future<bool> archive(String id) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.archiveCustomer(id);
      state = state.copyWith(isLoading: false, lastAction: 'archived');
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: mapCustomerException(e).message,
      );
      return false;
    }
  }

  Future<bool> restore(String id) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.restoreCustomer(id);
      state = state.copyWith(isLoading: false, lastAction: 'restored');
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: mapCustomerException(e).message,
      );
      return false;
    }
  }

  String? _nullableTrim(String? value) {
    if (value == null) return null;
    final String trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}

final customerActionsProvider =
    StateNotifierProvider<CustomerActionsNotifier, CustomerActionState>((ref) {
      return CustomerActionsNotifier(ref.watch(customerRepositoryProvider));
    });
