import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/providers/database_provider.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../data/datasources/reminder_local_datasource.dart';
import '../../data/repositories/reminder_repository_impl.dart';
import '../../domain/entities/maintenance_reminder.dart';
import '../../domain/entities/reminder_enums.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../../domain/services/reminder_background_service.dart';
import '../../domain/services/reminder_calculator.dart';
import '../../domain/services/reminder_service.dart';

final reminderCalculatorProvider = Provider<ReminderCalculator>((ref) {
  return const ReminderCalculator();
});

final reminderLocalDataSourceProvider = Provider<ReminderLocalDataSource>((ref) {
  return ReminderLocalDataSource(
    ref.watch(databaseProvider),
    calculator: ref.watch(reminderCalculatorProvider),
  );
});

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  return ReminderRepositoryImpl(
    ref.watch(reminderLocalDataSourceProvider),
    ref.watch(syncQueueProvider),
  );
});

final reminderServiceProvider = Provider<ReminderService>((ref) {
  return ReminderService(
    ref.watch(reminderRepositoryProvider),
    calculator: ref.watch(reminderCalculatorProvider),
  );
});

final reminderBackgroundServiceProvider =
    Provider<ReminderBackgroundService>((ref) {
  return ReminderBackgroundService(ref.watch(reminderRepositoryProvider));
});

final reminderSearchQueryProvider = StateProvider<String>((ref) => '');

final reminderStatusTabProvider =
    StateProvider<ReminderStatus>((ref) => ReminderStatus.upcoming);

final reminderFilterProvider =
    StateProvider<ReminderFilter>((ref) => const ReminderFilter());

class ReminderFilter extends Equatable {
  const ReminderFilter({
    this.status,
    this.customerId,
    this.vehicleId,
    this.reminderType,
    this.month,
  });

  final ReminderStatus? status;
  final String? customerId;
  final String? vehicleId;
  final ReminderType? reminderType;
  final DateTime? month;

  ReminderFilter copyWith({
    ReminderStatus? status,
    String? customerId,
    String? vehicleId,
    ReminderType? reminderType,
    DateTime? month,
    bool clearStatus = false,
    bool clearCustomer = false,
    bool clearVehicle = false,
    bool clearType = false,
    bool clearMonth = false,
  }) {
    return ReminderFilter(
      status: clearStatus ? null : (status ?? this.status),
      customerId: clearCustomer ? null : (customerId ?? this.customerId),
      vehicleId: clearVehicle ? null : (vehicleId ?? this.vehicleId),
      reminderType: clearType ? null : (reminderType ?? this.reminderType),
      month: clearMonth ? null : (month ?? this.month),
    );
  }

  @override
  List<Object?> get props =>
      [status, customerId, vehicleId, reminderType, month];
}

final allRemindersStreamProvider =
    StreamProvider<List<MaintenanceReminder>>((ref) {
  return ref.watch(reminderRepositoryProvider).watchAll();
});

final reminderSummaryProvider = FutureProvider<ReminderSummary>((ref) async {
  // Refresh when reminders change.
  ref.watch(allRemindersStreamProvider);
  return ref.watch(reminderRepositoryProvider).getSummary();
});

final filteredRemindersProvider =
    Provider<AsyncValue<List<MaintenanceReminder>>>((ref) {
  final AsyncValue<List<MaintenanceReminder>> all =
      ref.watch(allRemindersStreamProvider);
  final ReminderStatus tab = ref.watch(reminderStatusTabProvider);
  final String query = ref.watch(reminderSearchQueryProvider).trim().toLowerCase();
  final ReminderFilter filter = ref.watch(reminderFilterProvider);

  return all.whenData((list) {
    Iterable<MaintenanceReminder> result =
        list.where((r) => r.status == tab);

    if (filter.customerId != null) {
      result = result.where((r) => r.customerId == filter.customerId);
    }
    if (filter.vehicleId != null) {
      result = result.where((r) => r.vehicleId == filter.vehicleId);
    }
    if (filter.reminderType != null) {
      result = result.where((r) => r.reminderType == filter.reminderType);
    }
    if (filter.month != null) {
      result = result.where((r) {
        if (r.nextServiceDate == null) return false;
        return r.nextServiceDate!.year == filter.month!.year &&
            r.nextServiceDate!.month == filter.month!.month;
      });
    }
    if (query.isNotEmpty) {
      result = result.where((r) {
        return (r.ownerName?.toLowerCase().contains(query) ?? false) ||
            (r.registrationNumber?.toLowerCase().contains(query) ?? false) ||
            (r.vehicleDisplayName?.toLowerCase().contains(query) ?? false);
      });
    }
    return result.toList();
  });
});

final dueTodayRemindersProvider =
    Provider<AsyncValue<List<MaintenanceReminder>>>((ref) {
  return ref.watch(allRemindersStreamProvider).whenData(
        (list) => list.where((r) => r.status == ReminderStatus.due).toList(),
      );
});

final overdueRemindersProvider =
    Provider<AsyncValue<List<MaintenanceReminder>>>((ref) {
  return ref.watch(allRemindersStreamProvider).whenData(
        (list) =>
            list.where((r) => r.status == ReminderStatus.overdue).toList(),
      );
});

final upcomingRemindersProvider =
    Provider<AsyncValue<List<MaintenanceReminder>>>((ref) {
  return ref.watch(allRemindersStreamProvider).whenData(
        (list) =>
            list.where((r) => r.status == ReminderStatus.upcoming).toList(),
      );
});

final upcomingThisWeekProvider =
    Provider<AsyncValue<List<MaintenanceReminder>>>((ref) {
  final DateTime today = DateTime.now();
  final DateTime start = DateTime(today.year, today.month, today.day);
  final DateTime end = start.add(const Duration(days: 7));
  return ref.watch(allRemindersStreamProvider).whenData((list) {
    return list.where((r) {
      if (r.status != ReminderStatus.upcoming) return false;
      if (r.nextServiceDate == null) return false;
      final d = DateTime(
        r.nextServiceDate!.year,
        r.nextServiceDate!.month,
        r.nextServiceDate!.day,
      );
      return !d.isBefore(start) && !d.isAfter(end);
    }).toList();
  });
});

final activeReminderForVehicleProvider =
    FutureProvider.family<MaintenanceReminder?, String>((ref, vehicleId) {
  return ref.watch(reminderRepositoryProvider).getActiveForVehicle(vehicleId);
});

class ReminderActionsNotifier extends StateNotifier<AsyncValue<void>> {
  ReminderActionsNotifier(this._service) : super(const AsyncData(null));

  final ReminderService _service;

  Future<bool> markCompleted(String id) async {
    state = const AsyncLoading();
    try {
      await _service.markCompleted(id);
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  Future<bool> update(MaintenanceReminder reminder) async {
    state = const AsyncLoading();
    try {
      await _service.updateReminder(reminder);
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final reminderActionsProvider =
    StateNotifierProvider<ReminderActionsNotifier, AsyncValue<void>>((ref) {
  return ReminderActionsNotifier(ref.watch(reminderServiceProvider));
});
