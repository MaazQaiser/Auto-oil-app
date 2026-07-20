import '../entities/reminder_enums.dart';

/// Pure status / remaining calculations for maintenance reminders.
class ReminderCalculator {
  const ReminderCalculator();

  /// Computes status from odometer and/or date thresholds.
  ///
  /// Priority: Overdue > Due > Upcoming.
  /// Completed is never auto-calculated — it is set manually.
  ReminderStatus calculateStatus({
    required ReminderType type,
    required int currentOdometer,
    int? nextServiceOdometer,
    DateTime? nextServiceDate,
    DateTime? now,
    ReminderStatus? existingStatus,
  }) {
    if (existingStatus == ReminderStatus.completed) {
      return ReminderStatus.completed;
    }

    final DateTime today = _dateOnly(now ?? DateTime.now());
    bool overdue = false;
    bool due = false;

    final bool checkDate =
        type == ReminderType.date || type == ReminderType.both;
    final bool checkKm = type == ReminderType.km || type == ReminderType.both;

    if (checkDate && nextServiceDate != null) {
      final DateTime next = _dateOnly(nextServiceDate);
      if (today.isAfter(next)) {
        overdue = true;
      } else if (today.isAtSameMomentAs(next)) {
        due = true;
      }
    }

    if (checkKm && nextServiceOdometer != null) {
      if (currentOdometer > nextServiceOdometer) {
        overdue = true;
      } else if (currentOdometer >= nextServiceOdometer) {
        due = true;
      }
    }

    if (overdue) return ReminderStatus.overdue;
    if (due) return ReminderStatus.due;
    return ReminderStatus.upcoming;
  }

  int? remainingKm({
    required int currentOdometer,
    int? nextServiceOdometer,
  }) {
    if (nextServiceOdometer == null) return null;
    return nextServiceOdometer - currentOdometer;
  }

  int? remainingDays({
    DateTime? nextServiceDate,
    DateTime? now,
  }) {
    if (nextServiceDate == null) return null;
    final DateTime today = _dateOnly(now ?? DateTime.now());
    final DateTime next = _dateOnly(nextServiceDate);
    return next.difference(today).inDays;
  }

  DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);
}
