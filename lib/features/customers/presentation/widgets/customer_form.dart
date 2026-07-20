import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/string_constants.dart';
import '../../../../core/extensions/datetime_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../domain/entities/customer.dart';
import '../providers/customer_providers.dart';

/// Shared create / edit customer form.
class CustomerForm extends StatefulWidget {
  const CustomerForm({
    super.key,
    this.initialCustomer,
    required this.onSubmit,
    required this.onCancel,
    this.isLoading = false,
    this.submitLabel = StringConstants.saveCustomer,
    this.includeVehicleSection = false,
  });

  final Customer? initialCustomer;
  final Future<void> Function(CustomerFormData data) onSubmit;
  final VoidCallback onCancel;
  final bool isLoading;
  final String submitLabel;
  final bool includeVehicleSection;

  @override
  State<CustomerForm> createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  static const int _nextServiceOdoOffset = 5000;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _whatsappController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _notesController;
  late final TextEditingController _vehicleNameController;
  late final TextEditingController _registrationController;
  late final TextEditingController _makeController;
  late final TextEditingController _modelController;
  late final TextEditingController _variantController;
  late final TextEditingController _recommendedOilController;
  late final TextEditingController _odometerController;
  late final TextEditingController _nextOdoController;
  DateTime? _nextServiceDate;

  @override
  void initState() {
    super.initState();
    final Customer? c = widget.initialCustomer;
    _fullNameController = TextEditingController(text: c?.fullName ?? '');
    _phoneController = TextEditingController(text: c?.phoneNumber ?? '');
    _whatsappController = TextEditingController(text: c?.whatsappNumber ?? '');
    _emailController = TextEditingController(text: c?.email ?? '');
    _addressController = TextEditingController(text: c?.address ?? '');
    _cityController = TextEditingController(text: c?.city ?? '');
    _notesController = TextEditingController(text: c?.notes ?? '');
    _vehicleNameController = TextEditingController();
    _registrationController = TextEditingController();
    _makeController = TextEditingController();
    _modelController = TextEditingController();
    _variantController = TextEditingController();
    _recommendedOilController = TextEditingController();
    _odometerController = TextEditingController();
    _nextOdoController = TextEditingController();
    if (widget.includeVehicleSection) {
      _nextServiceDate = DateTime.now().add(const Duration(days: 90));
      _odometerController.addListener(_autoFillNextOdo);
    }
  }

  @override
  void dispose() {
    if (widget.includeVehicleSection) {
      _odometerController.removeListener(_autoFillNextOdo);
    }
    _fullNameController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _notesController.dispose();
    _vehicleNameController.dispose();
    _registrationController.dispose();
    _makeController.dispose();
    _modelController.dispose();
    _variantController.dispose();
    _recommendedOilController.dispose();
    _odometerController.dispose();
    _nextOdoController.dispose();
    super.dispose();
  }

  void _autoFillNextOdo() {
    final current = int.tryParse(_odometerController.text.trim());
    if (current == null) {
      if (_nextOdoController.text.isNotEmpty) {
        _nextOdoController.text = '';
      }
      return;
    }
    final next = '${current + _nextServiceOdoOffset}';
    if (_nextOdoController.text != next) {
      _nextOdoController.text = next;
    }
  }

  String? _vehicleRequired(String? value) {
    if (!widget.includeVehicleSection) return null;
    return Validators.required(value);
  }

  Future<void> _pickNextServiceDate() async {
    final initial =
        _nextServiceDate ?? DateTime.now().add(const Duration(days: 90));
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() => _nextServiceDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (widget.includeVehicleSection && _nextServiceDate == null) {
      return;
    }

    final odoText = _odometerController.text.trim();
    final nextOdoText = _nextOdoController.text.trim();
    final CustomerFormData data = CustomerFormData(
      fullName: _fullNameController.text,
      phoneNumber: _phoneController.text,
      whatsappNumber: _whatsappController.text,
      email: _emailController.text,
      address: _addressController.text,
      city: _cityController.text,
      notes: _notesController.text,
      vehicleName: _vehicleNameController.text,
      registrationNumber: _registrationController.text,
      vehicleMake: _makeController.text,
      vehicleModel: _modelController.text,
      vehicleVariant: _variantController.text,
      recommendedOil: _recommendedOilController.text,
      odometerReading: odoText.isEmpty ? null : int.tryParse(odoText),
      nextServiceOdometer: nextOdoText.isEmpty
          ? null
          : int.tryParse(nextOdoText),
      nextServiceDate: _nextServiceDate,
    );
    await widget.onSubmit(data);
  }

