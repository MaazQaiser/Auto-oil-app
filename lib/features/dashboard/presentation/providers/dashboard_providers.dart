import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/providers/database_provider.dart';
import '../../data/datasources/dashboard_analytics_datasource.dart';
import '../../domain/entities/dashboard_models.dart';
import '../../../reminders/presentation/providers/reminder_providers.dart';

final dashboardAnalyticsDataSourceProvider =
    Provider<DashboardAnalyticsDataSource>((ref) {
  return DashboardAnalyticsDataSource(ref.watch(databaseProvider));
});

final dashboardPeriodProvider =
    StateProvider<DashboardPeriod>((ref) => DashboardPeriod.thisMonth);

final dashboardCustomRangeProvider = StateProvider<DateRange?>((ref) => null);

final dashboardSummaryProvider = FutureProvider<DashboardSummary>((ref) async {
  // Soft dependency so refresh after reminder/service changes.
  ref.watch(allRemindersStreamProvider);
  return ref.watch(dashboardAnalyticsDataSourceProvider).getSummary();
});

final revenueSummaryProvider = FutureProvider<RevenueSummary>((ref) async {
  final period = ref.watch(dashboardPeriodProvider);
  final custom = ref.watch(dashboardCustomRangeProvider);
  ref.watch(allRemindersStreamProvider);
  return ref.watch(dashboardAnalyticsDataSourceProvider).getRevenueSummary(
        period: period,
        customRange: custom,
      );
});

final dashboardDateRangeProvider = Provider<DateRange>((ref) {
  final period = ref.watch(dashboardPeriodProvider);
  final custom = ref.watch(dashboardCustomRangeProvider);
  return ref
      .watch(dashboardAnalyticsDataSourceProvider)
      .resolveRange(period, custom: custom);
});

final businessInsightsProvider = FutureProvider<BusinessInsights>((ref) async {
  ref.watch(allRemindersStreamProvider);
  return ref.watch(dashboardAnalyticsDataSourceProvider).getBusinessInsights();
});

final recentActivityProvider = FutureProvider<List<ActivityItem>>((ref) async {
  ref.watch(allRemindersStreamProvider);
  return ref
      .watch(dashboardAnalyticsDataSourceProvider)
      .getRecentActivity(limit: 15);
});

final globalSearchQueryProvider = StateProvider<String>((ref) => '');

final globalSearchResultsProvider =
    FutureProvider.autoDispose<List<GlobalSearchResult>>((ref) async {
  final query = ref.watch(globalSearchQueryProvider);
  if (query.trim().length < 2) return [];
  return ref.watch(dashboardAnalyticsDataSourceProvider).globalSearch(query);
});
