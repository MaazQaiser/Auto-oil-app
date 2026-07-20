import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/string_constants.dart';
import '../../../../core/errors/widgets/app_error_widget.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../domain/entities/vehicle.dart';
import '../providers/vehicle_providers.dart';
import '../widgets/vehicle_form.dart';

class EditVehiclePage extends ConsumerWidget {
  const EditVehiclePage({super.key, required this.vehicleId});

  final String vehicleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Vehicle?> vehicleAsync =
        ref.watch(vehicleByIdProvider(vehicleId));
    final VehicleActionState actionState = ref.watch(vehicleActionsProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: StringConstants.editVehicle),
      body: vehicleAsync.when(
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, _) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(vehicleByIdProvider(vehicleId)),
        ),
        data: (vehicle) {
          if (vehicle == null) {
            return const AppErrorWidget(message: 'Vehicle not found');
          }
          return VehicleForm(
            initialVehicle: vehicle,
            isLoading: actionState.isLoading,
            onCancel: () => context.pop(),
            onSubmit: (data) async {
              final updated = await ref
                  .read(vehicleActionsProvider.notifier)
                  .update(vehicleId, data);
              if (!context.mounted) return;
              if (updated != null) {
                ref.invalidate(vehicleByIdProvider(vehicleId));
                SnackBarHelper.success(
                  context,
                  StringConstants.vehicleUpdated,
                );
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
          );
        },
      ),
    );
  }
}
