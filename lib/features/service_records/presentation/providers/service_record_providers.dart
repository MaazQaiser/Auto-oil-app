import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../shared/providers/database_provider.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../../reminders/presentation/providers/reminder_providers.dart';
import '../../data/datasources/service_record_local_datasource.dart';
import '../../data/repositories/service_record_repository_impl.dart';
import '../../domain/entities/service_record.dart';
import '../../domain/repositories/service_record_repository.dart';
import '../../../reminders/domain/entities/reminder_enums.dart';

const _uuid = Uuid();

final serviceRecordLocalDataSourceProvider =
    Provider<ServiceRecordLocalDataSource>((ref) {
  return ServiceRecordLocalDataSource(ref.watch(databaseProvider));
});

final serviceRecordRepositoryProvider =
    Provider<ServiceRecordRepository>((ref) {
  return ServiceRecordRepositoryImpl(
    ref.watch(serviceRecordLocalDataSourceProvider),
    ref.watch(reminderServiceProvider),
    ref.watch(syncQueueProvider),
  );
});

final serviceRecordsByVehicleProvider =
    StreamProvider.family<List<ServiceRecord>, String>((ref, vehicleId) {
  return ref.watch(serviceRecordRepositoryProvider).watchByVehicle(vehicleId);
});

final totalRevenueProvider = FutureProvider<double>((ref) async {
  ref.watch(allRemindersStreamProvider); // soft refresh hook
  return ref.watch(serviceRecordRepositoryProvider).totalRevenue();
});

class ServiceRecordFormData {
  const ServiceRecordFormData({
    required this.vehicleId,
    required this.serviceDate,
    required this.odometerReading,
    required this.serviceType,
    this.description,
    this.oilBrand,
    this.laborCost = 0,
    this.partsCost = 0,
    this.notes,
    this.reminderType = ReminderType.both,
    this.nextServiceOdometer,
    this.nextServiceDate,
    this.reminderEnabled = true,
    this.whatsappEnabled = false,
  });

  final String vehicleId;
  final DateTime serviceDate;
  final int odometerReading;
  final String serviceType;
  final String? description;
  final String? oilBrand;
  final double laborCost;
  final double partsCost;
  final String? notes;
  final ReminderType reminderType;
  final int? nextServiceOdometer;
  final DateTime? nextServiceDate;
  final bool reminderEnabled;
  final bool whatsappEnabled;
}

class ServiceRecordActionsNotifier
    extends StateNotifier<AsyncValue<void>> {
  ServiceRecordActionsNotifier(this._repository)
      : super(const AsyncData(null));

  final ServiceRecordRepository _repository;

  Future<ServiceRecord?> create(ServiceRecordFormData data) async {
    state = const AsyncLoading();
    try {
      final now = DateTime.now();
      final total = data.laborCost + data.partsCost;
      final record = ServiceRecord(
        id: _uuid.v4(),
        vehicleId: data.vehicleId,
        serviceDate: data.serviceDate,
        odometerReading: data.odometerReading,
        serviceType: data.serviceType.trim(),
        description: data.description?.trim(),
        oilBrand: data.oilBrand?.trim(),
        laborCost: data.laborCost,
        partsCost: data.partsCost,
        totalCost: total,
        notes: data.notes?.trim(),
        reminderType: data.reminderEnabled ? data.reminderType : null,
        nextServiceOdometer: data.nextServiceOdometer,
        nextServiceDate: data.nextServiceDate,
        reminderEnabled: data.reminderEnabled,
        whatsappEnabled: data.whatsappEnabled,
        createdAt: now,
        updatedAt: now,
      );
      final created = await _repository.createServiceRecord(record);
      state = const AsyncData(null);
      return created;
    } catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }
}

final serviceRecordActionsProvider = StateNotifierProvider<
    ServiceRecordActionsNotifier, AsyncValue<void>>((ref) {
  return ServiceRecordActionsNotifier(
    ref.watch(serviceRecordRepositoryProvider),
  );
});
