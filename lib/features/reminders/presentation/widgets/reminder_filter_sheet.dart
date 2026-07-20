import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../customers/domain/entities/customer.dart';
import '../../../customers/presentation/providers/customer_providers.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/presentation/providers/vehicle_providers.dart';
import '../../domain/entities/reminder_enums.dart';
import '../providers/reminder_providers.dart';

class ReminderFilterSheet extends ConsumerWidget {
  const ReminderFilterSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const ReminderFilterSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ReminderFilter filter = ref.watch(reminderFilterProvider);
    final customersAsync = ref.watch(activeCustomersStreamProvider);
    final vehiclesAsync = ref.watch(activeVehiclesStreamProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.xxl,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Filters', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.lg),
          DropdownButtonFormField<ReminderType?>(
            initialValue: filter.reminderType,
            decoration: const InputDecoration(labelText: 'Reminder type'),
            items: [
              const DropdownMenuItem(value: null, child: Text('All types')),
              for (final t in ReminderType.values)
                DropdownMenuItem(value: t, child: Text(t.label)),
            ],
            onChanged: (value) {
              ref.read(reminderFilterProvider.notifier).state = filter.copyWith(
                reminderType: value,
                clearType: value == null,
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          customersAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => const SizedBox.shrink(),
            data: (List<Customer> customers) {
              return DropdownButtonFormField<String?>(
                initialValue: filter.customerId,
                decoration: const InputDecoration(labelText: 'Customer'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All customers')),
                  for (final c in customers)
                    DropdownMenuItem(value: c.id, child: Text(c.fullName)),
                ],
                onChanged: (value) {
                  ref.read(reminderFilterProvider.notifier).state =
                      filter.copyWith(
                    customerId: value,
                    clearCustomer: value == null,
                  );
                },
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),
          vehiclesAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
            data: (List<Vehicle> vehicles) {
              return DropdownButtonFormField<String?>(
                initialValue: filter.vehicleId,
                decoration: const InputDecoration(labelText: 'Vehicle'),
                items: [
                  const DropdownMenuItem(value: null, child: Text('All vehicles')),
                  for (final v in vehicles)
                    DropdownMenuItem(
                      value: v.id,
                      child: Text('${v.displayName} (${v.registrationNumber})'),
                    ),
                ],
                onChanged: (value) {
                  ref.read(reminderFilterProvider.notifier).state =
                      filter.copyWith(
                    vehicleId: value,
                    clearVehicle: value == null,
                  );
                },
              );
            },
          ),
          const SizedBox(height: AppSpacing.xxl),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(reminderFilterProvider.notifier).state =
                        const ReminderFilter();
                    Navigator.pop(context);
                  },
                  child: const Text('Clear'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
