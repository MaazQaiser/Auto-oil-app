import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/logger.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';

/// Debug-only helper that seeds sample customers.
class CustomerSeedData {
  const CustomerSeedData._();

  static const _uuid = Uuid();

  static const List<Map<String, String>> _samples = [
    {
      'fullName': 'Ahmed Khan',
      'phoneNumber': '+923001112233',
      'whatsappNumber': '+923001112233',
      'email': 'ahmed.khan@email.com',
      'address': '12 Mall Road',
      'city': 'Lahore',
      'notes': 'Prefers evening appointments',
    },
    {
      'fullName': 'Sara Malik',
      'phoneNumber': '+923004445566',
      'whatsappNumber': '+923004445566',
      'email': 'sara.malik@email.com',
      'address': '45 Gulberg III',
      'city': 'Lahore',
      'notes': 'Fleet customer',
    },
    {
      'fullName': 'Usman Ali',
      'phoneNumber': '+923217778899',
      'city': 'Islamabad',
      'address': 'F-10 Markaz',
      'email': 'usman.ali@email.com',
    },
    {
      'fullName': 'Fatima Noor',
      'phoneNumber': '+923339998877',
      'whatsappNumber': '+923339998877',
      'city': 'Karachi',
      'address': 'Clifton Block 5',
    },
    {
      'fullName': 'Bilal Hussain',
      'phoneNumber': '+923125551010',
      'city': 'Faisalabad',
      'email': 'bilal.h@email.com',
      'notes': 'Oil change every 5,000 km',
    },
    {
      'fullName': 'Ayesha Raza',
      'phoneNumber': '+923008887766',
      'whatsappNumber': '+923008887766',
      'city': 'Rawalpindi',
      'address': 'Saddar Main Bazaar',
    },
    {
      'fullName': 'Hamza Siddiqui',
      'phoneNumber': '+923214443322',
      'city': 'Multan',
      'email': 'hamza.s@email.com',
    },
    {
      'fullName': 'Zainab Iqbal',
      'phoneNumber': '+923337771212',
      'whatsappNumber': '+923337771212',
      'city': 'Peshawar',
      'notes': 'VIP customer',
    },
    {
      'fullName': 'Omar Farooq',
      'phoneNumber': '+923006669900',
      'city': 'Quetta',
      'address': 'Jinnah Road',
      'email': 'omar.farooq@email.com',
    },
    {
      'fullName': 'Maria Sheikh',
      'phoneNumber': '+923218889900',
      'whatsappNumber': '+923218889900',
      'city': 'Sialkot',
      'notes': 'Corporate account',
    },
  ];

  /// Inserts up to 10 sample customers when the active list is empty.
  ///
  /// Returns the number of customers inserted. No-ops outside debug mode.
  static Future<int> seedIfNeeded(CustomerRepository repository) async {
    if (!kDebugMode) return 0;

    final List<Customer> existing =
        await repository.getAllCustomers(archived: false);
    if (existing.isNotEmpty) {
      AppLogger.info('Seed skipped — customers already exist');
      return 0;
    }

    int inserted = 0;
    final DateTime now = DateTime.now();

    for (int i = 0; i < _samples.length; i++) {
      final Map<String, String> sample = _samples[i];
      final DateTime createdAt = now.subtract(Duration(days: i * 2, hours: i));
      try {
        await repository.createCustomer(
          Customer(
            id: _uuid.v4(),
            fullName: sample['fullName']!,
            phoneNumber: sample['phoneNumber']!,
            whatsappNumber: sample['whatsappNumber'],
            email: sample['email'],
            address: sample['address'],
            city: sample['city'],
            notes: sample['notes'],
            createdAt: createdAt,
            updatedAt: createdAt,
          ),
        );
        inserted++;
      } catch (e) {
        AppLogger.warning('Seed skipped for ${sample['fullName']}: $e');
      }
    }

    AppLogger.info('Seeded $inserted sample customers');
    return inserted;
  }

  /// Force-inserts sample customers (debug only), skipping duplicates by phone.
  static Future<int> seedForce(CustomerRepository repository) async {
    if (!kDebugMode) return 0;

    int inserted = 0;
    final DateTime now = DateTime.now();

    for (int i = 0; i < _samples.length; i++) {
      final Map<String, String> sample = _samples[i];
      final bool taken =
          await repository.isPhoneTaken(sample['phoneNumber']!);
      if (taken) continue;

      final DateTime createdAt = now.subtract(Duration(days: i));
      await repository.createCustomer(
        Customer(
          id: _uuid.v4(),
          fullName: sample['fullName']!,
          phoneNumber: sample['phoneNumber']!,
          whatsappNumber: sample['whatsappNumber'],
          email: sample['email'],
          address: sample['address'],
          city: sample['city'],
          notes: sample['notes'],
          createdAt: createdAt,
          updatedAt: createdAt,
        ),
      );
      inserted++;
    }

    return inserted;
  }
}
