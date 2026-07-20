import '../entities/message_context.dart';

/// Fills {{Placeholder}} tokens in message templates.
class MessageComposer {
  const MessageComposer();

  String compose(String template, MessageContext context) {
    String result = template;
    context.toMap().forEach((key, value) {
      result = result.replaceAll(MessagePlaceholders.wrap(key), value);
    });
    return result.trim();
  }

  /// Inserts a placeholder at [cursor] within [text].
  String insertPlaceholder(String text, int cursor, String placeholderKey) {
    final String token = MessagePlaceholders.wrap(placeholderKey);
    final int safe = cursor.clamp(0, text.length);
    return text.replaceRange(safe, safe, token);
  }
}
