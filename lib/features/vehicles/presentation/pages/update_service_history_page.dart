import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/string_constants.dart';
import '../../../../core/errors/widgets/app_error_widget.dart';
import '../../../../core/extensions/datetime_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../../reminders/domain/entities/maintenance_reminder.dart';
import '../../../reminders/domain/entities/reminder_enums.dart';
import '../../../reminders/presentation/providers/reminder_providers.dart';
import '../../../service_records/presentation/providers/service_record_providers.dart';
import '../../domain/entities/vehicle.dart';
import '../providers/vehicle_providers.dart';

/// Record an oil-change visit: update current/next ODO and archive past
/// service details into the vehicle maintenance log.
class UpdateServiceHistoryPage extends ConsumerStatefulWidget {
  const UpdateServiceHistoryPage({super.key, required this.vehicleId});

  final String vehicleId;

  @override
  ConsumerState<UpdateServiceHistoryPage> createState() =>
      _UpdateServiceHistoryPageState();
}

class _UpdateServiceHistoryPageState
    extends ConsumerState<UpdateServiceHistoryPage> {
  static const int _nextOdoOffset = 5000;

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _currentOdoController;
  late final TextEditingController _nextOdoController;
  late final TextEditingController _visitNotesController;
  DateTime _nextServiceDate = DateTime.now().add(const Duration(days: 90));
  bool _initialized = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _currentOdoController = TextEditingController();
    _nextOdoController = TextEditingController();
    _visitNotesController = TextEditingController();
    _currentOdoController.addListener(_autoFillNextOdo);
  }

  @override
  void dispose() {
    _currentOdoController.removeListener(_autoFillNextOdo);
    _currentOdoController.dispose();
    _nextOdoController.dispose();
    _visitNotesController.dispose();
    super.dispose();
  }

  void _autoFillNextOdo() {
    final current = int.tryParse(_currentOdoController.text.trim());
    if (current == null) return;
    final next = '${current + _nextOdoOffset}';
    if (_nextOdoController.text != next) {
      _nextOdoController.text = next;
    }
  }

  void _seedFromVehicle(Vehicle vehicle) {
    if (_initialized) return;
    _initialized = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _currentOdoController.text = '${vehicle.currentOdo}';
      _nextOdoController.text = '${vehicle.currentOdo + _nextOdoOffset}';
    });
  }

  Future<void> _pickNextDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _nextServiceDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() => _nextServiceDate = picked);
    }
  }

  String _pastServiceLogNote({
    required Vehicle vehicle,
    required MaintenanceReminder? previous,
    required int newCurrentOdo,
    required int newNextOdo,
  }) {
    final odoFmt = NumberFormat('#,###');
    final buffer = StringBuffer();
    buffer.writeln('Oil change service completed.');
    buffer.writeln(
      'Previous current ODO: ${odoFmt.format(vehicle.currentOdo)} KM',
    );
    if (previous?.nextServiceOdometer != null) {
      buffer.writeln(
        'Previous next service ODO: ${odoFmt.format(previous!.nextServiceOdometer!)} KM',
      );
    }
    if (previous?.nextServiceDate != null) {
      buffer.writeln(
        'Previous next service date: ${previous!.nextServiceDate!.formattedDate}',
      );
    }
    if (previous?.lastServiceDate != null) {
      buffer.writeln(
        'Last service before visit: ${previous!.lastServiceDate.formattedDate}',
      );
    }
    buffer.writeln(
      'Updated to current ODO: ${odoFmt.format(newCurrentOdo)} KM',
    );
    buffer.writeln(
      'New next service ODO: ${odoFmt.format(newNextOdo)} KM',
    );
    buffer.writeln('New next service date: ${_nextServiceDate.formattedDate}');
    final visitNote = _visitNotesController.text.trim();
    if (visitNote.isNotEmpty) {
      buffer.writeln('Visit note: $visitNote');
    }
    return buffer.toString().trim();
  }

  Future<void> _submit(Vehicle vehicle) async {
    if (!_formKey.currentState!.validate()) return;

    final currentOdo = int.parse(_currentOdoController.text.trim());
    final nextOdo = int.parse(_nextOdoController.text.trim());
    if (nextOdo <= currentOdo) {
      SnackBarHelper.warning(
        context,
        'Next service ODO must be greater than current reading',
      );
      return;
    }

    setState(() => _saving = true);

    try {
      final previous = await ref.read(
        activeReminderForVehicleProvider(widget.vehicleId).future,
      );

      final logNote = _pastServiceLogNote(
        vehicle: vehicle,
        previous: previous,
        newCurrentOdo: currentOdo,
        newNextOdo: nextOdo,
      );

      await ref.read(maintenanceLogActionsProvider.notifier).add(
        vehicleId: widget.vehicleId,
        note: logNote,
      );

      if (previous != null) {
        await ref
            .read(reminderActionsProvider.notifier)
            .markCompleted(previous.id);
      }

      final updatedVehicle = await ref
          .read(vehicleActionsProvider.notifier)
          .updateCurrentOdo(widget.vehicleId, currentOdo);
      if (updatedVehicle == null) {
        if (!mounted) return;
        final error = ref.read(vehicleActionsProvider).errorMessage;
        SnackBarHelper.error(
          context,
          error ?? StringConstants.somethingWentWrong,
        );
        return;
      }

      final record = await ref
          .read(serviceRecordActionsProvider.notifier)
          .create(
            ServiceRecordFormData(
              vehicleId: widget.vehicleId,
              serviceDate: DateTime.now(),
              odometerReading: currentOdo,
              serviceType: 'Oil Change',
              description: 'Customer visited for oil change service',
              notes: _visitNotesController.text.trim().isEmpty
                  ? null
                  : _visitNotesController.text.trim(),
              nextServiceOdometer: nextOdo,
              nextServiceDate: _nextServiceDate,
              reminderType: ReminderType.both,
              reminderEnabled: true,
            ),
          );

      if (!mounted) return;
      if (record == null) {
        SnackBarHelper.warning(
          context,
          'ODO updated and logged, but service record failed to save',
        );
        context.pop();
        return;
      }

      ref.invalidate(vehicleByIdProvider(widget.vehicleId));
      ref.invalidate(activeReminderForVehicleProvider(widget.vehicleId));
      ref.invalidate(maintenanceLogsByVehicleProvider(widget.vehicleId));
      ref.invalidate(allRemindersStreamProvider);
      ref.invalidate(serviceRecordsByVehicleProvider(widget.vehicleId));

      SnackBarHelper.success(
        context,
        'Service history updated — past details saved to maintenance log',
      );
      context.pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vehicleAsync = ref.watch(vehicleByIdProvider(widget.vehicleId));
    final reminderAsync = ref.watch(
      activeReminderForVehicleProvider(widget.vehicleId),
    );
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final muted = Theme.of(context).brightness == Brightness.dark
        ? AppColors.silver
        : AppColors.grey600;
    final odoFmt = NumberFormat('#,###');

    return Scaffold(
      appBar: const CustomAppBar(title: 'Update Service History'),
      body: vehicleAsync.when(
        loading: () => const Center(child: LoadingIndicator()),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          onRetry: () =>
              ref.invalidate(vehicleByIdProvider(widget.vehicleId)),
        ),
        data: (vehicle) {
          if (vehicle == null) {
            return const AppErrorWidget(message: 'Vehicle not found');
          }
          _seedFromVehicle(vehicle);

          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              children: [
                Text(
                  vehicle.displayName,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  vehicle.registrationNumber,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.gold,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Record this oil-change visit. Current and next readings are updated, and the previous service details move into the maintenance log.',
                  style: AppTextStyles.bodySmall.copyWith(color: muted),
                ),
                const SizedBox(height: AppSpacing.lg),
                reminderAsync.when(
                  data: (reminder) {
                    if (reminder == null) {
                      return Text(
                        'Current ODO on file: ${odoFmt.format(vehicle.currentOdo)} KM',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: muted,
                        ),
                      );
                    }
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.beige.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.grey300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Previous service (will move to log)',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: onSurface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            'Current ODO: ${odoFmt.format(vehicle.currentOdo)} KM',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: muted,
                            ),
                          ),
                          if (reminder.nextServiceOdometer != null)
                            Text(
                              'Next ODO was: ${odoFmt.format(reminder.nextServiceOdometer!)} KM',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: muted,
                              ),
                            ),
                          if (reminder.nextServiceDate != null)
                            Text(
                              'Next date was: ${reminder.nextServiceDate!.formattedDate}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: muted,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
                const SizedBox(height: AppSpacing.xxl),
                CustomTextField(
                  controller: _currentOdoController,
                  label: 'Current Odometer Reading (KM) *',
                  hint: 'Reading at this visit',
                  prefixIcon: Icons.speed_rounded,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: Validators.odometer,
                ),
                const SizedBox(height: AppSpacing.lg),
                CustomTextField(
                  controller: _nextOdoController,
                  label: 'Next Service Odometer (KM) *',
                  hint: 'Auto-filled (+5000)',
                  prefixIcon: Icons.speed_outlined,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: Validators.odometer,
                ),
                const SizedBox(height: AppSpacing.lg),
                InkWell(
                  onTap: _pickNextDate,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Next Service Date *',
                      prefixIcon: const Icon(Icons.event_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _nextServiceDate.formattedDate,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: onSurface,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                CustomTextField(
                  controller: _visitNotesController,
                  label: 'Visit Notes (optional)',
                  hint: 'e.g. Oil filter replaced, 5W-30 used',
                  prefixIcon: Icons.notes_outlined,
                  maxLines: 3,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: AppSpacing.xxxl),
                PrimaryButton(
                  label: 'Save Service Visit',
                  icon: Icons.build_circle_outlined,
                  isLoading: _saving,
                  onPressed: _saving ? null : () => _submit(vehicle),
                ),
                const SizedBox(height: AppSpacing.md),
                SecondaryButton(
                  label: StringConstants.cancel,
                  onPressed: _saving ? null : () => context.pop(),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          );
        },
      ),
    );
  }
}
