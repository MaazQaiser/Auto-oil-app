import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/string_constants.dart';
import '../../../../core/errors/widgets/app_error_widget.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../../../core/widgets/section_title.dart';
import '../../../reminders/presentation/widgets/vehicle_maintenance_status_card.dart';
import '../../../service_records/presentation/pages/service_records_page.dart';
import '../../domain/entities/vehicle.dart';
import '../providers/vehicle_providers.dart';
import '../widgets/vehicle_avatar.dart';
import '../widgets/vehicle_info_tile.dart';
import '../widgets/vehicle_maintenance_log_section.dart';

class VehicleDetailPage extends ConsumerWidget {
  const VehicleDetailPage({super.key, required this.vehicleId});

  final String vehicleId;

  Future<void> _archive(
    BuildContext context,
    WidgetRef ref,
    Vehicle vehicle,
  ) async {
    final bool? confirmed = await ConfirmationDialog.show(
      context,
      title: StringConstants.archiveVehicleTitle,
      message: StringConstants.archiveVehicleMessage,
      confirmLabel: StringConstants.archiveVehicle,
      isDestructive: true,
    );
    if (confirmed != true) return;

    final bool success =
        await ref.read(vehicleActionsProvider.notifier).archive(vehicle.id);
    if (!context.mounted) return;
    if (success) {
      SnackBarHelper.success(context, StringConstants.vehicleArchived);
      context.pop();
    } else {
      final String? error = ref.read(vehicleActionsProvider).errorMessage;
      SnackBarHelper.error(
        context,
        error ?? StringConstants.somethingWentWrong,
      );
    }
  }

  Future<void> _restore(
    BuildContext context,
    WidgetRef ref,
    Vehicle vehicle,
  ) async {
    final bool success =
        await ref.read(vehicleActionsProvider.notifier).restore(vehicle.id);
    if (!context.mounted) return;
    if (success) {
      ref.invalidate(vehicleByIdProvider(vehicleId));
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
    final AsyncValue<Vehicle?> vehicleAsync =
        ref.watch(vehicleByIdProvider(vehicleId));
    final bool isMutating = ref.watch(
      vehicleActionsProvider.select((s) => s.isLoading),
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: StringConstants.vehicleDetails,
        actions: [
          vehicleAsync.maybeWhen(
            data: (vehicle) {
              if (vehicle == null || vehicle.isArchived) {
                return const SizedBox.shrink();
              }
              return IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () =>
                    context.push(AppRoutes.editVehiclePath(vehicleId)),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
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

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: [
              Center(
                child: Column(
                  children: [
                    VehicleAvatar(
                      size: 110,
                      heroTag: 'vehicle-avatar-${vehicle.id}',
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      vehicle.displayName,
                      style: AppTextStyles.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      vehicle.registrationNumber,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      children: [
                        FuelChip(label: vehicle.fuelType.label),
                        TransmissionChip(label: vehicle.transmission.label),
                        if (vehicle.year != null)
                          VehicleBadge(label: '${vehicle.year}'),
                        if (vehicle.isArchived)
                          const VehicleBadge(
                            label: 'Archived',
                            color: AppColors.warning,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              const SectionTitle(
                title: 'Vehicle Information',
                padding: EdgeInsets.only(bottom: AppSpacing.md),
              ),
              AppCard(
                child: Column(
                  children: [
                    VehicleInfoTile(
                      icon: Icons.factory_outlined,
                      label: StringConstants.make,
                      value: vehicle.make,
                    ),
                    const Divider(height: 1),
                    VehicleInfoTile(
                      icon: Icons.directions_car_outlined,
                      label: StringConstants.model,
                      value: vehicle.model,
                    ),
                    const Divider(height: 1),
                    VehicleInfoTile(
                      icon: Icons.tune_outlined,
                      label: StringConstants.variant,
                      value: vehicle.variant ?? '',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const SectionTitle(
                title: 'Owner Information',
                padding: EdgeInsets.only(bottom: AppSpacing.md),
              ),
              AppCard(
                onTap: () => context.push(
                  AppRoutes.customerDetailPath(vehicle.customerId),
                ),
                child: VehicleInfoTile(
                  icon: Icons.person_outline_rounded,
                  label: StringConstants.owner,
                  value: vehicle.ownerName ?? vehicle.customerId,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const SectionTitle(
                title: 'Current ODO',
                padding: EdgeInsets.only(bottom: AppSpacing.md),
              ),
              AppCard(
                child: VehicleInfoTile(
                  icon: Icons.speed_rounded,
                  label: StringConstants.currentOdo,
                  value: vehicle.formattedOdo,
                ),
              ),
              if (vehicle.notes != null && vehicle.notes!.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                const SectionTitle(
                  title: StringConstants.notes,
                  padding: EdgeInsets.only(bottom: AppSpacing.md),
                ),
                AppCard(
                  child: Text(vehicle.notes!, style: AppTextStyles.bodyMedium),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              VehicleMaintenanceLogSection(
                vehicleId: vehicleId,
                readOnly: vehicle.isArchived,
              ),
              const SizedBox(height: AppSpacing.lg),
              VehicleMaintenanceStatusCard(vehicleId: vehicleId),
              const SizedBox(height: AppSpacing.lg),
              const SectionTitle(
                title: 'Service History',
                padding: EdgeInsets.only(bottom: AppSpacing.md),
              ),
              VehicleServiceHistoryList(vehicleId: vehicleId),
              const SizedBox(height: AppSpacing.xxl),
              if (!vehicle.isArchived) ...[
                PrimaryButton(
                  label: 'Update Service History',
                  icon: Icons.build_circle_outlined,
                  onPressed: () => context.push(
                    AppRoutes.updateServiceHistoryPath(vehicleId),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                PrimaryButton(
                  label: StringConstants.editVehicle,
                  icon: Icons.edit_rounded,
                  isLoading: isMutating,
                  onPressed: isMutating
                      ? null
                      : () =>
                          context.push(AppRoutes.editVehiclePath(vehicleId)),
                ),
                const SizedBox(height: AppSpacing.md),
                SecondaryButton(
                  label: StringConstants.archiveVehicle,
                  icon: Icons.archive_outlined,
                  onPressed: isMutating
                      ? null
                      : () => _archive(context, ref, vehicle),
                ),
              ] else
                PrimaryButton(
                  label: StringConstants.restoreVehicle,
                  icon: Icons.unarchive_outlined,
                  isLoading: isMutating,
                  onPressed:
                      isMutating ? null : () => _restore(context, ref, vehicle),
                ),
              const SizedBox(height: AppSpacing.xxl),
            ],
          );
        },
      ),
    );
  }
}
