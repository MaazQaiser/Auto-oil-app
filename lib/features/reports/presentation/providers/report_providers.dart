import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/providers/database_provider.dart';
import '../../data/datasources/reports_analytics_datasource.dart';
import '../../domain/entities/report_models.dart';
import '../../domain/services/export_service.dart';

final reportsAnalyticsDataSourceProvider =
    Provider<ReportsAnalyticsDataSource>((ref) {
  return ReportsAnalyticsDataSource(ref.watch(databaseProvider));
});

final exportServiceProvider = Provider<ExportService>((ref) {
  return ExportService();
});

final reportCustomRangeProvider =
    StateProvider<ReportDateRange?>((ref) => null);

final businessReportsProvider =
    FutureProvider<BusinessReportsBundle>((ref) async {
  final custom = ref.watch(reportCustomRangeProvider);
  return ref.watch(reportsAnalyticsDataSourceProvider).loadAll(custom: custom);
});

final revenueReportProvider = FutureProvider<RevenueReport>((ref) async {
  final custom = ref.watch(reportCustomRangeProvider);
  return ref
      .watch(reportsAnalyticsDataSourceProvider)
      .getRevenueReport(custom: custom);
});
