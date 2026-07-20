import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/logger.dart';
import '../../../customers/domain/entities/customer.dart';
import '../../../customers/domain/repositories/customer_repository.dart';
import '../../../service_records/domain/entities/service_record.dart';
import '../../../service_records/domain/repositories/service_record_repository.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/domain/entities/vehicle_enums.dart';
import '../../../vehicles/domain/repositories/vehicle_repository.dart';
import '../../domain/entities/reminder_enums.dart';
import '../../domain/repositories/reminder_repository.dart';

/// Debug seed: creates customers/vehicles/services that yield ~100 reminders.
class ReminderSeedData {
  const ReminderSeedData._();

  static const _uuid = Uuid();

  static Future<int> seedReminders({
    required CustomerRepository customerRepository,
    required VehicleRepository vehicleRepository,
    required ServiceRecordRepository serviceRecordRepository,
    required ReminderRepository reminderRepository,
  }) async {
    if (!kDebugMode) return 0;

    final existing = await reminderRepository.getAll();
    if (existing.length >= 80) {
      AppLogger.info('Reminder seed skipped — already populated');
      return 0;
    }

    final DateTime now = DateTime.now();
    final List<String> vehicleIds = [];

    // Ensure a pool of customers + vehicles.
    for (int i = 0; i < 20; i++) {
      final phone = '+92300${(1000000 + i).toString().padLeft(7, '0')}';
      String customerId;
      if (await customerRepository.isPhoneTaken(phone)) {
        final all = await customerRepository.getAllCustomers();
        customerId = all.firstWhere((c) => c.phoneNumber == phone).id;
      } else {
        final c = await customerRepository.createCustomer(
          Customer(
            id: _uuid.v4(),
            fullName: 'Fleet Owner ${i + 1}',
            phoneNumber: phone,
            city: 'City ${i % 5}',
            createdAt: now,
            updatedAt: now,
          ),
        );
        customerId = c.id;
      }

      for (int v = 0; v < 2; v++) {
        final plate = 'RM-${i.toString().padLeft(2, '0')}$v';
        if (await vehicleRepository.isRegistrationTaken(plate)) {
          final list = await vehicleRepository.getVehiclesByCustomer(customerId);
          for (final veh in list) {
            if (veh.registrationNumber == plate) vehicleIds.add(veh.id);
          }
          continue;
        }
        final vehicle = await vehicleRepository.createVehicle(
          Vehicle(
            id: _uuid.v4(),
            customerId: customerId,
            make: ['Toyota', 'Honda', 'Suzuki', 'Kia'][i % 4],
            model: ['Corolla', 'Civic', 'Alto', 'Sportage'][i % 4],
            year: 2018 + (i % 6),
            registrationNumber: plate,
            fuelType: FuelType.values[i % FuelType.values.length],
            transmission:
                TransmissionType.values[i % TransmissionType.values.length],
            currentOdo: 40000 + i * 2500 + v * 1000,
            createdAt: now,
            updatedAt: now,
          ),
        );
        vehicleIds.add(vehicle.id);
      }
    }

    int created = 0;
    final statuses = [
      ReminderStatus.upcoming,
      ReminderStatus.due,
      ReminderStatus.overdue,
      ReminderStatus.completed,
    ];

    for (int i = 0; i < 100 && i < vehicleIds.length * 3; i++) {
      final vehicleId = vehicleIds[i % vehicleIds.length];
      final vehicle = await vehicleRepository.getVehicleById(vehicleId);
      if (vehicle == null) continue;

      final targetStatus = statuses[i % statuses.length];
      final int currentOdo = vehicle.currentOdo;
      late int nextOdo;
      late DateTime nextDate;
      late DateTime serviceDate;

      switch (targetStatus) {
        case ReminderStatus.upcoming:
          nextOdo = currentOdo + 3000 + (i % 5) * 500;
          nextDate = now.add(Duration(days: 10 + (i % 40)));
          serviceDate = now.subtract(Duration(days: 20 + i % 10));
        case ReminderStatus.due:
          nextOdo = currentOdo;
          nextDate = DateTime(now.year, now.month, now.day);
          serviceDate = now.subtract(const Duration(days: 30));
        case ReminderStatus.overdue:
          nextOdo = currentOdo - 1500 - (i % 8) * 100;
          nextDate = now.subtract(Duration(days: 5 + i % 20));
          serviceDate = now.subtract(Duration(days: 60 + i % 15));
        case ReminderStatus.completed:
          nextOdo = currentOdo + 1000;
          nextDate = now.add(const Duration(days: 45));
          serviceDate = now.subtract(Duration(days: 5 + i % 7));
      }

      try {
        final record = await serviceRecordRepository.createServiceRecord(
          ServiceRecord(
            id: _uuid.v4(),
            vehicleId: vehicleId,
            serviceDate: serviceDate,
            odometerReading: currentOdo - (i % 3) * 100,
            serviceType: ['Oil Change', 'Full Service', 'Filter Change', 'Tune Up']
                [i % 4],
            oilBrand: ['Chevron 5W30', 'Shell Helix', 'Castrol', 'Total'][i % 4],
            laborCost: 1500 + (i % 10) * 200.0,
            partsCost: 800 + (i % 8) * 150.0,
            totalCost: 2300 + (i % 10) * 350.0,
            reminderType: ReminderType.both,
            nextServiceOdometer: nextOdo,
            nextServiceDate: nextDate,
            reminderEnabled: true,
            whatsappEnabled: i.isEven,
            createdAt: now,
            updatedAt: now,
          ),
        );

        if (targetStatus == ReminderStatus.completed) {
          final reminder =
              await reminderRepository.getByServiceRecordId(record.id);
          if (reminder != null) {
            await reminderRepository.updateReminder(
              reminder.copyWith(
                status: ReminderStatus.completed,
                updatedAt: DateTime.now(),
              ),
            );
          }
        }
        created++;
      } catch (e) {
        AppLogger.warning('Reminder seed skip: $e');
      }
    }

    await reminderRepository.recalculateAllStatuses();
    AppLogger.info('Seeded $created service records / reminders');
    return created;
  }
}
