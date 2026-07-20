import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/string_constants.dart';
import '../../../../core/errors/widgets/app_error_widget.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../domain/entities/customer.dart';
import '../providers/customer_providers.dart';
import '../widgets/customer_form.dart';

/// Screen for editing an existing customer.
class EditCustomerPage extends ConsumerWidget {
  const EditCustomerPage({super.key, required this.customerId});

  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Customer?> customerAsync =
        ref.watch(customerByIdProvider(customerId));
    final CustomerActionState actionState = ref.watch(customerActionsProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: StringConstants.editCustomer),
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
          return CustomerForm(
            initialCustomer: customer,
            isLoading: actionState.isLoading,
            onCancel: () => context.pop(),
            onSubmit: (data) async {
              final updated = await ref
                  .read(customerActionsProvider.notifier)
                  .update(customerId, data);
              if (!context.mounted) return;
              if (updated != null) {
                ref.invalidate(customerByIdProvider(customerId));
                SnackBarHelper.success(
                  context,
                  StringConstants.customerUpdated,
                );
                context.pop();
              } else {
                final String? error =
                    ref.read(customerActionsProvider).errorMessage;
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
