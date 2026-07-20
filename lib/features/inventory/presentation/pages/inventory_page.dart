import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/string_constants.dart';
import '../../../../core/errors/widgets/app_error_widget.dart';
import '../../../../core/router/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../domain/entities/inventory_item.dart';
import '../providers/inventory_providers.dart';

/// Catalog of parts, oils, and services.
class InventoryPage extends ConsumerWidget {
  const InventoryPage({super.key});

  Future<void> _showAddPicker(BuildContext context) async {
    final type = await showModalBottomSheet<InventoryItemType>(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.grey300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Add to Catalog',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.charcoal,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Choose what you want to add',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey600,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _AddTypeTile(
                  icon: Icons.settings_suggest_outlined,
                  label: 'Add Part',
                  subtitle: 'Filters, pads, belts, and more',
                  onTap: () => Navigator.pop(context, InventoryItemType.part),
                ),
                const SizedBox(height: AppSpacing.sm),
                _AddTypeTile(
                  icon: Icons.water_drop_outlined,
                  label: 'Add Oil',
                  subtitle: 'Engine oils and lubricants',
                  onTap: () => Navigator.pop(context, InventoryItemType.oil),
                ),
                const SizedBox(height: AppSpacing.sm),
                _AddTypeTile(
                  icon: Icons.build_circle_outlined,
                  label: 'Add Service',
                  subtitle: 'Labour and service packages',
                  onTap: () =>
                      Navigator.pop(context, InventoryItemType.service),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (type == null || !context.mounted) return;
    context.push(AppRoutes.addInventoryItemPath(type.storageValue));
  }

  Future<void> _archiveItem(
    BuildContext context,
    WidgetRef ref,
    InventoryItem item,
  ) async {
    final confirmed = await ConfirmationDialog.show(
      context,
      title: 'Remove item?',
      message: '“${item.name}” will be removed from the catalog.',
      confirmLabel: 'Remove',
      isDestructive: true,
    );
    if (confirmed != true) return;

    final success = await ref
        .read(inventoryActionsProvider.notifier)
        .archive(item.id);
    if (!context.mounted) return;
    if (success) {
      SnackBarHelper.success(context, '${item.itemType.label} removed');
    } else {
      final error = ref.read(inventoryActionsProvider).errorMessage;
      SnackBarHelper.error(
        context,
        error ?? StringConstants.somethingWentWrong,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(filteredInventoryProvider);
    final typeFilter = ref.watch(inventoryTypeFilterProvider);
    final currency = NumberFormat.currency(symbol: 'Rs ', decimalDigits: 0);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Parts & Services'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddPicker(context),
        backgroundColor: AppColors.charcoal,
        foregroundColor: AppColors.gold,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.md,
              AppSpacing.screenPadding,
              AppSpacing.sm,
            ),
            child: TextField(
              onChanged: (value) {
                ref.read(inventorySearchQueryProvider.notifier).state = value;
              },
              decoration: InputDecoration(
                hintText: 'Search parts, oils, services',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: AppColors.beige,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  selected: typeFilter == null,
                  onSelected: () {
                    ref.read(inventoryTypeFilterProvider.notifier).state = null;
                  },
                ),
                const SizedBox(width: AppSpacing.sm),
                _FilterChip(
                  label: 'Parts',
                  selected: typeFilter == InventoryItemType.part,
                  onSelected: () {
                    ref.read(inventoryTypeFilterProvider.notifier).state =
                        InventoryItemType.part;
                  },
                ),
                const SizedBox(width: AppSpacing.sm),
                _FilterChip(
                  label: 'Oil',
                  selected: typeFilter == InventoryItemType.oil,
                  onSelected: () {
                    ref.read(inventoryTypeFilterProvider.notifier).state =
                        InventoryItemType.oil;
                  },
                ),
                const SizedBox(width: AppSpacing.sm),
                _FilterChip(
                  label: 'Services',
                  selected: typeFilter == InventoryItemType.service,
                  onSelected: () {
                    ref.read(inventoryTypeFilterProvider.notifier).state =
                        InventoryItemType.service;
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: itemsAsync.when(
              loading: () => const LoadingIndicator(),
              error: (error, _) => AppErrorWidget(
                message: error.toString(),
                onRetry: () => ref.invalidate(activeInventoryStreamProvider),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return EmptyState(
                    icon: Icons.inventory_2_outlined,
                    title: 'No items yet',
                    message: 'Tap Add to create a part, oil, or service.',
                    actionLabel: 'Add',
                    onAction: () => _showAddPicker(context),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPadding,
                    AppSpacing.sm,
                    AppSpacing.screenPadding,
                    100,
                  ),
                  itemCount: items.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Dismissible(
                      key: ValueKey(item.id),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (_) async {
                        await _archiveItem(context, ref, item);
                        return false;
                      },
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.delete_outline_rounded,
                          color: AppColors.error,
                        ),
                      ),
                      child: _InventoryCard(
                        item: item,
                        priceLabel: currency.format(item.price),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AddTypeTile extends StatelessWidget {
  const _AddTypeTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.beige,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.charcoal,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.gold),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.charcoal,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.grey500),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: AppColors.charcoal,
      labelStyle: AppTextStyles.labelMedium.copyWith(
        color: selected ? AppColors.white : AppColors.charcoal,
      ),
      backgroundColor: AppColors.beige,
      side: BorderSide.none,
      showCheckmark: false,
    );
  }
}

class _InventoryCard extends StatelessWidget {
  const _InventoryCard({required this.item, required this.priceLabel});

  final InventoryItem item;
  final String priceLabel;

  IconData get _icon {
    switch (item.itemType) {
      case InventoryItemType.part:
        return Icons.settings_suggest_outlined;
      case InventoryItemType.oil:
        return Icons.water_drop_outlined;
      case InventoryItemType.service:
        return Icons.build_circle_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.beige,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_icon, color: AppColors.gold),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColors.charcoal,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.charcoal,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.itemType.label,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (item.description != null &&
                    item.description!.trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Text(
                      priceLabel,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.charcoal,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Qty: ${item.quantityAvailable}',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.grey700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
