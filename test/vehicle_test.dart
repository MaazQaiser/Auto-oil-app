import 'package:flutter_test/flutter_test.dart';

import 'package:autocare_manager/core/utils/validators.dart';
import 'package:autocare_manager/features/vehicles/domain/entities/vehicle.dart';
import 'package:autocare_manager/features/vehicles/domain/entities/vehicle_enums.dart';

void main() {
  group('Vehicle', () {
    test('displayName and formattedOdo', () {
      final Vehicle vehicle = Vehicle(
        id: '1',
        customerId: 'c1',
        make: 'Toyota',
        model: 'Corolla',
        variant: 'Altis',
        registrationNumber: 'LEA-1234',
        fuelType: FuelType.petrol,
        transmission: TransmissionType.automatic,
        currentOdo: 145000,
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      );
      expect(vehicle.displayName, 'Toyota Corolla Altis');
      expect(vehicle.formattedOdo.contains('145'), isTrue);
      expect(vehicle.serviceSummary, 'No Service History');
    });
  });

  group('Vehicle validators', () {
    test('year validation', () {
      expect(Validators.year(null), isNull);
      expect(Validators.year('2019'), isNull);
      expect(Validators.year('1800'), isNotNull);
    });

    test('odometer validation', () {
      expect(Validators.odometer(null), isNotNull);
      expect(Validators.odometer('82000'), isNull);
      expect(Validators.odometer('-1'), isNotNull);
    });
  });
}
