import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/logger.dart';
import '../../../customers/domain/entities/customer.dart';
import '../../../customers/domain/repositories/customer_repository.dart';
import '../../domain/entities/vehicle.dart';
import '../../domain/entities/vehicle_enums.dart';
import '../../domain/repositories/vehicle_repository.dart';

class SeedResult {
  const SeedResult({required this.customers, required this.vehicles});

  final int customers;
  final int vehicles;
}

/// Debug-only demo data: 10 customers with 1–4 vehicles each.
class VehicleSeedData {
  const VehicleSeedData._();

  static const _uuid = Uuid();

  static const List<Map<String, String>> _customers = [
    {
      'fullName': 'Ahmed Khan',
      'phoneNumber': '+923001112233',
      'city': 'Lahore',
      'email': 'ahmed.khan@email.com',
    },
    {
      'fullName': 'Sara Malik',
      'phoneNumber': '+923004445566',
      'city': 'Lahore',
      'email': 'sara.malik@email.com',
    },
    {
      'fullName': 'Usman Ali',
      'phoneNumber': '+923217778899',
      'city': 'Islamabad',
    },
    {
      'fullName': 'Fatima Noor',
      'phoneNumber': '+923339998877',
      'city': 'Karachi',
    },
    {
      'fullName': 'Bilal Hussain',
      'phoneNumber': '+923125551010',
      'city': 'Faisalabad',
    },
    {
      'fullName': 'Ayesha Raza',
      'phoneNumber': '+923008887766',
      'city': 'Rawalpindi',
    },
    {
      'fullName': 'Hamza Siddiqui',
      'phoneNumber': '+923214443322',
      'city': 'Multan',
    },
    {
      'fullName': 'Zainab Iqbal',
      'phoneNumber': '+923337771212',
      'city': 'Peshawar',
    },
    {
      'fullName': 'Omar Farooq',
      'phoneNumber': '+923006669900',
      'city': 'Quetta',
    },
    {
      'fullName': 'Maria Sheikh',
      'phoneNumber': '+923218889900',
      'city': 'Sialkot',
    },
  ];

  static const List<Map<String, Object>> _vehicleTemplates = [
    {
      'make': 'Toyota',
      'model': 'Corolla',
      'variant': 'Altis',
      'year': 2019,
      'fuel': FuelType.petrol,
      'transmission': TransmissionType.automatic,
      'capacity': '1800cc',
      'color': 'White',
    },
    {
      'make': 'Honda',
      'model': 'Civic',
      'variant': 'Oriel',
      'year': 2021,
      'fuel': FuelType.petrol,
      'transmission': TransmissionType.cvt,
      'capacity': '1500cc',
      'color': 'Black',
    },
    {
      'make': 'Suzuki',
      'model': 'Alto',
      'variant': 'VXR',
      'year': 2020,
      'fuel': FuelType.petrol,
      'transmission': TransmissionType.manual,
      'capacity': '660cc',
      'color': 'Silver',
    },
    {
      'make': 'Hyundai',
      'model': 'Elantra',
      'year': 2022,
      'fuel': FuelType.petrol,
      'transmission': TransmissionType.automatic,
      'capacity': '2000cc',
      'color': 'Grey',
    },
    {
      'make': 'Kia',
      'model': 'Sportage',
      'variant': 'AWD',
      'year': 2023,
      'fuel': FuelType.diesel,
      'transmission': TransmissionType.automatic,
      'capacity': '2000cc',
      'color': 'Blue',
    },
    {
      'make': 'Toyota',
      'model': 'Hilux',
      'variant': 'Revo',
      'year': 2018,
      'fuel': FuelType.diesel,
      'transmission': TransmissionType.manual,
      'capacity': '2800cc',
      'color': 'White',
    },
    {
      'make': 'Hyundai',
      'model': 'Tucson',
      'year': 2022,
      'fuel': FuelType.hybrid,
      'transmission': TransmissionType.automatic,
      'capacity': '1600cc',
      'color': 'Red',
    },
    {
      'make': 'Honda',
      'model': 'City',
      'variant': 'Aspire',
      'year': 2020,
      'fuel': FuelType.petrol,
      'transmission': TransmissionType.cvt,
      'capacity': '1500cc',
      'color': 'Brown',
    },
  ];

  static const List<String> _plates = [
    'LEA-1234',
    'ABC-5678',
    'LHR-9012',
    'ISB-3456',
    'KHI-7890',
    'FSD-2468',
    'RWP-1357',
    'MUX-9753',
    'PEW-8642',
    'QTA-1122',
    'SKT-3344',
    'GRW-5566',
    'SWL-7788',
    'BWP-9900',
    'JHG-2211',
    'ATD-4433',
    'MZN-6655',
    'DGK-8877',
    'SAH-0099',
    'CHN-1010',
  ];

