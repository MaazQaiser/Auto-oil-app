import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/string_constants.dart';
import '../../../../core/errors/widgets/app_error_widget.dart';
import '../../../../core/extensions/datetime_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../../../core/widgets/whatsapp_cta_button.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/presentation/providers/vehicle_providers.dart';
import '../../../vehicles/presentation/widgets/vehicle_card.dart';
import '../../domain/entities/customer.dart';
import '../providers/customer_providers.dart';
import '../widgets/customer_avatar.dart';
import '../widgets/customer_info_tile.dart';

/// Full customer profile screen.
class CustomerDetailPage extends ConsumerWidget {
  const CustomerDetailPage({super.key, required this.customerId});

  final String customerId;

  Future<void> _launchTel(BuildContext context, String phone) async {
    final Uri uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (context.mounted) {
      SnackBarHelper.error(context, 'Unable to open phone dialer');
    }
  }

  Future<void> _launchWhatsApp(BuildContext context, String phone) async {
    final String digits = phone.replaceAll(RegExp(r'\D'), '');
    final Uri uri = Uri.parse('https://wa.me/$digits');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      SnackBarHelper.error(context, 'Unable to open WhatsApp');
    }
  }

  Future<void> _openUpdateMaintenanceLog(
    BuildContext context,
    List<Vehicle> vehicles,
  ) async {
    if (vehicles.isEmpty) {
      SnackBarHelper.warning(
        context,
        'Add a vehicle first to update the maintenance log',
      );
      return;
    }

    String? vehicleId = vehicles.length == 1 ? vehicles.first.id : null;
    vehicleId ??= await showModalBottomSheet<String>(
        context: context,
        backgroundColor: AppColors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (ctx) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Which vehicle?',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.charcoal,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'This customer has multiple vehicles. Choose one to update.',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  for (final v in vehicles)
                    ListTile(
                      leading: const Icon(
                        Icons.directions_car_outlined,
                        color: AppColors.gold,
                      ),
                      title: Text(v.displayName),
                      subtitle: Text(v.registrationNumber),
                      onTap: () => Navigator.pop(ctx, v.id),
                    ),
                ],
              ),
            ),
          );
        },
      );

    if (vehicleId == null || !context.mounted) return;
    context.push(AppRoutes.updateServiceHistoryPath(vehicleId));
  }

  Future<void> _archive(
    BuildContext context,
    WidgetRef ref,
    Customer customer,
  ) async {
    final bool? confirmed = await ConfirmationDialog.show(
      context,
      title: StringConstants.archiveConfirmTitle,
      message: StringConstants.archiveConfirmMessage,
      confirmLabel: StringConstants.archiveCustomer,
      isDestructive: true,
    );
    if (confirmed != true) return;

    final bool success =
        await ref.read(customerActionsProvider.notifier).archive(customer.id);
    if (!context.mounted) return;
    if (success) {
      SnackBarHelper.success(context, StringConstants.customerArchived);
      context.pop();
    } else {
      final String? error = ref.read(customerActionsProvider).errorMessage;
      SnackBarHelper.error(
        context,
        error ?? StringConstants.somethingWentWrong,
      );
    }
  }

  Future<void> _restore(
    BuildContext context,
    WidgetRef ref,
    Customer customer,
  ) async {
    final bool success =
        await ref.read(customerActionsProvider.notifier).restore(customer.id);
    if (!context.mounted) return;
    if (success) {
      ref.invalidate(customerByIdProvider(customerId));
      SnackBarHelper.success(context, StringConstants.customerRestored);
    } else {
      final String? error = ref.read(customerActionsProvider).errorMessage;
      SnackBarHelper.error(
        context,
        error ?? StringConstants.somethingWentWrong,
      );
    }
  }

  Widget _buildHeroCard(
    BuildContext context, {
    required Customer customer,
    required String whatsapp,
    required List<Vehicle> vehicles,
  }) {
    final Color muted = Theme.of(context).brightness == Brightness.dark
        ? AppColors.silver
        : AppColors.grey600;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomerAvatar(
                name: customer.fullName,
                size: 72,
                fontSize: 30,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.fullName,
                      style: AppTextStyles.titleLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      customer.phoneNumber,
                      style: AppTextStyles.bodyMedium.copyWith(color: muted),
                    ),
                    if (customer.isArchived) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Chip(
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        avatar: const Icon(Icons.archive_outlined, size: 14),
                        label: const Text('Archived'),
                        backgroundColor:
                            AppColors.warning.withValues(alpha: 0.12),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton.filled(
                    tooltip: 'Call',
                    onPressed: () => _launchTel(context, customer.phoneNumber),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.grey100,
                      foregroundColor: AppColors.charcoal,
                      minimumSize: const Size(40, 40),
                    ),
                    icon: const Icon(Icons.phone_rounded, size: 20),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  WhatsAppIconButton(
                    filled: true,
                    onPressed: () => _launchWhatsApp(context, whatsapp),
                  ),
                ],
              ),
            ],
          ),
          if (!customer.isArchived) ...[
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: WhatsAppCtaButton(
                    onPressed: () => _launchWhatsApp(context, whatsapp),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  flex: 2,
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        _openUpdateMaintenanceLog(context, vehicles),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 48),
                      foregroundColor: AppColors.charcoal,
                      side: const BorderSide(color: AppColors.grey300),
                    ),
                    icon: const Icon(Icons.note_alt_outlined, size: 18),
                    label: const Text('Log'),
                  ),
                ),
              ],
            ),
          ] else ...[
            const SizedBox(height: AppSpacing.lg),
            WhatsAppCtaButton(
              onPressed: () => _launchWhatsApp(context, whatsapp),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContactSection(
    BuildContext context, {
    required Customer customer,
    required String whatsapp,
  }) {
    return AppCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        children: [
          CustomerInfoTile(
            compact: true,
            icon: Icons.phone_outlined,
            label: StringConstants.phoneNumber,
            value: customer.phoneNumber,
            onTap: () => _launchTel(context, customer.phoneNumber),
            trailingAction: CustomerInfoActionButton(
              icon: Icons.phone_rounded,
              tooltip: 'Call',
              onPressed: () => _launchTel(context, customer.phoneNumber),
            ),
          ),
          const Divider(height: 1, indent: 48),
          CustomerInfoTile(
            compact: true,
            icon: Icons.chat_outlined,
            label: StringConstants.whatsappNumber,
            value: customer.whatsappNumber ?? customer.phoneNumber,
            onTap: () => _launchWhatsApp(context, whatsapp),
            trailingAction: CustomerInfoActionButton(
              icon: Icons.chat_rounded,
              tooltip: 'WhatsApp',
              useWhatsAppBrand: true,
              onPressed: () => _launchWhatsApp(context, whatsapp),
            ),
          ),
          if (customer.email?.trim().isNotEmpty ?? false) ...[
            const Divider(height: 1, indent: 48),
            CustomerInfoTile(
              compact: true,
              icon: Icons.email_outlined,
              label: StringConstants.email,
              value: customer.email!,
            ),
          ],
          if (customer.address?.trim().isNotEmpty ?? false) ...[
            const Divider(height: 1, indent: 48),
            CustomerInfoTile(
              compact: true,
              icon: Icons.home_outlined,
              label: StringConstants.address,
              value: customer.address!,
            ),
          ],
          if (customer.city?.trim().isNotEmpty ?? false) ...[
            const Divider(height: 1, indent: 48),
            CustomerInfoTile(
              compact: true,
              icon: Icons.location_city_outlined,
              label: StringConstants.city,
              value: customer.city!,
            ),
          ],
          if (customer.notes?.trim().isNotEmpty ?? false) ...[
            const Divider(height: 1, indent: 48),
            CustomerInfoTile(
              compact: true,
              icon: Icons.notes_outlined,
              label: StringConstants.notes,
              value: customer.notes!,
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Customer?> customerAsync =
        ref.watch(customerByIdProvider(customerId));
    final AsyncValue<List<Vehicle>> vehiclesAsync =
        ref.watch(vehiclesByCustomerProvider(customerId));
    final bool isMutating = ref.watch(
      customerActionsProvider.select((s) => s.isLoading),
    );
    final bool isArchived = customerAsync.maybeWhen(
      data: (c) => c?.isArchived ?? false,
      orElse: () => false,
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: StringConstants.customerDetails,
        actions: [
          customerAsync.maybeWhen(
            data: (customer) {
              if (customer == null || customer.isArchived) {
                return const SizedBox.shrink();
              }
              return IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: StringConstants.editCustomer,
                onPressed: () =>
                    context.push(AppRoutes.editCustomerPath(customerId)),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      floatingActionButton: isArchived
          ? null
          : FloatingActionButton.extended(
              heroTag: 'customer-add-vehicle-fab',
              backgroundColor: AppColors.charcoal,
              foregroundColor: AppColors.white,
              onPressed: () => context.push(
                AppRoutes.addVehicleForCustomer(customerId),
              ),
              icon: const Icon(Icons.directions_car_filled_rounded),
              label: const Text(StringConstants.addVehicle),
            ),
      body: customerAsync.when(
        loading: () => const Center(child: LoadingIndicator()),
        error: (error, _) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(customerByIdProvider(customerId)),
        ),
        data: (customer) {
          if (customer == null) {
            return const AppErrorWidget(message: 'Customer not found');
          }

          final String whatsapp =
              customer.whatsappNumber ?? customer.phoneNumber;
          final List<Vehicle> vehicles =
              vehiclesAsync.maybeWhen(data: (v) => v, orElse: () => <Vehicle>[]);

          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.md,
              AppSpacing.screenPadding,
              96,
            ),
            children: [
              _buildHeroCard(
                context,
                customer: customer,
                whatsapp: whatsapp,
                vehicles: vehicles,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Customer Information',
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              _buildContactSection(
                context,
                customer: customer,
                whatsapp: whatsapp,
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: _MetaChip(
                      icon: Icons.calendar_today_outlined,
                      label: 'Created',
                      value: customer.createdAt.formattedDateTime,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _MetaChip(
                      icon: Icons.update_outlined,
                      label: 'Updated',
                      value: customer.updatedAt.formattedDateTime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Vehicles',
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (!customer.isArchived)
                    TextButton.icon(
                      onPressed: () => context.push(
                        AppRoutes.addVehicleForCustomer(customerId),
                      ),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text(StringConstants.addVehicle),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              vehiclesAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  child: Center(child: LoadingIndicator()),
                ),
                error: (error, _) => AppErrorWidget(
                  message: error.toString(),
                  onRetry: () =>
                      ref.invalidate(vehiclesByCustomerProvider(customerId)),
                ),
                data: (vehicleList) {
                  if (vehicleList.isEmpty) {
                    return EmptyState(
                      title: StringConstants.noVehicles,
                      message: StringConstants.noVehiclesSubtitle,
                      icon: Icons.directions_car_outlined,
                      actionLabel: customer.isArchived
                          ? null
                          : StringConstants.addVehicle,
                      onAction: customer.isArchived
                          ? null
                          : () => context.push(
                                AppRoutes.addVehicleForCustomer(customerId),
                              ),
                    );
                  }
                  return Column(
                    children: [
                      for (final vehicle in vehicleList)
                        VehicleCard(
                          vehicle: vehicle,
                          compact: true,
                          showOwner: false,
                          onTap: () => context.push(
                            AppRoutes.vehicleDetailPath(vehicle.id),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              if (!customer.isArchived) ...[
                SecondaryButton(
                  label: StringConstants.editCustomer,
                  icon: Icons.edit_rounded,
                  isLoading: isMutating,
                  onPressed: isMutating
                      ? null
                      : () =>
                          context.push(AppRoutes.editCustomerPath(customerId)),
                ),
                const SizedBox(height: AppSpacing.sm),
                SecondaryButton(
                  label: StringConstants.archiveCustomer,
                  icon: Icons.archive_outlined,
                  onPressed: isMutating
                      ? null
                      : () => _archive(context, ref, customer),
                ),
              ] else
                SecondaryButton(
                  label: StringConstants.restoreCustomer,
                  icon: Icons.unarchive_outlined,
                  isLoading: isMutating,
                  onPressed:
                      isMutating ? null : () => _restore(context, ref, customer),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final Color muted = Theme.of(context).brightness == Brightness.dark
        ? AppColors.silver
        : AppColors.grey600;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: muted),
              const SizedBox(width: AppSpacing.xxs),
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(color: muted),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
