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
import '../../domain/entities/customer.dart';
import '../providers/customer_providers.dart';
import '../widgets/customer_card.dart';
import '../widgets/customer_search_bar.dart';

/// Lists soft-deleted (archived) customers with restore action.
class ArchivedCustomersPage extends ConsumerWidget {
  const ArchivedCustomersPage({super.key});

  Future<void> _restore(
    BuildContext context,
    WidgetRef ref,
    Customer customer,
  ) async {
    final bool? confirmed = await ConfirmationDialog.show(
      context,
      title: 'Restore customer?',
      message: 'Restore ${customer.fullName} to the active customers list?',
      confirmLabel: StringConstants.restoreCustomer,
    );
    if (confirmed != true) return;

    final bool success =
        await ref.read(customerActionsProvider.notifier).restore(customer.id);
    if (!context.mounted) return;
    if (success) {
      SnackBarHelper.success(context, StringConstants.customerRestored);
    } else {
      final String? error = ref.read(customerActionsProvider).errorMessage;
      SnackBarHelper.error(
        context,
        error ?? StringConstants.somethingWentWrong,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Customer>> customersAsync =
        ref.watch(filteredArchivedCustomersProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: StringConstants.archivedCustomers),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.md,
              AppSpacing.screenPadding,
              AppSpacing.sm,
            ),
            child: CustomerSearchBar(
              onChanged: (value) {
                ref.read(archivedCustomerSearchQueryProvider.notifier).state =
                    value;
              },
            ),
          ),
          Expanded(
            child: customersAsync.when(
              loading: () => const Center(child: LoadingIndicator()),
              error: (error, _) => AppErrorWidget(
                message: error.toString(),
                onRetry: () =>
                    ref.invalidate(archivedCustomersStreamProvider),
              ),
              data: (customers) {
                if (customers.isEmpty) {
                  return const EmptyState(
                    title: StringConstants.noArchivedCustomers,
                    message: 'Archived customers will appear here.',
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
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    final Customer customer = customers[index];
                    return Dismissible(
                      key: ValueKey('archived-${customer.id}'),
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
                              StringConstants.restoreCustomer,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      confirmDismiss: (_) async {
                        await _restore(context, ref, customer);
                        return false;
                      },
                      child: CustomerCard(
                        customer: customer,
                        onTap: () => context.push(
                          AppRoutes.customerDetailPath(customer.id),
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
