/// How the next maintenance is scheduled.
enum ReminderType {
  km('KM'),
  date('Date'),
  both('Both');

  const ReminderType(this.label);
  final String label;

  static ReminderType fromStorage(String value) {
    return ReminderType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ReminderType.both,
    );
  }
}

/// Calculated / persisted reminder lifecycle status.
enum ReminderStatus {
  upcoming('Upcoming'),
  due('Due'),
  overdue('Overdue'),
  completed('Completed');

  const ReminderStatus(this.label);
  final String label;

  static ReminderStatus fromStorage(String value) {
    return ReminderStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ReminderStatus.upcoming,
    );
  }
}
