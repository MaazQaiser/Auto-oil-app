import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/string_constants.dart';
import '../../../../core/extensions/datetime_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../../../core/widgets/section_title.dart';
import '../../../invoices/presentation/providers/invoice_providers.dart';
import '../../../notifications/presentation/providers/notification_providers.dart';
import '../../../reminders/domain/entities/reminder_enums.dart';
import '../../../reminders/presentation/providers/reminder_providers.dart';
import '../../../vehicles/presentation/providers/vehicle_providers.dart';
import '../providers/service_record_providers.dart';

class AddServiceRecordPage extends ConsumerStatefulWidget {
  const AddServiceRecordPage({super.key, required this.vehicleId});

  final String vehicleId;

  @override
  ConsumerState<AddServiceRecordPage> createState() =>
      _AddServiceRecordPageState();
}

class _AddServiceRecordPageState extends ConsumerState<AddServiceRecordPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _typeController;
  late final TextEditingController _odoController;
  late final TextEditingController _oilController;
  late final TextEditingController _descController;
  late final TextEditingController _laborController;
  late final TextEditingController _partsController;
  late final TextEditingController _notesController;
  late final TextEditingController _nextOdoController;

  DateTime _serviceDate = DateTime.now();
  ReminderType _reminderType = ReminderType.both;
  DateTime? _nextDate;
  bool _reminderEnabled = true;
  bool _whatsappEnabled = false;

  @override
  void initState() {
    super.initState();
    _typeController = TextEditingController(text: 'Oil Change');
    _odoController = TextEditingController();
    _oilController = TextEditingController();
    _descController = TextEditingController();
    _laborController = TextEditingController(text: '0');
    _partsController = TextEditingController(text: '0');
    _notesController = TextEditingController();
    _nextOdoController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vehicleAsync = ref.read(vehicleByIdProvider(widget.vehicleId));
      vehicleAsync.whenData((v) {
        if (v != null && mounted) {
          _odoController.text = '${v.currentOdo}';
          _nextOdoController.text = '${v.currentOdo + 5000}';
          _nextDate = DateTime.now().add(const Duration(days: 90));
          setState(() {});
        }
      });
    });
  }

  @override
  void dispose() {
    _typeController.dispose();
    _odoController.dispose();
    _oilController.dispose();
    _descController.dispose();
    _laborController.dispose();
    _partsController.dispose();
    _notesController.dispose();
    _nextOdoController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({
    required DateTime current,
    required ValueChanged<DateTime> onPicked,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) onPicked(picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final labor = double.tryParse(_laborController.text.trim()) ?? 0;
    final parts = double.tryParse(_partsController.text.trim()) ?? 0;
    final nextOdoText = _nextOdoController.text.trim();

    final data = ServiceRecordFormData(
      vehicleId: widget.vehicleId,
      serviceDate: _serviceDate,
      odometerReading: int.parse(_odoController.text.trim()),
      serviceType: _typeController.text,
      description: _descController.text,
      oilBrand: _oilController.text,
      laborCost: labor,
      partsCost: parts,
      notes: _notesController.text,
      reminderType: _reminderType,
      nextServiceOdometer: nextOdoText.isEmpty ? null : int.tryParse(nextOdoText),
      nextServiceDate: _nextDate,
      reminderEnabled: _reminderEnabled,
      whatsappEnabled: _whatsappEnabled,
    );

    final created =
        await ref.read(serviceRecordActionsProvider.notifier).create(data);
    if (!mounted) return;
    if (created != null) {
      SnackBarHelper.success(context, 'Service record saved');
      ref.invalidate(vehicleByIdProvider(widget.vehicleId));
      ref.invalidate(activeReminderForVehicleProvider(widget.vehicleId));
      ref.invalidate(allRemindersStreamProvider);
      await ref.read(notificationManagerProvider).runReminderCheck();
      final invoice =
          await ref.read(createInvoiceFromServiceProvider)(created);
      if (!mounted) return;
      if (invoice != null) {
        SnackBarHelper.info(
          context,
          'Invoice ${invoice.invoiceNumber} created',
        );
        ref.invalidate(allInvoicesStreamProvider);
      }
      if (!mounted) return;
      context.pop();
    } else {
      SnackBarHelper.error(context, StringConstants.somethingWentWrong);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(serviceRecordActionsProvider).isLoading;

    return Scaffold(
      appBar: const CustomAppBar(title: StringConstants.addServiceRecord),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            CustomTextField(
              controller: _typeController,
              label: 'Service Type *',
              prefixIcon: Icons.build_outlined,
              validator: Validators.required,
            ),
            const SizedBox(height: AppSpacing.lg),
            InkWell(
              onTap: () => _pickDate(
                current: _serviceDate,
                onPicked: (d) => setState(() => _serviceDate = d),
              ),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Service Date *',
                  prefixIcon: Icon(Icons.event_outlined),
                ),
                child: Text(_serviceDate.formattedDate),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            CustomTextField(
              controller: _odoController,
              label: 'Odometer Reading *',
              prefixIcon: Icons.speed_rounded,
              keyboardType: TextInputType.number,
              validator: Validators.odometer,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: AppSpacing.lg),
            CustomTextField(
              controller: _oilController,
              label: 'Oil / Parts brand',
              hint: 'e.g. Chevron 5W30',
              prefixIcon: Icons.opacity_outlined,
            ),
            const SizedBox(height: AppSpacing.lg),
            CustomTextField(
              controller: _descController,
              label: 'Description',
              maxLines: 2,
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _laborController,
                    label: 'Labor cost',
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: CustomTextField(
                    controller: _partsController,
                    label: 'Parts cost',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            CustomTextField(
              controller: _notesController,
              label: StringConstants.notes,
              maxLines: 2,
            ),
            const SizedBox(height: AppSpacing.xxl),
            const SectionTitle(
              title: 'Next Maintenance',
              padding: EdgeInsets.only(bottom: AppSpacing.md),
            ),
            SwitchListTile(
              title: const Text('Enable Reminder'),
              value: _reminderEnabled,
              onChanged: (v) => setState(() => _reminderEnabled = v),
            ),
            SwitchListTile(
              title: const Text('Send WhatsApp Later'),
              subtitle: const Text('Messaging comes in a later phase'),
              value: _whatsappEnabled,
              onChanged: (v) => setState(() => _whatsappEnabled = v),
            ),
            if (_reminderEnabled) ...[
              const SizedBox(height: AppSpacing.md),
              Text('Reminder Type', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: AppSpacing.sm),
              SegmentedButton<ReminderType>(
                segments: const [
                  ButtonSegment(value: ReminderType.km, label: Text('KM')),
                  ButtonSegment(value: ReminderType.date, label: Text('Date')),
                  ButtonSegment(value: ReminderType.both, label: Text('Both')),
                ],
                selected: {_reminderType},
                onSelectionChanged: (s) =>
                    setState(() => _reminderType = s.first),
              ),
              if (_reminderType != ReminderType.date) ...[
                const SizedBox(height: AppSpacing.lg),
                CustomTextField(
                  controller: _nextOdoController,
                  label: 'Next ODO *',
                  prefixIcon: Icons.speed_outlined,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (_reminderType == ReminderType.date) return null;
                    return Validators.odometer(v);
                  },
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ],
              if (_reminderType != ReminderType.km) ...[
                const SizedBox(height: AppSpacing.lg),
                InkWell(
                  onTap: () => _pickDate(
                    current: _nextDate ?? DateTime.now(),
                    onPicked: (d) => setState(() => _nextDate = d),
                  ),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Next Service Date *',
                      prefixIcon: Icon(Icons.event_available_outlined),
                    ),
                    child: Text(
                      _nextDate?.formattedDate ?? 'Select date',
                    ),
                  ),
                ),
              ],
            ],
            const SizedBox(height: AppSpacing.xxxl),
            PrimaryButton(
              label: 'Save Service Record',
              icon: Icons.save_rounded,
              isLoading: isLoading,
              onPressed: isLoading ? null : _submit,
            ),
            const SizedBox(height: AppSpacing.md),
            SecondaryButton(
              label: StringConstants.cancel,
              onPressed: isLoading ? null : () => context.pop(),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
