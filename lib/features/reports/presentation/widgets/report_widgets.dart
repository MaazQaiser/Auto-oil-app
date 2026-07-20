import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../domain/entities/report_models.dart';

class ChartContainer extends StatelessWidget {
  const ChartContainer({
    super.key,
    required this.title,
    required this.child,
    this.height = 200,
  });

  final String title;
  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.titleSmall),
          const SizedBox(height: AppSpacing.md),
          SizedBox(height: height, child: child),
        ],
      ),
    );
  }
}

class RevenueCard extends StatelessWidget {
  const RevenueCard({
    super.key,
    required this.label,
    required this.amount,
    this.color = AppColors.success,
  });

  final String label;
  final String amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey600),
          ),
          const SizedBox(height: 6),
          Text(
            amount,
            style: AppTextStyles.titleMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class ExportButton extends StatelessWidget {
  const ExportButton({
    super.key,
    required this.onCsv,
    required this.onExcel,
    this.onPdf,
  });

  final VoidCallback onCsv;
  final VoidCallback onExcel;
  final VoidCallback? onPdf;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Export',
      icon: const Icon(Icons.ios_share_rounded),
      onSelected: (v) {
        switch (v) {
          case 'csv':
            onCsv();
          case 'excel':
            onExcel();
          case 'pdf':
            onPdf?.call();
        }
      },
      itemBuilder: (_) => [
        const PopupMenuItem(value: 'csv', child: Text('Export CSV')),
        const PopupMenuItem(value: 'excel', child: Text('Export Excel')),
        if (onPdf != null)
          const PopupMenuItem(value: 'pdf', child: Text('Export PDF')),
      ],
    );
  }
}

class ReportDateRangePickerButton extends StatelessWidget {
  const ReportDateRangePickerButton({
    super.key,
    required this.range,
    required this.onPicked,
  });

  final ReportDateRange? range;
  final ValueChanged<ReportDateRange> onPicked;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () async {
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 1)),
          initialDateRange: range == null
              ? null
              : DateTimeRange(start: range!.start, end: range!.end),
        );
        if (picked == null) return;
        onPicked(
          ReportDateRange(
            start: DateTime(
              picked.start.year,
              picked.start.month,
              picked.start.day,
            ),
            end: DateTime(
              picked.end.year,
              picked.end.month,
              picked.end.day,
            ).add(const Duration(days: 1)),
          ),
        );
      },
      icon: const Icon(Icons.date_range_rounded),
      label: Text(
        range == null ? 'Custom Range' : 'Range selected',
      ),
    );
  }
}

class ReportBarChart extends StatelessWidget {
  const ReportBarChart({
    super.key,
    required this.title,
    required this.points,
    this.color = AppColors.primary,
  });

  final String title;
  final List<MonthlyPoint> points;
  final Color color;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return ChartContainer(
        title: title,
        child: const Center(child: Text('No data')),
      );
    }
    final maxY = points
        .map((e) => e.value)
        .fold<double>(0, (a, b) => a > b ? a : b);
    return ChartContainer(
      title: title,
      child: BarChart(
        BarChartData(
          maxY: maxY <= 0 ? 1 : maxY * 1.2,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= points.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(points[i].label, style: AppTextStyles.labelSmall),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (int i = 0; i < points.length; i++)
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: points[i].value,
                    color: color,
                    width: 14,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class ReportPieChart extends StatelessWidget {
  const ReportPieChart({
    super.key,
    required this.title,
    required this.items,
  });

  final String title;
  final List<NamedCount> items;

  static const _colors = [
    AppColors.primary,
    AppColors.secondary,
    AppColors.success,
    AppColors.warning,
    AppColors.error,
    AppColors.info,
  ];

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return ChartContainer(
        title: title,
        child: const Center(child: Text('No data')),
      );
    }
    final total = items.fold<int>(0, (a, b) => a + b.count);
    return ChartContainer(
      title: title,
      child: Row(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 28,
                sections: [
                  for (int i = 0; i < items.length; i++)
                    PieChartSectionData(
                      value: items[i].count.toDouble(),
                      color: _colors[i % _colors.length],
                      radius: 36,
                      title: total == 0
                          ? ''
                          : '${((items[i].count / total) * 100).round()}%',
                      titleStyle: AppTextStyles.labelSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < items.length && i < 5; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      '${items[i].name} (${items[i].count})',
                      style: AppTextStyles.labelSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MetricTile extends StatelessWidget {
  const MetricTile({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.grey500),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
