import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/providers/database_provider.dart';
import '../../../../core/sync/sync_collections.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../../../core/sync/sync_queue.dart';
import '../../../../core/sync/sync_serializers.dart';
import '../../data/datasources/maintenance_log_local_datasource.dart';
import '../../data/datasources/vehicle_local_datasource.dart';
import '../../data/repositories/vehicle_repository_impl.dart';
import '../../domain/entities/maintenance_log.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/entities/vehicle_enums.dart';
import '../../domain/repositories/vehicle_repository.dart';

const _uuid = Uuid();

final vehicleLocalDataSourceProvider = Provider<VehicleLocalDataSource>((ref) {
  return VehicleLocalDataSource(ref.watch(databaseProvider));
});

final vehicleRepositoryProvider = Provider<VehicleRepository>((ref) {
  return VehicleRepositoryImpl(
    ref.watch(vehicleLocalDataSourceProvider),
    ref.watch(syncQueueProvider),
  );
});

/// Search query for the vehicles list.
final vehicleSearchQueryProvider = StateProvider<String>((ref) => '');

/// Search query for archived vehicles.
final archivedVehicleSearchQueryProvider = StateProvider<String>((ref) => '');

/// Active filter chip selection.
enum VehicleListFilter {
  all,
  petrol,
  diesel,
  hybrid,
  electric,
  automatic,
  manual,
  archived,
}

final vehicleFilterProvider =
    StateProvider<VehicleListFilter>((ref) => VehicleListFilter.all);

final activeVehiclesStreamProvider = StreamProvider<List<Vehicle>>((ref) {
  return ref.watch(vehicleRepositoryProvider).watchActiveVehicles();
});

final archivedVehiclesStreamProvider = StreamProvider<List<Vehicle>>((ref) {
  return ref.watch(vehicleRepositoryProvider).watchArchivedVehicles();
});

final vehiclesByCustomerProvider =
    StreamProvider.family<List<Vehicle>, String>((ref, customerId) {
  return ref.watch(vehicleRepositoryProvider).watchVehiclesByCustomer(customerId);
});

final vehicleByIdProvider =
    FutureProvider.family<Vehicle?, String>((ref, id) async {
  return ref.watch(vehicleRepositoryProvider).getVehicleById(id);
});

final activeVehicleCountProvider = Provider<int>((ref) {
  return ref.watch(activeVehiclesStreamProvider).maybeWhen(
        data: (list) => list.length,
        orElse: () => 0,
      );
});

final customerVehicleCountProvider = Provider.family<int, String>((ref, customerId) {
  return ref.watch(vehiclesByCustomerProvider(customerId)).maybeWhen(
        data: (list) => list.length,
        orElse: () => 0,
      );
});

/// Filtered + searched active (or archived) vehicle list.
final filteredVehiclesProvider = Provider<AsyncValue<List<Vehicle>>>((ref) {
  final VehicleListFilter filter = ref.watch(vehicleFilterProvider);
  final String query = ref.watch(vehicleSearchQueryProvider).trim().toLowerCase();

  final AsyncValue<List<Vehicle>> source = filter == VehicleListFilter.archived
      ? ref.watch(archivedVehiclesStreamProvider)
      : ref.watch(activeVehiclesStreamProvider);

  return source.whenData((list) {
    Iterable<Vehicle> result = list;

    switch (filter) {
      case VehicleListFilter.all:
      case VehicleListFilter.archived:
        break;
      case VehicleListFilter.petrol:
        result = result.where((v) => v.fuelType == FuelType.petrol);
      case VehicleListFilter.diesel:
        result = result.where((v) => v.fuelType == FuelType.diesel);
      case VehicleListFilter.hybrid:
        result = result.where((v) => v.fuelType == FuelType.hybrid);
      case VehicleListFilter.electric:
        result = result.where((v) => v.fuelType == FuelType.electric);
      case VehicleListFilter.automatic:
        result = result.where((v) => v.transmission == TransmissionType.automatic);
      case VehicleListFilter.manual:
        result = result.where(
          (v) =>
              v.transmission == TransmissionType.manual ||
              v.transmission == TransmissionType.cvt,
        );
    }

    if (query.isNotEmpty) {
      result = result.where((v) {
        return v.registrationNumber.toLowerCase().contains(query) ||
            v.make.toLowerCase().contains(query) ||
            v.model.toLowerCase().contains(query) ||
            (v.engineNumber?.toLowerCase().contains(query) ?? false) ||
            (v.ownerName?.toLowerCase().contains(query) ?? false);
      });
    }

    return result.toList();
  });
});

