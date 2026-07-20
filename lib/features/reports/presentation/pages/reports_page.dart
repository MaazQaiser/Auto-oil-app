import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/search_field.dart';
import '../../../../core/widgets/section_title.dart';
import '../../../customers/presentation/providers/customer_providers.dart';
import '../../../invoices/data/debug/invoice_seed_data.dart';
import '../../../invoices/presentation/providers/invoice_providers.dart';
import '../../../invoices/presentation/widgets/invoice_widgets.dart';
import '../../../service_records/presentation/providers/service_record_providers.dart';
import '../../../settings/providers/settings_provider.dart';
import '../../../vehicles/presentation/providers/vehicle_providers.dart';
import '../../domain/entities/report_models.dart';
import '../providers/report_providers.dart';
import '../widgets/report_widgets.dart';

class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reportsAsync = ref.watch(businessReportsProvider);
    final currency = NumberFormat.currency(
      symbol: ref.watch(settingsServiceProvider).invoiceCurrencySymbol,
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Reports & Invoices',
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long_rounded),
            tooltip: 'Invoices',
            onPressed: () => context.push(AppRoutes.invoices),
          ),
          ExportButton(
            onCsv: () async {
              final data = reportsAsync.valueOrNull;
              if (data == null) return;
              await ref.read(exportServiceProvider).exportRevenueSummaryCsv(
                    today: data.revenue.today,
                    week: data.revenue.week,
                    month: data.revenue.month,
                    year: data.revenue.year,
                  );
            },
            onExcel: () async {
              final invoices =
                  await ref.read(invoiceRepositoryProvider).getRecent(limit: 500);
              await ref
                  .read(exportServiceProvider)
                  .exportInvoicesExcel(invoices);
            },
          ),
          if (kDebugMode)
            PopupMenuButton<String>(
              onSelected: (v) async {
                if (v == 'seed') {
                  final n = await InvoiceSeedData.seedInvoices(
                    customerRepository: ref.read(customerRepositoryProvider),
                    vehicleRepository: ref.read(vehicleRepositoryProvider),
                    serviceRecordRepository:
                        ref.read(serviceRecordRepositoryProvider),
                    invoiceRepository: ref.read(invoiceRepositoryProvider),
                    settings: ref.read(settingsServiceProvider),
                  );
                  if (!context.mounted) return;
                  SnackBarHelper.info(context, 'Seeded $n invoices');
                  ref.invalidate(allInvoicesStreamProvider);
                  ref.invalidate(businessReportsProvider);
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(
                  value: 'seed',
                  child: Text('Insert 500 demo invoices'),
                ),
              ],
            ),
        ],
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Revenue'),
            Tab(text: 'Customers'),
            Tab(text: 'Vehicles'),
            Tab(text: 'Services'),
            Tab(text: 'Reminders'),
            Tab(text: 'Financial'),
            Tab(text: 'Invoices'),
          ],
        ),
      ),
      body: reportsAsync.when(
        loading: () => const Center(child: LoadingIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (bundle) {
          return TabBarView(
            controller: _tabs,
            children: [
              _RevenueTab(report: bundle.revenue, currency: currency),
              _CustomerTab(report: bundle.customers, currency: currency),
              _VehicleTab(report: bundle.vehicles),
              _ServiceTab(report: bundle.services, currency: currency),
              _ReminderTab(report: bundle.reminders),
              _FinancialTab(report: bundle.financial, currency: currency),
              const _InvoicesTab(),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.invoices),
        icon: const Icon(Icons.add),
        label: const Text('Invoices'),
      ),
    );
  }
}

class _RevenueTab extends ConsumerWidget {
  const _RevenueTab({required this.report, required this.currency});

  final RevenueReport report;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(reportCustomRangeProvider);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: [
        ReportDateRangePickerButton(
          range: range,
          onPicked: (r) =>
              ref.read(reportCustomRangeProvider.notifier).state = r,
        ),
        const SizedBox(height: AppSpacing.md),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 1.6,
          children: [
            RevenueCard(label: "Today's Revenue", amount: currency.format(report.today)),
            RevenueCard(label: 'Weekly Revenue', amount: currency.format(report.week)),
            RevenueCard(label: 'Monthly Revenue', amount: currency.format(report.month)),
            RevenueCard(label: 'Yearly Revenue', amount: currency.format(report.year)),
            RevenueCard(
              label: 'Custom Range',
              amount: currency.format(report.customRange),
              color: AppColors.info,
            ),
            RevenueCard(
              label: 'Avg Invoice',
              amount: currency.format(report.averageInvoice),
              color: AppColors.secondary,
            ),
            RevenueCard(
              label: 'Highest Invoice',
              amount: currency.format(report.highestInvoice),
            ),
            RevenueCard(
              label: 'Lowest Invoice',
              amount: currency.format(report.lowestInvoice),
              color: AppColors.warning,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        ReportBarChart(
          title: 'Revenue Trend',
          points: report.monthlyTrend,
          color: AppColors.success,
        ),
      ],
    );
  }
}

class _CustomerTab extends StatelessWidget {
  const _CustomerTab({required this.report, required this.currency});

