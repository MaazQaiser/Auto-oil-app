import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/dashboard_models.dart';
import 'dashboard_widgets.dart';

class MonthlyBarChart extends StatelessWidget {
  const MonthlyBarChart({
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
      return ChartCard(
        title: title,
        child: const Center(child: Text('No data')),
      );
    }
    final double maxY = points
        .map((e) => e.value)
        .fold<double>(0, (a, b) => a > b ? a : b);
    final double chartMax = maxY <= 0 ? 1 : maxY * 1.2;

    return ChartCard(
      title: title,
      child: BarChart(
        BarChartData(
          maxY: chartMax,
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
                  final int i = value.toInt();
                  if (i < 0 || i >= points.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      points[i].label,
                      style: AppTextStyles.labelSmall,
                    ),
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

class DistributionPieChart extends StatelessWidget {
  const DistributionPieChart({
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
    AppColors.grey500,
    AppColors.primaryLight,
  ];

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return ChartCard(
        title: title,
        child: const Center(child: Text('No data yet')),
      );
    }
    final int total = items.fold<int>(0, (a, b) => a + b.count);

    return ChartCard(
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
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < items.length && i < 5; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _colors[i % _colors.length],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${items[i].name} (${items[i].count})',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.labelSmall,
                          ),
                        ),
                      ],
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