final filteredArchivedVehiclesProvider =
    Provider<AsyncValue<List<Vehicle>>>((ref) {
  final AsyncValue<List<Vehicle>> vehicles =
      ref.watch(archivedVehiclesStreamProvider);
  final String query =
      ref.watch(archivedVehicleSearchQueryProvider).trim().toLowerCase();

  return vehicles.whenData((list) {
    if (query.isEmpty) return list;
    return list.where((v) {
      return v.registrationNumber.toLowerCase().contains(query) ||
          v.make.toLowerCase().contains(query) ||
          v.model.toLowerCase().contains(query) ||
          (v.engineNumber?.toLowerCase().contains(query) ?? false) ||
          (v.ownerName?.toLowerCase().contains(query) ?? false);
    }).toList();
  });
});

class VehicleFormData extends Equatable {
  const VehicleFormData({
    required this.customerId,
    required this.make,
    required this.model,
    this.variant,
    this.year,
    required this.registrationNumber,
    this.vinNumber,
    this.engineNumber,
    this.engineCapacity,
    required this.fuelType,
    required this.transmission,
    this.color,
    required this.currentOdo,
    this.purchaseDate,
    this.insuranceExpiry,
    this.registrationExpiry,
    this.notes,
  });

  final String customerId;
  final String make;
  final String model;
  final String? variant;
  final int? year;
  final String registrationNumber;
  final String? vinNumber;
  final String? engineNumber;
  final String? engineCapacity;
  final FuelType fuelType;
  final TransmissionType transmission;
  final String? color;
  final int currentOdo;
  final DateTime? purchaseDate;
  final DateTime? insuranceExpiry;
  final DateTime? registrationExpiry;
  final String? notes;

  @override
  List<Object?> get props => [
        customerId,
        make,
        model,
        variant,
        year,
        registrationNumber,
        vinNumber,
        engineNumber,
        engineCapacity,
        fuelType,
        transmission,
        color,
        currentOdo,
        purchaseDate,
        insuranceExpiry,
        registrationExpiry,
        notes,
      ];
}

class VehicleActionState extends Equatable {
  const VehicleActionState({
    this.isLoading = false,
    this.errorMessage,
    this.lastAction,
  });

  final bool isLoading;
  final String? errorMessage;
  final String? lastAction;

  VehicleActionState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? lastAction,
    bool clearError = false,
  }) {
    return VehicleActionState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      lastAction: lastAction ?? this.lastAction,
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage, lastAction];
}

class VehicleActionsNotifier extends StateNotifier<VehicleActionState> {
  VehicleActionsNotifier(this._repository)
      : super(const VehicleActionState());

  final VehicleRepository _repository;