  final CustomerReport report;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 1.8,
          children: [
            MetricTile(label: 'Total Customers', value: '${report.total}'),
            MetricTile(label: 'Active', value: '${report.active}'),
            MetricTile(label: 'Inactive', value: '${report.inactive}'),
          ],
        ),
        const SectionTitle(title: 'Top Spending'),
        for (final t in report.topSpending)
          ListTile(
            title: Text(t.name),
            trailing: Text(currency.format(t.value)),
          ),
        const SectionTitle(title: 'Most Frequent'),
        for (final t in report.mostFrequent)
          ListTile(
            title: Text(t.name),
            trailing: Text('${t.count} services'),
          ),
        const SizedBox(height: AppSpacing.md),
        ReportBarChart(
          title: 'Customer Growth',
          points: report.growthTrend,
          color: AppColors.primary,
        ),
      ],
    );
  }
}

class _VehicleTab extends StatelessWidget {
  const _VehicleTab({required this.report});

  final VehicleReport report;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 1.8,
          children: [
            MetricTile(
              label: 'Average ODO',
              value: NumberFormat('#,###').format(report.averageOdo.round()),
            ),
            MetricTile(label: 'Vehicles Due', value: '${report.vehiclesDue}'),
            MetricTile(
              label: 'Overdue Vehicles',
              value: '${report.overdueVehicles}',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        ReportPieChart(
          title: 'Vehicle Brands',
          items: report.mostServicedBrands,
        ),
        const SizedBox(height: AppSpacing.md),
        const SectionTitle(title: 'Most Serviced Models'),
        for (final m in report.mostServicedModels)
          ListTile(title: Text(m.name), trailing: Text('${m.count}')),
      ],
    );
  }
}

class _ServiceTab extends StatelessWidget {
  const _ServiceTab({required this.report, required this.currency});

  final ServiceReport report;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 1.7,
          children: [
            MetricTile(label: 'Services Today', value: '${report.today}'),
            MetricTile(label: 'This Month', value: '${report.thisMonth}'),
            MetricTile(
              label: 'Most Used Oil',
              value: report.mostUsedOil ?? '—',
            ),
            MetricTile(
              label: 'Most Replaced Filter',
              value: report.mostReplacedFilter ?? '—',
            ),
            MetricTile(
              label: 'Avg Service Cost',
              value: currency.format(report.averageServiceCost),
            ),
            MetricTile(
              label: 'Avg Days Between',
              value: report.averageDaysBetweenServices.toStringAsFixed(0),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        ReportBarChart(
          title: 'Monthly Services',
          points: report.monthlyServices,
        ),
      ],
    );
  }
}

class _ReminderTab extends StatelessWidget {
  const _ReminderTab({required this.report});

  final ReminderReport report;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 1.8,
          children: [
            MetricTile(label: 'Upcoming', value: '${report.upcoming}'),
            MetricTile(label: 'Due', value: '${report.due}'),
            MetricTile(label: 'Overdue', value: '${report.overdue}'),
            MetricTile(label: 'Completed', value: '${report.completed}'),
            MetricTile(
              label: 'Completion Rate',
              value: '${report.completionRate.toStringAsFixed(1)}%',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        ReportPieChart(
          title: 'Reminder Status',
          items: report.statusDistribution,
        ),
      ],
    );
  }
}

class _FinancialTab extends StatelessWidget {
  const _FinancialTab({required this.report, required this.currency});

  final FinancialReport report;
  final NumberFormat currency;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 1.7,
          children: [
            RevenueCard(label: 'Revenue', amount: currency.format(report.revenue)),
            RevenueCard(
              label: 'Outstanding',
              amount: currency.format(report.outstanding),
              color: AppColors.warning,
            ),
            MetricTile(label: 'Paid Invoices', value: '${report.paidInvoices}'),
            MetricTile(
              label: 'Pending Invoices',
              value: '${report.pendingInvoices}',
            ),
            MetricTile(
              label: 'Average Profit',
              value: currency.format(report.averageProfit),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        ReportBarChart(
          title: 'Monthly Trend',
          points: report.monthlyTrend,
          color: AppColors.success,
        ),
        const SizedBox(height: AppSpacing.md),
        ReportPieChart(
          title: 'Payment Status',
          items: report.paymentStatusDistribution,
        ),
      ],
    );
  }
}

class _InvoicesTab extends ConsumerWidget {
  const _InvoicesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoicesAsync = ref.watch(filteredInvoicesProvider);
    final symbol = ref.watch(settingsServiceProvider).invoiceCurrencySymbol;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: SearchField(
            hint: 'Search invoice, customer, vehicle, registration…',
            onChanged: (v) =>
                ref.read(invoiceSearchQueryProvider.notifier).state = v,
          ),
        ),
        Expanded(
          child: invoicesAsync.when(
            loading: () => const Center(child: LoadingIndicator()),
            error: (e, _) => Center(child: Text(e.toString())),
            data: (list) {
              if (list.isEmpty) {
                return EmptyState(
                  title: 'No invoices yet',
                  message: 'Generate invoices from service records or seed demo data.',
                  actionLabel: 'Open Invoices',
                  onAction: () => context.push(AppRoutes.invoices),
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
    );
  }
}
