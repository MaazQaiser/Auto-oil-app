import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../../domain/entities/customer.dart';
import '../providers/customer_providers.dart';
import '../widgets/customer_card.dart';
import '../widgets/customer_search_bar.dart';

/// Active customers list with search and swipe actions.
class CustomersPage extends ConsumerWidget {
  const CustomersPage({super.key});

  Future<void> _archiveCustomer(
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
    } else {
      final String? error = ref.read(customerActionsProvider).errorMessage;
      SnackBarHelper.error(context, error ?? StringConstants.somethingWentWrong);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Customer>> customersAsync =
        ref.watch(filteredCustomersProvider);
    final bool selectionMode = ref.watch(customerSelectionModeProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: selectionMode
            ? 'Select customers'
            : StringConstants.customers,
        actions: [
          if (selectionMode)
            IconButton(
              icon: const Icon(Icons.close_rounded),
              tooltip: 'Exit selection',
              onPressed: () {
                ref.read(customerSelectionModeProvider.notifier).state = false;
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.archive_outlined),
              tooltip: StringConstants.archivedCustomers,
              onPressed: () => context.push(AppRoutes.archivedCustomers),
            ),
        ],
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
            child: Row(
              children: [
                Expanded(
                  child: CustomerSearchBar(
                    onChanged: (value) {
                      ref.read(customerSearchQueryProvider.notifier).state =
                          value;
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Material(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  child: IconButton(
                    tooltip: 'Filter (coming soon)',
                    onPressed: () {
                      SnackBarHelper.info(
                        context,
                        'Filters will be available in a later phase.',
                      );
                    },
                    icon: const Icon(Icons.filter_list_rounded),
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: customersAsync.when(
              loading: () => const Center(child: LoadingIndicator()),
              error: (error, _) => AppErrorWidget(
                message: error.toString(),
                onRetry: () => ref.invalidate(activeCustomersStreamProvider),
              ),
              data: (customers) {
                if (customers.isEmpty) {
                  final String query = ref.watch(customerSearchQueryProvider);
                  if (query.trim().isNotEmpty) {
                    return const EmptyState(
                      title: 'No matches found',
                      message: 'Try a different name, phone, or city.',
                      icon: Icons.search_off_rounded,
                    );
                  }
                  return EmptyState(
                    title: StringConstants.noCustomersYet,
                    message: StringConstants.noCustomersSubtitle,
                    icon: Icons.people_outline_rounded,
                    actionLabel: StringConstants.addCustomer,
                    onAction: () => context.push(AppRoutes.addCustomer),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(activeCustomersStreamProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenPadding,
                      AppSpacing.sm,
                      AppSpacing.screenPadding,
                      AppSpacing.xxl,
                    ),
                    itemCount: customers.length,
                    itemBuilder: (context, index) {
                      final Customer customer = customers[index];
                      return Dismissible(
                        key: ValueKey(customer.id),
                        background: const _SwipeBackground(
                          alignment: Alignment.centerLeft,
                          color: AppColors.primary,
                          icon: Icons.edit_rounded,
                          label: StringConstants.editCustomer,
                        ),
                        secondaryBackground: const _SwipeBackground(
                          alignment: Alignment.centerRight,
                          color: AppColors.error,
                          icon: Icons.delete_outline_rounded,
                          label: StringConstants.delete,
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            context.push(
                              AppRoutes.editCustomerPath(customer.id),
                            );
                            return false;
                          }
                          await _archiveCustomer(context, ref, customer);
                          return false;
                        },
                        child: CustomerCard(
                          customer: customer,
                          onTap: () {
                            if (selectionMode) {
                              HapticFeedback.selectionClick();
                              return;
                            }
                            context.push(
                              AppRoutes.customerDetailPath(customer.id),
                            );
                          },
                          onLongPress: () {
                            HapticFeedback.mediumImpact();
                            ref
                                .read(customerSelectionModeProvider.notifier)
                                .state = true;
                            SnackBarHelper.info(
                              context,
                              'Selection mode enabled (multi-select coming soon)',
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SwipeBackground extends StatelessWidget {
  const _SwipeBackground({
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
        children: [
          if (alignment == Alignment.centerLeft) ...[
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white)),
          ] else ...[
            Text(label, style: const TextStyle(color: Colors.white)),
            const SizedBox(width: 8),
            Icon(icon, color: Colors.white),
          ],
        ],
      ),
    );
  }
}