  @override
  Widget build(BuildContext context) {
    final Color onSurface = Theme.of(context).colorScheme.onSurface;
    final Color muted = Theme.of(context).brightness == Brightness.dark
        ? AppColors.silver
        : AppColors.grey600;

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          Text(
            'Customer Details',
            style: AppTextStyles.titleMedium.copyWith(
              color: onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          CustomTextField(
            controller: _fullNameController,
            label: '${StringConstants.fullName} *',
            hint: 'Enter full name',
            prefixIcon: Icons.person_outline_rounded,
            textInputAction: TextInputAction.next,
            validator: Validators.required,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomTextField(
            controller: _phoneController,
            label: '${StringConstants.phoneNumber} *',
            hint: 'Enter phone number',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            validator: Validators.phone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d+\-\s()]')),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomTextField(
            controller: _whatsappController,
            label: StringConstants.whatsappNumber,
            hint: 'Enter WhatsApp number',
            prefixIcon: Icons.chat_outlined,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.next,
            validator: Validators.optionalPhone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d+\-\s()]')),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomTextField(
            controller: _emailController,
            label: StringConstants.email,
            hint: 'Enter email address',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: Validators.optionalEmail,
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomTextField(
            controller: _addressController,
            label: StringConstants.address,
            hint: 'Enter address',
            prefixIcon: Icons.home_outlined,
            textInputAction: TextInputAction.next,
            maxLines: 2,
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomTextField(
            controller: _cityController,
            label: StringConstants.city,
            hint: 'Enter city',
            prefixIcon: Icons.location_city_outlined,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomTextField(
            controller: _notesController,
            label: StringConstants.notes,
            hint: 'Additional notes',
            prefixIcon: Icons.notes_outlined,
            textInputAction: TextInputAction.next,
            maxLines: 4,
          ),
          if (widget.includeVehicleSection) ...[
            const SizedBox(height: AppSpacing.xxl),
            Text(
              'Vehicle Details',
              style: AppTextStyles.titleMedium.copyWith(
                color: onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Fill this to register the customer’s vehicle now.',
              style: AppTextStyles.bodySmall.copyWith(color: muted),
            ),
            const SizedBox(height: AppSpacing.md),
            CustomTextField(
              controller: _vehicleNameController,
              label: 'Vehicle Name *',
              hint: 'e.g. Family Car',
              prefixIcon: Icons.badge_outlined,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              validator: _vehicleRequired,
            ),
            const SizedBox(height: AppSpacing.lg),
            CustomTextField(
              controller: _registrationController,
              label: '${StringConstants.registrationNumber} *',
              hint: 'e.g. ABC-123',
              prefixIcon: Icons.pin_outlined,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.characters,
              validator: _vehicleRequired,
            ),
            const SizedBox(height: AppSpacing.lg),
            CustomTextField(
              controller: _makeController,
              label: '${StringConstants.make} *',
              hint: 'e.g. Toyota',
              prefixIcon: Icons.factory_outlined,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              validator: _vehicleRequired,
            ),
            const SizedBox(height: AppSpacing.lg),
            CustomTextField(
              controller: _modelController,
              label: '${StringConstants.model} *',
              hint: 'e.g. Corolla',
              prefixIcon: Icons.directions_car_outlined,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              validator: _vehicleRequired,
            ),
            const SizedBox(height: AppSpacing.lg),
            CustomTextField(
              controller: _variantController,
              label: StringConstants.variant,
              hint: 'e.g. Altis',
              prefixIcon: Icons.tune_outlined,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: AppSpacing.lg),
            CustomTextField(
              controller: _recommendedOilController,
              label: 'Recommended Oil',
              hint: 'e.g. 5W-30 Synthetic',
              prefixIcon: Icons.water_drop_outlined,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: AppSpacing.lg),
            CustomTextField(
              controller: _odometerController,
              label: 'Odometer Reading (KM) *',
              hint: 'e.g. 45200',
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
              onTap: _pickNextServiceDate,
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
                  _nextServiceDate?.formattedDate ?? 'Select date',
                  style: AppTextStyles.bodyLarge.copyWith(color: onSurface),
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xxxl),
          PrimaryButton(
            label: widget.submitLabel,
            onPressed: widget.isLoading ? null : _submit,
            isLoading: widget.isLoading,
            icon: Icons.save_rounded,
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
