import 'package:flutter/foundation.dart';
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
import '../../../customers/presentation/providers/customer_providers.dart';
import '../../data/debug/vehicle_seed_data.dart';
import '../../domain/entities/vehicle.dart';
import '../providers/vehicle_providers.dart';
import '../widgets/vehicle_card.dart';

/// Global vehicles list with search and filters.
class VehiclesPage extends ConsumerWidget {
  const VehiclesPage({super.key});

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
    } else {
      final String? error = ref.read(vehicleActionsProvider).errorMessage;
      SnackBarHelper.error(
        context,
        error ?? StringConstants.somethingWentWrong,
      );
    }
  }

  String _filterLabel(VehicleListFilter filter) {
    return switch (filter) {
      VehicleListFilter.all => 'All',
      VehicleListFilter.petrol => 'Petrol',
      VehicleListFilter.diesel => 'Diesel',
      VehicleListFilter.hybrid => 'Hybrid',
      VehicleListFilter.electric => 'Electric',
      VehicleListFilter.automatic => 'Automatic',
      VehicleListFilter.manual => 'Manual',
      VehicleListFilter.archived => 'Archived',
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Vehicle>> vehiclesAsync =
        ref.watch(filteredVehiclesProvider);
    final VehicleListFilter filter = ref.watch(vehicleFilterProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: StringConstants.vehicles,
        actions: [
          IconButton(
            icon: const Icon(Icons.archive_outlined),
            tooltip: StringConstants.archivedVehicles,
            onPressed: () => context.push(AppRoutes.archivedVehicles),
          ),
          if (kDebugMode)
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'seed') {
                  final result = await VehicleSeedData.seedDemoData(
                    customerRepository: ref.read(customerRepositoryProvider),
                    vehicleRepository: ref.read(vehicleRepositoryProvider),
                  );
                  if (!context.mounted) return;
                  SnackBarHelper.info(
                    context,
                    'Seeded ${result.customers} customers, ${result.vehicles} vehicles',
                  );
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'seed',
                  child: Text('Insert demo fleet data'),
                ),
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'vehicles-fab',
        onPressed: () => context.push(AppRoutes.addVehicle),
        icon: const Icon(Icons.directions_car_filled_rounded),
        label: const Text('Add'),
      ),
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
              hint: 'Search registration, owner, make, model…',
              onChanged: (value) {
                ref.read(vehicleSearchQueryProvider.notifier).state = value;
              },
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              children: [
                for (final item in VehicleListFilter.values)
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: FilterChip(
                      label: Text(_filterLabel(item)),
                      selected: filter == item,
                      onSelected: (_) {
                        ref.read(vehicleFilterProvider.notifier).state = item;
                      },
                      selectedColor: AppColors.primary.withValues(alpha: 0.15),
                      checkmarkColor: AppColors.primary,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: vehiclesAsync.when(
              loading: () => const Center(child: LoadingIndicator()),
              error: (error, _) => AppErrorWidget(
                message: error.toString(),
                onRetry: () => ref.invalidate(activeVehiclesStreamProvider),
              ),
              data: (vehicles) {
                if (vehicles.isEmpty) {
                  return EmptyState(
                    title: StringConstants.noVehicles,
                    message: StringConstants.noVehiclesSubtitle,
                    icon: Icons.directions_car_outlined,
                    actionLabel: StringConstants.addVehicle,
                    onAction: () => context.push(AppRoutes.addVehicle),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    AppSpacing.sm,
                    AppSpacing.screenPadding,
                    100,
                  ),
                  itemCount: vehicles.length,
                  itemBuilder: (context, index) {
                    final Vehicle vehicle = vehicles[index];
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: Duration(milliseconds: 250 + (index * 40)),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 12 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Dismissible(
                        key: ValueKey(vehicle.id),
                        background: const _SwipeBg(
                          alignment: Alignment.centerLeft,
                          color: AppColors.primary,
                          icon: Icons.edit_rounded,
                          label: StringConstants.editVehicle,
                        ),
                        secondaryBackground: const _SwipeBg(
                          alignment: Alignment.centerRight,
                          color: AppColors.error,
                          icon: Icons.delete_outline_rounded,
                          label: StringConstants.delete,
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            context.push(
                              AppRoutes.editVehiclePath(vehicle.id),
                            );
                            return false;
                          }
                          await _archive(context, ref, vehicle);
                          return false;
                        },
                        child: VehicleCard(
                          vehicle: vehicle,
                          onTap: () => context.push(
                            AppRoutes.vehicleDetailPath(vehicle.id),
                          ),
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

class _SwipeBg extends StatelessWidget {
  const _SwipeBg({
    required this.alignment,
    required this.color,
    required this.icon,
    required this.label,
  });

  final Alignment alignment;
  final Color color;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      alignment: alignment,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: alignment == Alignment.centerLeft
            ? [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 8),
                Text(label, style: const TextStyle(color: Colors.white)),
              ]
            : [
                Text(label, style: const TextStyle(color: Colors.white)),
                const SizedBox(width: 8),
                Icon(icon, color: Colors.white),
              ],
      ),
    );
  }
}
