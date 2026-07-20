import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/string_constants.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../providers/vehicle_providers.dart';
import '../widgets/vehicle_form.dart';

class AddVehiclePage extends ConsumerWidget {
  const AddVehiclePage({super.key, this.customerId});

  final String? customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final VehicleActionState actionState = ref.watch(vehicleActionsProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: StringConstants.addVehicle),
      body: VehicleForm(
        fixedCustomerId: customerId,
        isLoading: actionState.isLoading,
        onCancel: () => context.pop(),
        onSubmit: (data) async {
          final vehicle =
              await ref.read(vehicleActionsProvider.notifier).create(data);
          if (!context.mounted) return;
          if (vehicle != null) {
            SnackBarHelper.success(context, StringConstants.vehicleAdded);
            context.pop();
          } else {
            final String? error =
                ref.read(vehicleActionsProvider).errorMessage;
            SnackBarHelper.error(
              context,
              error ?? StringConstants.somethingWentWrong,
            );
          }
        },
      ),
    );
  }
}
