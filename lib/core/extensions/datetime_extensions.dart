import '../utils/date_formatter.dart';

/// DateTime convenience extensions.
extension DateTimeExtensions on DateTime {
  String get formattedDate => DateFormatter.formatDate(this);
  String get formattedDateTime => DateFormatter.formatDateTime(this);
  String get formattedTime => DateFormatter.formatTime(this);
  String get relative => DateFormatter.relative(this);

  bool get isToday {
    final DateTime now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);
}
