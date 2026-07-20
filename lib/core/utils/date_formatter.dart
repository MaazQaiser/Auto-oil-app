import 'package:intl/intl.dart';

import '../constants/app_constants.dart';

/// Date and time formatting helpers.
class DateFormatter {
  const DateFormatter._();

  static String formatDate(DateTime date, {String? pattern}) {
    return DateFormat(pattern ?? AppConstants.dateFormat).format(date);
  }

  static String formatDateTime(DateTime date, {String? pattern}) {
    return DateFormat(pattern ?? AppConstants.dateTimeFormat).format(date);
  }

  static String formatTime(DateTime date, {String? pattern}) {
    return DateFormat(pattern ?? AppConstants.timeFormat).format(date);
  }

  static String relative(DateTime date) {
    final DateTime now = DateTime.now();
    final Duration diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        if (diff.inMinutes == 0) return 'Just now';
        return '${diff.inMinutes}m ago';
      }
      return '${diff.inHours}h ago';
    }
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return formatDate(date);
  }
}
