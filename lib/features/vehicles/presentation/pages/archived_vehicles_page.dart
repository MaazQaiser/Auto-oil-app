import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/string_constants.dart';
import '../../../../core/errors/widgets/app_error_widget.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/search_field.dart';
import '../../domain/entities/vehicle.dart';
import '../providers/vehicle_providers.dart';
import '../widgets/vehicle_card.dart';

class ArchivedVehiclesPage extends ConsumerWidget {
  const ArchivedVehiclesPage({super.key});

  Future<void> _restore(
    BuildContext context,
    WidgetRef ref,
    Vehicle vehicle,
  ) async {
    final bool? confirmed = await ConfirmationDialog.show(
      context,
      title: 'Restore vehicle?',
      message: 'Restore ${vehicle.displayName} to the active vehicles list?',
      confirmLabel: StringConstants.restoreVehicle,
    );
    if (confirmed != true) return;

    final bool success =
        await ref.read(vehicleActionsProvider.notifier).restore(vehicle.id);
    if (!context.mounted) return;
    if (success) {
      SnackBarHelper.success(context, StringConstants.vehicleRestored);
    } else {
      final String? error = ref.read(vehicleActionsProvider).errorMessage;
      SnackBarHelper.error(
        context,
        error ?? StringConstants.somethingWentWrong,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Vehicle>> vehiclesAsync =
        ref.watch(filteredArchivedVehiclesProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: StringConstants.archivedVehicles),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.md,
              AppSpacing.screenPadding,
              AppSpacing.sm,
            ),
            child: SearchField(
              hint: 'Search archived vehicles…',
              onChanged: (value) {
                ref.read(archivedVehicleSearchQueryProvider.notifier).state =
                    value;
              },
            ),
          ),
          Expanded(
            child: vehiclesAsync.when(
              loading: () => const Center(child: LoadingIndicator()),
              error: (error, _) => AppErrorWidget(
                message: error.toString(),
                onRetry: () =>
                    ref.invalidate(archivedVehiclesStreamProvider),
              ),
              data: (vehicles) {
                if (vehicles.isEmpty) {
                  return const EmptyState(
                    title: StringConstants.noArchivedVehicles,
                    message: 'Archived vehicles will appear here.',
                    icon: Icons.archive_outlined,
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    AppSpacing.sm,
                    AppSpacing.screenPadding,
                    AppSpacing.xxxl,
                  ),
                  itemCount: vehicles.length,
                  itemBuilder: (context, index) {
                    final Vehicle vehicle = vehicles[index];
                    return Dismissible(
                      key: ValueKey('archived-vehicle-${vehicle.id}'),
                      direction: DismissDirection.startToEnd,
                      background: Container(
                        margin: const EdgeInsets.only(bottom: AppSpacing.md),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                        ),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.unarchive_outlined, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              StringConstants.restoreVehicle,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      confirmDismiss: (_) async {
                        await _restore(context, ref, vehicle);
                        return false;
                      },
                      child: VehicleCard(
                        vehicle: vehicle,
                        onTap: () => context.push(
                          AppRoutes.vehicleDetailPath(vehicle.id),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
