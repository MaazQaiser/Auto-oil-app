import 'package:drift/drift.dart';

/// Saved WhatsApp / reminder message templates.
@DataClassName('MessageTemplateRow')
class MessageTemplates extends Table {
  TextColumn get id => text()();

  TextColumn get name => text().withLength(min: 1, max: 100)();

  /// Template body with placeholders like {{CustomerName}}.
  TextColumn get body => text()();

  /// oil_change | regular_maintenance | overdue | thank_you | custom
  TextColumn get category => text().withDefault(const Constant('custom'))();

  BoolColumn get isDefault =>
      boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