  static const List<int> _odos = [
    145000,
    82000,
    45000,
    28000,
    67000,
    112000,
    35000,
    91000,
    56000,
    78000,
    124000,
    19000,
    88000,
    102000,
    41000,
    63000,
    97000,
    15000,
    133000,
    52000,
  ];

  /// Seeds customers (if needed) and vehicles. Debug mode only.
  static Future<SeedResult> seedDemoData({
    required CustomerRepository customerRepository,
    required VehicleRepository vehicleRepository,
  }) async {
    if (!kDebugMode) return const SeedResult(customers: 0, vehicles: 0);

    int customersInserted = 0;
    int vehiclesInserted = 0;
    final DateTime now = DateTime.now();
    final List<String> customerIds = [];

    // Ensure 10 customers exist (create missing by phone).
    for (int i = 0; i < _customers.length; i++) {
      final Map<String, String> sample = _customers[i];
      final bool taken =
          await customerRepository.isPhoneTaken(sample['phoneNumber']!);
      if (taken) {
        final List<Customer> all =
            await customerRepository.getAllCustomers(archived: false);
        for (final c in all) {
          if (c.phoneNumber == sample['phoneNumber']) {
            customerIds.add(c.id);
            break;
          }
        }
        continue;
      }

      final DateTime createdAt = now.subtract(Duration(days: i * 3));
      final Customer created = await customerRepository.createCustomer(
        Customer(
          id: _uuid.v4(),
          fullName: sample['fullName']!,
          phoneNumber: sample['phoneNumber']!,
          email: sample['email'],
          city: sample['city'],
          createdAt: createdAt,
          updatedAt: createdAt,
        ),
      );
      customerIds.add(created.id);
      customersInserted++;
    }

    // If we still need IDs (all existed), load them.
    if (customerIds.length < 10) {
      final List<Customer> all =
          await customerRepository.getAllCustomers(archived: false);
      for (final sample in _customers) {
        for (final c in all) {
          if (c.phoneNumber == sample['phoneNumber'] &&
              !customerIds.contains(c.id)) {
            customerIds.add(c.id);
            break;
          }
        }
      }
    }

    int plateIndex = 0;
    for (int c = 0; c < customerIds.length && c < 10; c++) {
      final String customerId = customerIds[c];
      final int vehicleCount = 1 + (c % 4); // 1–4 vehicles

      for (int v = 0; v < vehicleCount; v++) {
        final Map<String, Object> template =
            _vehicleTemplates[(c + v) % _vehicleTemplates.length];
        final String plate = _plates[plateIndex % _plates.length];
        plateIndex++;

        final bool regTaken =
            await vehicleRepository.isRegistrationTaken(plate);
        if (regTaken) continue;

        final DateTime createdAt =
            now.subtract(Duration(days: c + v, hours: v * 3));
        try {
          await vehicleRepository.createVehicle(
            Vehicle(
              id: _uuid.v4(),
              customerId: customerId,
              make: template['make']! as String,
              model: template['model']! as String,
              variant: template['variant'] as String?,
              year: template['year'] as int?,
              registrationNumber: plate,
              vinNumber: 'VIN${plate.replaceAll('-', '')}${c}X$v',
              engineNumber: 'ENG-${1000 + c * 10 + v}',
              engineCapacity: template['capacity'] as String?,
              fuelType: template['fuel']! as FuelType,
              transmission: template['transmission']! as TransmissionType,
              color: template['color'] as String?,
              currentOdo: _odos[(c * 3 + v) % _odos.length],
              purchaseDate: DateTime((template['year'] as int?) ?? 2020, 6, 15),
              insuranceExpiry: now.add(Duration(days: 90 + c * 10)),
              registrationExpiry: now.add(Duration(days: 180 + c * 5)),
              notes: v == 0 ? 'Primary vehicle' : null,
              createdAt: createdAt,
              updatedAt: createdAt,
            ),
          );
          vehiclesInserted++;
        } catch (e) {
          AppLogger.warning('Seed vehicle skipped ($plate): $e');
        }
      }
    }

    AppLogger.info(
      'Demo seed complete: $customersInserted customers, $vehiclesInserted vehicles',
    );
    return SeedResult(
      customers: customersInserted,
      vehicles: vehiclesInserted,
    );
  }
}
