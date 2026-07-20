import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/string_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../domain/entities/inventory_item.dart';
import '../providers/inventory_providers.dart';

/// Form to add a part, oil, or service to the catalog.
class AddInventoryItemPage extends ConsumerStatefulWidget {
  const AddInventoryItemPage({super.key, required this.itemType});

  final InventoryItemType itemType;

  @override
  ConsumerState<AddInventoryItemPage> createState() =>
      _AddInventoryItemPageState();
}

class _AddInventoryItemPageState extends ConsumerState<AddInventoryItemPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _qtyController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _qtyController = TextEditingController(text: '0');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _qtyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final price = double.tryParse(_priceController.text.trim()) ?? 0;
    final qty = int.tryParse(_qtyController.text.trim()) ?? 0;

    final created = await ref
        .read(inventoryActionsProvider.notifier)
        .create(
          InventoryFormData(
            itemType: widget.itemType,
            name: _nameController.text,
            description: _descriptionController.text,
            price: price,
            quantityAvailable: qty,
          ),
        );

    if (!mounted) return;
    if (created == null) {
      final error = ref.read(inventoryActionsProvider).errorMessage;
      SnackBarHelper.error(
        context,
        error ?? StringConstants.somethingWentWrong,
      );
      return;
    }

    SnackBarHelper.success(
      context,
      '${widget.itemType.label} added successfully',
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(inventoryActionsProvider).isLoading;

    return Scaffold(
      appBar: CustomAppBar(title: 'Add ${widget.itemType.label}'),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: [
            Text(
              '${widget.itemType.label} Details',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.charcoal,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            CustomTextField(
              controller: _nameController,
              label: 'Name *',
              hint: 'Enter ${widget.itemType.label.toLowerCase()} name',
              prefixIcon: Icons.label_outline_rounded,
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.words,
              validator: Validators.required,
            ),
            const SizedBox(height: AppSpacing.lg),
            CustomTextField(
              controller: _descriptionController,
              label: 'Description',
              hint: 'Enter description',
              prefixIcon: Icons.notes_outlined,
              textInputAction: TextInputAction.next,
              maxLines: 3,
            ),
            const SizedBox(height: AppSpacing.lg),
            CustomTextField(
              controller: _priceController,
              label: 'Price *',
              hint: '0.00',
              prefixIcon: Icons.attach_money_rounded,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
              ],
              validator: (value) {
                final requiredError = Validators.required(value);
                if (requiredError != null) return requiredError;
                final parsed = double.tryParse(value!.trim());
                if (parsed == null || parsed < 0) {
                  return 'Enter a valid price';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.lg),
            CustomTextField(
              controller: _qtyController,
              label: 'Qty Available *',
              hint: '0',
              prefixIcon: Icons.inventory_2_outlined,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                final requiredError = Validators.required(value);
                if (requiredError != null) return requiredError;
                final parsed = int.tryParse(value!.trim());
                if (parsed == null || parsed < 0) {
                  return 'Enter a valid quantity';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.xxxl),
            PrimaryButton(
              label: 'Save ${widget.itemType.label}',
              onPressed: isLoading ? null : _submit,
              isLoading: isLoading,
              icon: Icons.save_rounded,
            ),
            const SizedBox(height: AppSpacing.md),
            SecondaryButton(
              label: StringConstants.cancel,
              onPressed: isLoading ? null : () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
