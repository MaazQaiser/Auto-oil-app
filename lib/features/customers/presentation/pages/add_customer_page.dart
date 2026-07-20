import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/string_constants.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../reminders/domain/entities/reminder_enums.dart';
import '../../../service_records/presentation/providers/service_record_providers.dart';
import '../../../vehicles/domain/entities/vehicle_enums.dart';
import '../../../vehicles/presentation/providers/vehicle_providers.dart';
import '../providers/customer_providers.dart';
import '../widgets/customer_form.dart';

/// Screen for creating a new customer with vehicle details.
class AddCustomerPage extends ConsumerWidget {
  const AddCustomerPage({super.key});

  String _registrationFrom(CustomerFormData data) {
    final reg = data.registrationNumber?.trim() ?? '';
    if (reg.isNotEmpty) return reg.toUpperCase();
    final name = data.vehicleName?.trim() ?? '';
    if (name.isNotEmpty) {
      return name.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]+'), '-');
    }
    final make = (data.vehicleMake ?? 'VEH').trim().toUpperCase();
    final model = (data.vehicleModel ?? 'AUTO').trim().toUpperCase();
    final stamp = DateTime.now().millisecondsSinceEpoch % 100000;
    return '$make-$model-$stamp';
  }

  String? _vehicleNotes(CustomerFormData data) {
    final parts = <String>[];
    final name = data.vehicleName?.trim() ?? '';
    final oil = data.recommendedOil?.trim() ?? '';
    if (name.isNotEmpty) parts.add('Vehicle name: $name');
    if (oil.isNotEmpty) parts.add('Recommended oil: $oil');
    if (parts.isEmpty) return null;
    return parts.join('\n');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CustomerActionState actionState = ref.watch(customerActionsProvider);
    final VehicleActionState vehicleState = ref.watch(vehicleActionsProvider);
    final serviceState = ref.watch(serviceRecordActionsProvider);
    final bool isLoading =
        actionState.isLoading ||
        vehicleState.isLoading ||
        serviceState.isLoading;

    return Scaffold(
      appBar: const CustomAppBar(title: StringConstants.addCustomer),
      body: CustomerForm(
        includeVehicleSection: true,
        isLoading: isLoading,
        onCancel: () => context.pop(),
        onSubmit: (data) async {
          final customer = await ref
              .read(customerActionsProvider.notifier)
              .create(data);
          if (!context.mounted) return;
          if (customer == null) {
            final String? error = ref
                .read(customerActionsProvider)
                .errorMessage;
            SnackBarHelper.error(
              context,
              error ?? StringConstants.somethingWentWrong,
            );
            return;
          }

          final make = data.vehicleMake?.trim() ?? '';
          final model = data.vehicleModel?.trim() ?? '';
          final odo = data.odometerReading;
          if (make.isEmpty || model.isEmpty || odo == null) {
            SnackBarHelper.warning(
              context,
              'Customer saved, but vehicle details were incomplete.',
            );
            context.pop();
            return;
          }

          final vehicle = await ref
              .read(vehicleActionsProvider.notifier)
              .create(
                VehicleFormData(
                  customerId: customer.id,
                  make: make,
                  model: model,
                  variant: data.vehicleVariant,
                  registrationNumber: _registrationFrom(data),
                  fuelType: FuelType.petrol,
                  transmission: TransmissionType.automatic,
                  currentOdo: odo,
                  notes: _vehicleNotes(data),
                ),
              );
          if (!context.mounted) return;
          if (vehicle == null) {
            final String? error = ref
                .read(vehicleActionsProvider)
                .errorMessage;
            SnackBarHelper.warning(
              context,
              'Customer saved, but vehicle was not added: ${error ?? 'unknown error'}',
            );
            context.pop();
            return;
          }

          final nextOdo = data.nextServiceOdometer ?? (odo + 5000);
          final nextDate =
              data.nextServiceDate ??
              DateTime.now().add(const Duration(days: 90));

          await ref.read(serviceRecordActionsProvider.notifier).create(
            ServiceRecordFormData(
              vehicleId: vehicle.id,
              serviceDate: DateTime.now(),
              odometerReading: odo,
              serviceType: 'Initial Registration',
              oilBrand: data.recommendedOil,
              description: 'Created with customer registration',
              nextServiceOdometer: nextOdo,
              nextServiceDate: nextDate,
              reminderType: ReminderType.both,
              reminderEnabled: true,
            ),
          );

          if (!context.mounted) return;
          SnackBarHelper.success(context, StringConstants.customerAdded);
          context.pop();
        },
      ),
    );
  }
}
