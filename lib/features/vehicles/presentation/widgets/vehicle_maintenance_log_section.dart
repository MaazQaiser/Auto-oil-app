import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/extensions/datetime_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/section_title.dart';
import '../../domain/entities/maintenance_log.dart';
import '../providers/vehicle_providers.dart';

/// Maintenance log notes for a vehicle — list + add note.
class VehicleMaintenanceLogSection extends ConsumerStatefulWidget {
  const VehicleMaintenanceLogSection({
    super.key,
    required this.vehicleId,
    this.readOnly = false,
  });

  final String vehicleId;
  final bool readOnly;

  @override
  ConsumerState<VehicleMaintenanceLogSection> createState() =>
      _VehicleMaintenanceLogSectionState();
}

class _VehicleMaintenanceLogSectionState
    extends ConsumerState<VehicleMaintenanceLogSection> {
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _addNote() async {
    final text = _noteController.text.trim();
    if (text.isEmpty) {
      SnackBarHelper.warning(context, 'Enter a maintenance note');
      return;
    }

    final created = await ref.read(maintenanceLogActionsProvider.notifier).add(
      vehicleId: widget.vehicleId,
      note: text,
    );
    if (!mounted) return;
    if (created == null) {
      final error = ref.read(maintenanceLogActionsProvider).errorMessage;
      SnackBarHelper.error(context, error ?? 'Could not save note');
      return;
    }
    _noteController.clear();
    SnackBarHelper.success(context, 'Note added');
  }

  Future<void> _deleteNote(MaintenanceLog log) async {
    final success =
        await ref.read(maintenanceLogActionsProvider.notifier).delete(log.id);
    if (!mounted) return;
    if (success) {
      SnackBarHelper.success(context, 'Note removed');
    } else {
      final error = ref.read(maintenanceLogActionsProvider).errorMessage;
      SnackBarHelper.error(context, error ?? 'Could not remove note');
    }
  }

  @override
  Widget build(BuildContext context) {
    final logsAsync = ref.watch(
      maintenanceLogsByVehicleProvider(widget.vehicleId),
    );
    final isSaving = ref.watch(
      maintenanceLogActionsProvider.select((s) => s.isLoading),
    );
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final muted = Theme.of(context).brightness == Brightness.dark
        ? AppColors.silver
        : AppColors.grey600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionTitle(
          title: 'Maintenance Log',
          trailing: widget.readOnly
              ? null
              : TextButton.icon(
                  onPressed: isSaving ? null : _addNote,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Add Note'),
                ),
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
        ),
        if (!widget.readOnly) ...[
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _noteController,
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Add a maintenance note…',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.edit_note_rounded),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton.icon(
                    onPressed: isSaving ? null : _addNote,
                    icon: isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_rounded, size: 18),
                    label: Text(isSaving ? 'Saving…' : 'Save Note'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        logsAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: Center(child: LoadingIndicator()),
          ),
          error: (error, _) => Text(
            error.toString(),
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
          ),
          data: (logs) {
            if (logs.isEmpty) {
              return const EmptyState(
                icon: Icons.note_alt_outlined,
                title: 'No maintenance notes',
                message: 'Add notes about work done on this vehicle.',
              );
            }
            return Column(
              children: [
                for (final log in logs) ...[
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.sticky_note_2_outlined,
                              size: 18,
                              color: AppColors.gold,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: Text(
                                log.createdAt.formattedDateTime,
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: muted,
                                ),
                              ),
                            ),
                            if (!widget.readOnly)
                              IconButton(
                                tooltip: 'Delete note',
                                onPressed: isSaving
                                    ? null
                                    : () => _deleteNote(log),
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  size: 20,
                                  color: AppColors.error,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          log.note,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ],
            );
          },
        ),
      ],
    );
  }
}
