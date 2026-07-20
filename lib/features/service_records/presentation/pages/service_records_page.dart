import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/string_constants.dart';
import '../../../../core/extensions/datetime_extensions.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/service_record_providers.dart';
import '../../domain/entities/service_record.dart';

class ServiceRecordsPage extends ConsumerWidget {
  const ServiceRecordsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CustomAppBar(title: StringConstants.serviceRecords),
      body: const EmptyState(
        title: 'Service Records',
        message:
            'Open a vehicle and tap Add Service Record to log maintenance.',
        icon: Icons.build_circle_outlined,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.vehicles),
        icon: const Icon(Icons.directions_car_outlined),
        label: const Text('Pick Vehicle'),
      ),
    );
  }
}

class VehicleServiceHistoryList extends ConsumerWidget {
  const VehicleServiceHistoryList({super.key, required this.vehicleId});

  final String vehicleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(serviceRecordsByVehicleProvider(vehicleId));
    final currency = NumberFormat.simpleCurrency();

    return async.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Center(child: LoadingIndicator()),
      ),
      error: (e, _) => Text(e.toString()),
      data: (List<ServiceRecord> records) {
        if (records.isEmpty) {
          return AppCard(
            child: Column(
              children: [
                Text(
                  StringConstants.noServiceHistory,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grey600,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton.icon(
                  onPressed: () => context.push(
                    AppRoutes.addServiceRecordPath(vehicleId),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text(StringConstants.addServiceRecord),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            for (final r in records)
              AppCard(
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.serviceType, style: AppTextStyles.titleSmall),
                    const SizedBox(height: 4),
                    Text(
                      '${r.serviceDate.formattedDate} · ${NumberFormat('#,###').format(r.odometerReading)} KM',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.grey600,
                      ),
                    ),
                    if (r.oilBrand != null && r.oilBrand!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(r.oilBrand!, style: AppTextStyles.labelSmall),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      currency.format(r.totalCost),
                      style: AppTextStyles.titleSmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => context.push(
                  AppRoutes.addServiceRecordPath(vehicleId),
                ),
                icon: const Icon(Icons.add),
                label: const Text(StringConstants.addServiceRecord),
              ),
            ),
          ],
        );
      },
    );
  }
}