  String? _nullableTrim(String? value) {
    if (value == null) return null;
    final String trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  Future<Vehicle?> create(VehicleFormData data) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final DateTime now = DateTime.now();
      final Vehicle vehicle = Vehicle(
        id: _uuid.v4(),
        customerId: data.customerId,
        make: data.make.trim(),
        model: data.model.trim(),
        variant: _nullableTrim(data.variant),
        year: data.year,
        registrationNumber: data.registrationNumber.trim().toUpperCase(),
        vinNumber: _nullableTrim(data.vinNumber),
        engineNumber: _nullableTrim(data.engineNumber),
        engineCapacity: _nullableTrim(data.engineCapacity),
        fuelType: data.fuelType,
        transmission: data.transmission,
        color: _nullableTrim(data.color),
        currentOdo: data.currentOdo,
        purchaseDate: data.purchaseDate,
        insuranceExpiry: data.insuranceExpiry,
        registrationExpiry: data.registrationExpiry,
        notes: _nullableTrim(data.notes),
        createdAt: now,
        updatedAt: now,
      );
      final Vehicle created = await _repository.createVehicle(vehicle);
      state = state.copyWith(isLoading: false, lastAction: 'created');
      return created;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: mapVehicleException(e).message,
      );
      return null;
    }
  }

  Future<Vehicle?> update(String id, VehicleFormData data) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final Vehicle? existing = await _repository.getVehicleById(id);
      if (existing == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Vehicle not found',
        );
        return null;
      }
      final Vehicle updated = await _repository.updateVehicle(
        Vehicle(
          id: existing.id,
          customerId: data.customerId,
          make: data.make.trim(),
          model: data.model.trim(),
          variant: _nullableTrim(data.variant),
          year: data.year,
          registrationNumber: data.registrationNumber.trim().toUpperCase(),
          vinNumber: _nullableTrim(data.vinNumber),
          engineNumber: _nullableTrim(data.engineNumber),
          engineCapacity: _nullableTrim(data.engineCapacity),
          fuelType: data.fuelType,
          transmission: data.transmission,
          color: _nullableTrim(data.color),
          currentOdo: data.currentOdo,
          purchaseDate: data.purchaseDate,
          insuranceExpiry: data.insuranceExpiry,
          registrationExpiry: data.registrationExpiry,
          imagePath: existing.imagePath,
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
        errorMessage: mapVehicleException(e).message,
      );
      return null;
    }
  }

  Future<bool> archive(String id) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.archiveVehicle(id);
      state = state.copyWith(isLoading: false, lastAction: 'archived');
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: mapVehicleException(e).message,
      );
      return false;
    }
  }

  Future<bool> restore(String id) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.restoreVehicle(id);
      state = state.copyWith(isLoading: false, lastAction: 'restored');
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: mapVehicleException(e).message,
      );
      return false;
    }
  }

  Future<Vehicle?> updateCurrentOdo(String id, int currentOdo) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final existing = await _repository.getVehicleById(id);
      if (existing == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Vehicle not found',
        );
        return null;
      }
      final updated = await _repository.updateVehicle(
        existing.copyWith(
          currentOdo: currentOdo,
          updatedAt: DateTime.now(),
        ),
      );
      state = state.copyWith(isLoading: false, lastAction: 'odo_updated');
      return updated;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: mapVehicleException(e).message,
      );
      return null;
    }
  }
}

final vehicleActionsProvider =
    StateNotifierProvider<VehicleActionsNotifier, VehicleActionState>((ref) {
  return VehicleActionsNotifier(ref.watch(vehicleRepositoryProvider));
});

final maintenanceLogDataSourceProvider =
    Provider<MaintenanceLogLocalDataSource>((ref) {
  return MaintenanceLogLocalDataSource(ref.watch(databaseProvider));
});

final maintenanceLogsByVehicleProvider =
    StreamProvider.family<List<MaintenanceLog>, String>((ref, vehicleId) {
  return ref
      .watch(maintenanceLogDataSourceProvider)
      .watchByVehicle(vehicleId);
});

class MaintenanceLogActionState extends Equatable {
  const MaintenanceLogActionState({
    this.isLoading = false,
    this.errorMessage,
  });

  final bool isLoading;
  final String? errorMessage;

  MaintenanceLogActionState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MaintenanceLogActionState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage];
}

class MaintenanceLogActionsNotifier
    extends StateNotifier<MaintenanceLogActionState> {
  MaintenanceLogActionsNotifier(this._dataSource, this._sync)
    : super(const MaintenanceLogActionState());

  final MaintenanceLogLocalDataSource _dataSource;
  final SyncQueue _sync;

  Future<MaintenanceLog?> add({
    required String vehicleId,
    required String note,
  }) async {
    final trimmed = note.trim();
    if (trimmed.isEmpty) {
      state = state.copyWith(errorMessage: 'Note cannot be empty');
      return null;
    }
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final log = await _dataSource.insert(
        MaintenanceLog(
          id: _uuid.v4(),
          vehicleId: vehicleId,
          note: trimmed,
          createdAt: DateTime.now(),
        ),
      );
      await _sync.enqueueUpsert(
        SyncCollections.maintenanceLogs,
        log.id,
        SyncSerializers.maintenanceLogToMap(log),
      );
      state = state.copyWith(isLoading: false);
      return log;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  Future<bool> delete(String id) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _dataSource.delete(id);
      await _sync.enqueueDelete(SyncCollections.maintenanceLogs, id);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }
}

final maintenanceLogActionsProvider = StateNotifierProvider<
  MaintenanceLogActionsNotifier,
  MaintenanceLogActionState
>((ref) {
  return MaintenanceLogActionsNotifier(
    ref.watch(maintenanceLogDataSourceProvider),
    ref.watch(syncQueueProvider),
  );
});
