import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/snackbar_helper.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../reminders/presentation/providers/reminder_providers.dart';
import '../../domain/entities/message_context.dart';
import '../../domain/entities/message_template.dart';
import '../../domain/entities/reminder_history_entry.dart';
import '../providers/notification_providers.dart';
import '../widgets/notification_widgets.dart';

class MessageEditorPage extends ConsumerStatefulWidget {
  const MessageEditorPage({super.key, required this.reminderId});

  final String reminderId;

  @override
  ConsumerState<MessageEditorPage> createState() => _MessageEditorPageState();
}

class _MessageEditorPageState extends ConsumerState<MessageEditorPage> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = true;
  bool _sending = false;
  MessageContext? _context;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final reminder =
        await ref.read(reminderRepositoryProvider).getById(widget.reminderId);
    if (reminder == null) {
      if (mounted) {
        SnackBarHelper.error(context, 'Reminder not found');
        context.pop();
      }
      return;
    }
    final helper = ref.read(whatsAppReminderHelperProvider);
    final ctx = await helper.buildContext(reminder);
    final message = await helper.defaultMessage(reminder);
    if (!mounted) return;
    setState(() {
      _context = ctx;
      _controller.text = message;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _insertPlaceholder(String key) async {
    final text = _controller.text;
    final selection = _controller.selection;
    final cursor = selection.baseOffset >= 0 ? selection.baseOffset : text.length;
    final updated =
        ref.read(messageComposerProvider).insertPlaceholder(text, cursor, key);
    setState(() {
      _controller.text = updated;
      _controller.selection = TextSelection.collapsed(
        offset: cursor + MessagePlaceholders.wrap(key).length,
      );
    });
  }

  Future<void> _openWhatsApp() async {
    final reminder =
        await ref.read(reminderRepositoryProvider).getById(widget.reminderId);
    if (reminder == null) return;
    if (_context?.preferredPhone.isEmpty ?? true) {
      if (!mounted) return;
      SnackBarHelper.error(
        context,
        'No phone number on file for this customer.',
      );
      return;
    }
    setState(() => _sending = true);
    final ok = await ref.read(whatsAppReminderHelperProvider).openWhatsApp(
          reminder: reminder,
          message: _controller.text.trim(),
        );
    if (!mounted) return;
    setState(() => _sending = false);
    if (ok) {
      SnackBarHelper.success(context, 'WhatsApp opened with your message');
      context.pop();
    } else {
      SnackBarHelper.error(
        context,
        'Unable to open WhatsApp. Is it installed?',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        appBar: CustomAppBar(title: 'Edit Message'),
        body: Center(child: LoadingIndicator()),
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'Edit Message'),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          Text(
            'Preview & edit before opening WhatsApp',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _controller,
            maxLines: 16,
            decoration: const InputDecoration(
              labelText: 'Message',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Insert placeholder', style: AppTextStyles.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final key in MessagePlaceholders.all)
                ActionChip(
                  label: Text(key),
                  onPressed: () => _insertPlaceholder(key),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: _sending ? 'Opening…' : 'Open WhatsApp',
            onPressed: _sending ? null : _openWhatsApp,
            icon: Icons.chat_rounded,
          ),
        ],
      ),
    );
  }
}

class MessageTemplatesPage extends ConsumerWidget {
  const MessageTemplatesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(messageTemplatesProvider);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Message Templates'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _editTemplate(context, ref, null),
        icon: const Icon(Icons.add),
        label: const Text('New Template'),
      ),
      body: templatesAsync.when(
        loading: () => const Center(child: LoadingIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (templates) {
          if (templates.isEmpty) {
            return const Center(child: Text('No templates yet'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            itemCount: templates.length,
            itemBuilder: (context, index) {
              final t = templates[index];
              return MessageTemplateCard(
                name: t.name,
                preview: t.body,
                categoryLabel: t.category.label,
                onEdit: () => _editTemplate(context, ref, t),
                onDelete: t.isDefault
                    ? null
                    : () async {
                        await ref
                            .read(messageTemplateDataSourceProvider)
                            .delete(t.id);
                        if (!context.mounted) return;
                        SnackBarHelper.info(context, 'Template deleted');
                      },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _editTemplate(
    BuildContext context,
    WidgetRef ref,
    MessageTemplate? existing,
  ) async {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final bodyCtrl = TextEditingController(
      text: existing?.body ?? kDefaultWhatsAppTemplate,
    );
    MessageTemplateCategory category =
        existing?.category ?? MessageTemplateCategory.custom;

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocal) {
            return AlertDialog(
              title: Text(existing == null ? 'New Template' : 'Edit Template'),
              content: SizedBox(
                width: 420,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameCtrl,
                        decoration: const InputDecoration(labelText: 'Name'),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<MessageTemplateCategory>(
                        initialValue: category,
                        items: [
                          for (final c in MessageTemplateCategory.values)
                            DropdownMenuItem(value: c, child: Text(c.label)),
                        ],
                        onChanged: (v) {
                          if (v != null) setLocal(() => category = v);
                        },
                        decoration:
                            const InputDecoration(labelText: 'Category'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: bodyCtrl,
                        maxLines: 10,
                        decoration: const InputDecoration(
                          labelText: 'Body',
                          alignLabelWithHint: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (saved != true) return;
    final now = DateTime.now();
    final template = MessageTemplate(
      id: existing?.id ?? const Uuid().v4(),
      name: nameCtrl.text.trim().isEmpty ? 'Untitled' : nameCtrl.text.trim(),
      body: bodyCtrl.text,
      category: category,
      isDefault: existing?.isDefault ?? false,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );
    await ref.read(messageTemplateDataSourceProvider).upsert(template);
    if (!context.mounted) return;
    SnackBarHelper.success(context, 'Template saved');
  }
}

class ReminderHistoryPage extends ConsumerWidget {
  const ReminderHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(reminderHistoryProvider);
    final fmt = DateFormat.yMMMd().add_jm();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Reminder History'),
      body: historyAsync.when(
        loading: () => const Center(child: LoadingIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (items) {
          if (items.isEmpty) {
            return const Center(
              child: Text('No reminder activity yet'),
            );
          }
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = items[index];
              return ReminderHistoryTile(
                title: item.actionType.label,
                subtitle: [
                  if (item.title != null) item.title!,
                  if (item.details != null) item.details!,
                ].join(' · '),
                timeLabel: fmt.format(item.createdAt),
                icon: _icon(item.actionType),
                color: _color(item.actionType),
              );
            },
          );
        },
      ),
    );
  }

  IconData _icon(ReminderHistoryAction action) {
    return switch (action) {
      ReminderHistoryAction.whatsappOpened => Icons.chat_rounded,
      ReminderHistoryAction.notificationSent => Icons.notifications_outlined,
      ReminderHistoryAction.completed => Icons.check_circle_outline,
      ReminderHistoryAction.dismissed => Icons.close_rounded,
      ReminderHistoryAction.reminderSent => Icons.send_outlined,
    };
  }

  Color _color(ReminderHistoryAction action) {
    return switch (action) {
      ReminderHistoryAction.whatsappOpened => const Color(0xFF25D366),
      ReminderHistoryAction.completed => Colors.green,
      ReminderHistoryAction.dismissed => Colors.grey,
      ReminderHistoryAction.notificationSent => Colors.blue,
      ReminderHistoryAction.reminderSent => Colors.indigo,
    };
  }
}

