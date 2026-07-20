import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:printing/printing.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/search_field.dart';
import '../../../reports/presentation/providers/report_providers.dart';
import '../../../reports/presentation/widgets/report_widgets.dart';
import '../../../settings/providers/settings_provider.dart';
import '../../domain/entities/invoice_enums.dart';
import '../providers/invoice_providers.dart';
import '../widgets/invoice_widgets.dart';

class InvoicesPage extends ConsumerWidget {
  const InvoicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoicesAsync = ref.watch(filteredInvoicesProvider);
    final status = ref.watch(invoiceStatusFilterProvider);
    final symbol = ref.watch(settingsServiceProvider).invoiceCurrencySymbol;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Invoices',
        actions: [
          ExportButton(
            onCsv: () async {
              final list = invoicesAsync.valueOrNull ?? [];
              await ref.read(exportServiceProvider).exportInvoicesCsv(list);
            },
            onExcel: () async {
              final list = invoicesAsync.valueOrNull ?? [];
              await ref.read(exportServiceProvider).exportInvoicesExcel(list);
            },
          ),
          PopupMenuButton<PaymentStatus?>(
            icon: const Icon(Icons.filter_list_rounded),
            onSelected: (v) =>
                ref.read(invoiceStatusFilterProvider.notifier).state = v,
            itemBuilder: (_) => [
              const PopupMenuItem(value: null, child: Text('All statuses')),
              for (final s in PaymentStatus.values)
                PopupMenuItem(value: s, child: Text(s.label)),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              children: [
                SearchField(
                  hint: 'Invoice #, customer, vehicle, registration…',
                  onChanged: (v) =>
                      ref.read(invoiceSearchQueryProvider.notifier).state = v,
                ),
                if (status != null)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: InputChip(
                        label: Text(status.label),
                        onDeleted: () => ref
                            .read(invoiceStatusFilterProvider.notifier)
                            .state = null,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: invoicesAsync.when(
              loading: () => const Center(child: LoadingIndicator()),
              error: (e, _) => Center(child: Text(e.toString())),
              data: (list) {
                if (list.isEmpty) {
                  return const EmptyState(
                    title: 'No invoices',
                    message: 'Create an invoice from a service record.',
                    icon: Icons.receipt_long_outlined,
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final inv = list[index];
                    return InvoiceCard(
                      invoice: inv,
                      currencySymbol: symbol,
                      onTap: () =>
                          context.push(AppRoutes.invoiceDetailPath(inv.id)),
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

class InvoiceDetailPage extends ConsumerWidget {
  const InvoiceDetailPage({super.key, required this.invoiceId});

  final String invoiceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoiceAsync = ref.watch(invoiceByIdProvider(invoiceId));
    final settings = ref.watch(settingsServiceProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Invoice Detail'),
      body: invoiceAsync.when(
        loading: () => const Center(child: LoadingIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (invoice) {
          if (invoice == null) {
            return const Center(child: Text('Invoice not found'));
          }

          Future<void> shareOrPrint({required bool printDoc}) async {
            final bytes = await ref.read(invoicePdfServiceProvider).buildPdf(
                  invoice: invoice,
                  workshop: ref.read(invoiceActionsProvider.notifier).workshopInfo(),
                );
            if (printDoc) {
              await Printing.layoutPdf(onLayout: (_) async => bytes);
            } else {
              await Printing.sharePdf(
                bytes: bytes,
                filename: '${invoice.invoiceNumber}.pdf',
              );
            }
          }

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            children: [
              InvoiceCard(
                invoice: invoice,
                currencySymbol: settings.invoiceCurrencySymbol,
              ),
              const SizedBox(height: AppSpacing.md),
              InvoiceSummary(
                subtotal: invoice.subtotal,
                discount: invoice.discount,
                tax: invoice.tax,
                grandTotal: invoice.grandTotal,
                currencySymbol: settings.invoiceCurrencySymbol,
              ),
              const SizedBox(height: AppSpacing.lg),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: () => shareOrPrint(printDoc: true),
                    icon: const Icon(Icons.print_rounded),
                    label: const Text('Print'),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => shareOrPrint(printDoc: false),
                    icon: const Icon(Icons.share_rounded),
                    label: const Text('Share PDF'),
                  ),
                  if (invoice.paymentStatus != PaymentStatus.paid)
                    FilledButton.tonalIcon(
                      onPressed: () async {
                        final ok = await ref
                            .read(invoiceActionsProvider.notifier)
                            .markPaid(invoice);
                        if (!context.mounted) return;
                        if (ok) {
                          SnackBarHelper.success(context, 'Marked as paid');
                          ref.invalidate(invoiceByIdProvider(invoiceId));
                        }
                      },
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Mark Paid'),
                    ),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final method = await showDialog<PaymentMethod>(
                        context: context,
                        builder: (ctx) => SimpleDialog(
                          title: const Text('Payment Method'),
                          children: [
                            for (final m in PaymentMethod.values)
                              SimpleDialogOption(
                                onPressed: () => Navigator.pop(ctx, m),
                                child: Text(m.label),
                              ),
                          ],
                        ),
                      );
                      if (method == null) return;
                      await ref.read(invoiceActionsProvider.notifier).updateInvoice(
                            invoice.copyWith(paymentMethod: method),
                          );
                      ref.invalidate(invoiceByIdProvider(invoiceId));
                    },
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit Payment'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
