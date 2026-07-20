import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/string_constants.dart';
import '../../../../core/extensions/datetime_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../../customers/domain/entities/customer.dart';
import '../../../customers/presentation/providers/customer_providers.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/entities/vehicle_enums.dart';
import '../providers/vehicle_providers.dart';

/// Shared create / edit vehicle form.
class VehicleForm extends ConsumerStatefulWidget {
  const VehicleForm({
    super.key,
    this.initialVehicle,
    this.fixedCustomerId,
    required this.onSubmit,
    required this.onCancel,
    this.isLoading = false,
  });

  final Vehicle? initialVehicle;
  final String? fixedCustomerId;
  final Future<void> Function(VehicleFormData data) onSubmit;
  final VoidCallback onCancel;
  final bool isLoading;

  @override
  ConsumerState<VehicleForm> createState() => _VehicleFormState();
}

class _VehicleFormState extends ConsumerState<VehicleForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _makeController;
  late final TextEditingController _modelController;
  late final TextEditingController _variantController;
  late final TextEditingController _yearController;
  late final TextEditingController _registrationController;
  late final TextEditingController _vinController;
  late final TextEditingController _engineNumberController;
  late final TextEditingController _engineCapacityController;
  late final TextEditingController _colorController;
  late final TextEditingController _odoController;
  late final TextEditingController _notesController;

  String? _customerId;
  FuelType _fuelType = FuelType.petrol;
  TransmissionType _transmission = TransmissionType.automatic;
  DateTime? _purchaseDate;
  DateTime? _insuranceExpiry;
  DateTime? _registrationExpiry;

  @override
  void initState() {
    super.initState();
    final Vehicle? v = widget.initialVehicle;
    _customerId = v?.customerId ?? widget.fixedCustomerId;
    _makeController = TextEditingController(text: v?.make ?? '');
    _modelController = TextEditingController(text: v?.model ?? '');
    _variantController = TextEditingController(text: v?.variant ?? '');
    _yearController =
        TextEditingController(text: v?.year?.toString() ?? '');
    _registrationController =
        TextEditingController(text: v?.registrationNumber ?? '');
    _vinController = TextEditingController(text: v?.vinNumber ?? '');
    _engineNumberController =
        TextEditingController(text: v?.engineNumber ?? '');
    _engineCapacityController =
        TextEditingController(text: v?.engineCapacity ?? '');
    _colorController = TextEditingController(text: v?.color ?? '');
    _odoController =
        TextEditingController(text: v?.currentOdo.toString() ?? '');
    _notesController = TextEditingController(text: v?.notes ?? '');
    if (v != null) {
      _fuelType = v.fuelType;
      _transmission = v.transmission;
      _purchaseDate = v.purchaseDate;
      _insuranceExpiry = v.insuranceExpiry;
      _registrationExpiry = v.registrationExpiry;
    }
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _variantController.dispose();
    _yearController.dispose();
    _registrationController.dispose();
    _vinController.dispose();
    _engineNumberController.dispose();
    _engineCapacityController.dispose();
    _colorController.dispose();
    _odoController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({
    required DateTime? current,
    required ValueChanged<DateTime?> onPicked,
  }) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: current ?? now,
      firstDate: DateTime(1950),
      lastDate: DateTime(now.year + 15),
    );
    if (picked != null) onPicked(picked);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_customerId == null || _customerId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an owner')),
      );
      return;
    }

    final String yearText = _yearController.text.trim();
    final VehicleFormData data = VehicleFormData(
      customerId: _customerId!,
      make: _makeController.text,
      model: _modelController.text,
      variant: _variantController.text,
      year: yearText.isEmpty ? null : int.tryParse(yearText),
      registrationNumber: _registrationController.text,
      vinNumber: _vinController.text,
      engineNumber: _engineNumberController.text,
      engineCapacity: _engineCapacityController.text,
      fuelType: _fuelType,
      transmission: _transmission,
      color: _colorController.text,
      currentOdo: int.parse(_odoController.text.trim().replaceAll(',', '')),
      purchaseDate: _purchaseDate,
      insuranceExpiry: _insuranceExpiry,
      registrationExpiry: _registrationExpiry,
      notes: _notesController.text,
    );
    await widget.onSubmit(data);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Customer>> customersAsync =
        ref.watch(activeCustomersStreamProvider);
    final bool lockOwner =
        widget.fixedCustomerId != null || widget.initialVehicle != null;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          customersAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => const SizedBox.shrink(),
            data: (customers) {
              if (lockOwner && _customerId != null) {
                Customer? owner;
                for (final c in customers) {
                  if (c.id == _customerId) {
                    owner = c;
                    break;
                  }
                }
                return InputDecorator(
                  decoration: const InputDecoration(
                    labelText: StringConstants.owner,
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                  child: Text(
                    owner?.fullName ?? 'Selected customer',
                    style: AppTextStyles.bodyLarge,
                  ),
                );
              }
              return DropdownButtonFormField<String>(
                key: ValueKey('owner-$_customerId'),
                initialValue: _customerId,
                decoration: const InputDecoration(
                  labelText: '${StringConstants.selectOwner} *',
                  prefixIcon: Icon(Icons.person_outline_rounded),
                ),
                items: [
                  for (final customer in customers)
                    DropdownMenuItem(
                      value: customer.id,
                      child: Text(customer.fullName),
                    ),
                ],
                onChanged: (value) => setState(() => _customerId = value),
                validator: (value) =>
                    value == null ? StringConstants.fieldRequired : null,
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomTextField(
            controller: _makeController,
            label: '${StringConstants.make} *',
            prefixIcon: Icons.factory_outlined,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            validator: Validators.required,
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomTextField(
            controller: _modelController,
            label: '${StringConstants.model} *',
            prefixIcon: Icons.directions_car_outlined,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            validator: Validators.required,
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomTextField(
            controller: _variantController,
            label: StringConstants.variant,
            prefixIcon: Icons.tune_outlined,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomTextField(
            controller: _yearController,
            label: StringConstants.year,
            prefixIcon: Icons.calendar_today_outlined,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: Validators.year,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomTextField(
            controller: _registrationController,
            label: '${StringConstants.registrationNumber} *',
            prefixIcon: Icons.pin_outlined,
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.next,
            validator: Validators.required,
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomTextField(
            controller: _vinController,
            label: StringConstants.vinNumber,
            prefixIcon: Icons.qr_code_outlined,
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomTextField(
            controller: _engineNumberController,
            label: StringConstants.engineNumber,
            prefixIcon: Icons.settings_outlined,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomTextField(
            controller: _engineCapacityController,
            label: StringConstants.engineCapacity,
            hint: 'e.g. 1800cc',
            prefixIcon: Icons.speed_outlined,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.lg),
          DropdownButtonFormField<FuelType>(
            key: ValueKey(_fuelType),
            initialValue: _fuelType,
            decoration: const InputDecoration(
              labelText: StringConstants.fuelType,
              prefixIcon: Icon(Icons.local_gas_station_outlined),
            ),
            items: [
              for (final type in FuelType.values)
                DropdownMenuItem(value: type, child: Text(type.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _fuelType = value);
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          DropdownButtonFormField<TransmissionType>(
            key: ValueKey(_transmission),
            initialValue: _transmission,
            decoration: const InputDecoration(
              labelText: StringConstants.transmission,
              prefixIcon: Icon(Icons.settings_suggest_outlined),
            ),
            items: [
              for (final type in TransmissionType.values)
                DropdownMenuItem(value: type, child: Text(type.label)),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _transmission = value);
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomTextField(
            controller: _colorController,
            label: StringConstants.color,
            prefixIcon: Icons.palette_outlined,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomTextField(
            controller: _odoController,
            label: '${StringConstants.currentOdo} *',
            prefixIcon: Icons.speed_rounded,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            validator: Validators.odometer,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          const SizedBox(height: AppSpacing.lg),
          _DateField(
            label: StringConstants.purchaseDate,
            value: _purchaseDate,
            onTap: () => _pickDate(
              current: _purchaseDate,
              onPicked: (d) => setState(() => _purchaseDate = d),
            ),
            onClear: () => setState(() => _purchaseDate = null),
          ),
          const SizedBox(height: AppSpacing.lg),
          _DateField(
            label: StringConstants.insuranceExpiry,
            value: _insuranceExpiry,
            onTap: () => _pickDate(
              current: _insuranceExpiry,
              onPicked: (d) => setState(() => _insuranceExpiry = d),
            ),
            onClear: () => setState(() => _insuranceExpiry = null),
          ),
          const SizedBox(height: AppSpacing.lg),
          _DateField(
            label: StringConstants.registrationExpiry,
            value: _registrationExpiry,
            onTap: () => _pickDate(
              current: _registrationExpiry,
              onPicked: (d) => setState(() => _registrationExpiry = d),
            ),
            onClear: () => setState(() => _registrationExpiry = null),
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomTextField(
            controller: _notesController,
            label: StringConstants.notes,
            prefixIcon: Icons.notes_outlined,
            maxLines: 3,
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.xxl),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: AppRadius.lgAll,
              border: Border.all(color: AppColors.grey300),
            ),
            child: Column(
              children: [
                const Icon(Icons.add_a_photo_outlined,
                    size: 36, color: AppColors.grey500),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  StringConstants.vehiclePhoto,
                  style: AppTextStyles.titleSmall,
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Photo upload coming in a later phase',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xxxl),
          PrimaryButton(
            label: StringConstants.saveVehicle,
            icon: Icons.save_rounded,
            isLoading: widget.isLoading,
            onPressed: widget.isLoading ? null : _submit,
          ),
          const SizedBox(height: AppSpacing.md),
          SecondaryButton(
            label: StringConstants.cancel,
            onPressed: widget.isLoading ? null : widget.onCancel,
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
    required this.onClear,
  });

  final String label;
  final DateTime? value;
  final VoidCallback onTap;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mdAll,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.event_outlined),
          suffixIcon: value == null
              ? null
              : IconButton(
                  icon: const Icon(Icons.clear_rounded),
                  onPressed: onClear,
                ),
        ),
        child: Text(
          value?.formattedDate ?? 'Select date',
          style: AppTextStyles.bodyLarge.copyWith(
            color: value == null ? AppColors.grey500 : null,
          ),
        ),
      ),
    );
  }
}
