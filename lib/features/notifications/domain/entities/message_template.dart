import 'package:equatable/equatable.dart';

/// Categories for built-in and custom message templates.
enum MessageTemplateCategory {
  oilChange,
  regularMaintenance,
  overdue,
  thankYou,
  custom;

  String get storageValue => switch (this) {
        MessageTemplateCategory.oilChange => 'oil_change',
        MessageTemplateCategory.regularMaintenance => 'regular_maintenance',
        MessageTemplateCategory.overdue => 'overdue',
        MessageTemplateCategory.thankYou => 'thank_you',
        MessageTemplateCategory.custom => 'custom',
      };

  String get label => switch (this) {
        MessageTemplateCategory.oilChange => 'Oil Change',
        MessageTemplateCategory.regularMaintenance => 'Regular Maintenance',
        MessageTemplateCategory.overdue => 'Overdue Reminder',
        MessageTemplateCategory.thankYou => 'Thank You',
        MessageTemplateCategory.custom => 'Custom',
      };

  static MessageTemplateCategory fromStorage(String value) {
    return MessageTemplateCategory.values.firstWhere(
      (e) => e.storageValue == value,
      orElse: () => MessageTemplateCategory.custom,
    );
  }
}

class MessageTemplate extends Equatable {
  const MessageTemplate({
    required this.id,
    required this.name,
    required this.body,
    this.category = MessageTemplateCategory.custom,
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String body;
  final MessageTemplateCategory category;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  MessageTemplate copyWith({
    String? id,
    String? name,
    String? body,
    MessageTemplateCategory? category,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MessageTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      body: body ?? this.body,
      category: category ?? this.category,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, body, category, isDefault, createdAt, updatedAt];
}
