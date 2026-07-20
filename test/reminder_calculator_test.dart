import 'package:flutter_test/flutter_test.dart';

import 'package:autocare_manager/features/reminders/domain/entities/reminder_enums.dart';
import 'package:autocare_manager/features/reminders/domain/services/reminder_calculator.dart';

void main() {
  const ReminderCalculator calculator = ReminderCalculator();

  group('ReminderCalculator', () {
    test('upcoming when before thresholds', () {
      final status = calculator.calculateStatus(
        type: ReminderType.both,
        currentOdometer: 10000,
        nextServiceOdometer: 15000,
        nextServiceDate: DateTime.now().add(const Duration(days: 20)),
      );
      expect(status, ReminderStatus.upcoming);
    });

    test('due when odo equals target', () {
      final status = calculator.calculateStatus(
        type: ReminderType.km,
        currentOdometer: 15000,
        nextServiceOdometer: 15000,
      );
      expect(status, ReminderStatus.due);
    });

    test('overdue when odo exceeds target', () {
      final status = calculator.calculateStatus(
        type: ReminderType.km,
        currentOdometer: 16000,
        nextServiceOdometer: 15000,
      );
      expect(status, ReminderStatus.overdue);
    });

    test('overdue when date is past', () {
      final status = calculator.calculateStatus(
        type: ReminderType.date,
        currentOdometer: 10000,
        nextServiceDate: DateTime.now().subtract(const Duration(days: 3)),
      );
      expect(status, ReminderStatus.overdue);
    });

    test('completed is preserved', () {
      final status = calculator.calculateStatus(
        type: ReminderType.both,
        currentOdometer: 20000,
        nextServiceOdometer: 10000,
        existingStatus: ReminderStatus.completed,
      );
      expect(status, ReminderStatus.completed);
    });

    test('remaining km and days', () {
      expect(
        calculator.remainingKm(currentOdometer: 10, nextServiceOdometer: 40),
        30,
      );
      expect(
        calculator.remainingDays(
          nextServiceDate: DateTime.now().add(const Duration(days: 5)),
        ),
        5,
      );
    });
  });
}
