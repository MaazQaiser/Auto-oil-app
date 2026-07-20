import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/sync/sync_collections.dart';
import '../../../../core/sync/sync_queue.dart';
import '../../../../core/sync/sync_serializers.dart';
import '../../domain/entities/message_context.dart';
import '../../domain/entities/message_template.dart';

class MessageTemplateDataSource {
  MessageTemplateDataSource(this._db, [this._sync = const NoopSyncQueue()]);

  final AppDatabase _db;
  final SyncQueue _sync;
  static const Uuid _uuid = Uuid();

  MessageTemplate _map(MessageTemplateRow row) {
    return MessageTemplate(
      id: row.id,
      name: row.name,
      body: row.body,
      category: MessageTemplateCategory.fromStorage(row.category),
      isDefault: row.isDefault,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  Future<List<MessageTemplate>> getAll() async {
    final rows = await (_db.select(_db.messageTemplates)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
    return rows.map(_map).toList();
  }

  Stream<List<MessageTemplate>> watchAll() {
    return (_db.select(_db.messageTemplates)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch()
        .map((rows) => rows.map(_map).toList());
  }

  Future<MessageTemplate?> getById(String id) async {
    final row = await (_db.select(_db.messageTemplates)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    return row == null ? null : _map(row);
  }

  Future<MessageTemplate> upsert(MessageTemplate template) async {
    try {
      final now = DateTime.now();
      final String id = template.id.isEmpty ? _uuid.v4() : template.id;
      await _db.into(_db.messageTemplates).insertOnConflictUpdate(
            MessageTemplatesCompanion(
              id: Value(id),
              name: Value(template.name),
              body: Value(template.body),
              category: Value(template.category.storageValue),
              isDefault: Value(template.isDefault),
              createdAt: Value(template.createdAt),
              updatedAt: Value(now),
            ),
          );
      final saved = (await getById(id))!;
      await _sync.enqueueUpsert(
        SyncCollections.messageTemplates,
        saved.id,
        SyncSerializers.templateToMap(saved),
      );
      return saved;
    } catch (e) {
      throw DatabaseException('Failed to save message template: $e');
    }
  }

  Future<void> delete(String id) async {
    await (_db.delete(_db.messageTemplates)..where((t) => t.id.equals(id))).go();
    await _sync.enqueueDelete(SyncCollections.messageTemplates, id);
  }

  Future<void> seedDefaultsIfEmpty() async {
    final countExp = _db.messageTemplates.id.count();
    final row = await (_db.selectOnly(_db.messageTemplates)
          ..addColumns([countExp]))
        .getSingle();
    if ((row.read(countExp) ?? 0) > 0) return;

    final DateTime now = DateTime.now();
    final defaults = <MessageTemplate>[
      MessageTemplate(
        id: _uuid.v4(),
        name: 'Oil Change',
        category: MessageTemplateCategory.oilChange,
        isDefault: true,
        body: kDefaultWhatsAppTemplate,
        createdAt: now,
        updatedAt: now,
      ),
      MessageTemplate(
        id: _uuid.v4(),
        name: 'Regular Maintenance',
        category: MessageTemplateCategory.regularMaintenance,
        isDefault: true,
        body: kDefaultWhatsAppTemplate,
        createdAt: now,
        updatedAt: now,
      ),
      MessageTemplate(
        id: _uuid.v4(),
        name: 'Overdue Reminder',
        category: MessageTemplateCategory.overdue,
        isDefault: true,
        body: '''
Hello {{CustomerName}},

This is an overdue maintenance reminder from {{WorkshopName}}.

Vehicle: {{Vehicle}}
Registration: {{Registration}}

Your service was recommended on {{NextServiceDate}}.
Please contact us as soon as possible to schedule an appointment.

Thank you.
''',
        createdAt: now,
        updatedAt: now,
      ),
      MessageTemplate(
        id: _uuid.v4(),
        name: 'Thank You',
        category: MessageTemplateCategory.thankYou,
        isDefault: true,
        body: '''
Hello {{CustomerName}},

Thank you for choosing {{WorkshopName}}.

We recently serviced your {{Vehicle}} ({{Registration}}).
We look forward to seeing you again.

Warm regards,
{{WorkshopName}}
''',
        createdAt: now,
        updatedAt: now,
      ),
    ];

    for (final t in defaults) {
      await upsert(t);
    }
  }
}
