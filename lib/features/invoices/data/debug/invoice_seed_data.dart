import 'dart:math';

import 'package:uuid/uuid.dart';

import '../../../../core/services/settings_service.dart';
import '../../../customers/domain/entities/customer.dart';
import '../../../customers/domain/repositories/customer_repository.dart';
import '../../../service_records/domain/entities/service_record.dart';
import '../../../service_records/domain/repositories/service_record_repository.dart';
import '../../../vehicles/domain/entities/vehicle.dart';
import '../../../vehicles/domain/entities/vehicle_enums.dart';
import '../../../vehicles/domain/repositories/vehicle_repository.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_enums.dart';
import '../../domain/repositories/invoice_repository.dart';

/// Debug-only seed: up to 500 realistic invoices.
class InvoiceSeedData {
  const InvoiceSeedData._();

  static const Uuid _uuid = Uuid();
  static final Random _rng = Random(42);

  static const _makes = ['Toyota', 'Honda', 'Suzuki', 'Nissan', 'Hyundai', 'Kia'];
  static const _models = ['Corolla', 'Civic', 'Swift', 'Sunny', 'Elantra', 'Sportage'];
  static const _oils = ['Castrol', 'Mobil 1', 'Shell Helix', 'Total Quartz', 'ZIC'];
  static const _serviceTypes = [
    'Oil Change',
    'Oil Filter Replacement',
    'Air Filter Replacement',
    'Full Service',
    'Brake Service',
    'Tune Up',
  ];

  static Future<int> seedInvoices({
    required CustomerRepository customerRepository,
    required VehicleRepository vehicleRepository,
    required ServiceRecordRepository serviceRecordRepository,
    required InvoiceRepository invoiceRepository,
    required SettingsService settings,
    int target = 500,
  }) async {
    final existing = await invoiceRepository.countAll();
    if (existing >= target) return 0;

    final customers = await customerRepository.getAllCustomers();
    final List<Customer> poolCustomers = [...customers];
    final List<Vehicle> poolVehicles = [];

    // Ensure base customers/vehicles exist.
    while (poolCustomers.length < 40) {
      final now = DateTime.now().subtract(Duration(days: _rng.nextInt(400)));
      final c = Customer(
        id: _uuid.v4(),
        fullName: 'Demo Customer ${poolCustomers.length + 1}',
        phoneNumber: '03${_rng.nextInt(90000000) + 10000000}',
        city: 'City ${_rng.nextInt(8) + 1}',
        createdAt: now,
        updatedAt: now,
      );
      await customerRepository.createCustomer(c);
      poolCustomers.add(c);
    }

    for (final c in poolCustomers.take(60)) {
      final vehicles =
          await vehicleRepository.getVehiclesByCustomer(c.id);
      if (vehicles.isEmpty) {
        final now = DateTime.now();
        final make = _makes[_rng.nextInt(_makes.length)];
        final model = _models[_rng.nextInt(_models.length)];
        final v = Vehicle(
          id: _uuid.v4(),
          customerId: c.id,
          make: make,
          model: model,
          year: 2015 + _rng.nextInt(10),
          registrationNumber:
              'REG-${1000 + _rng.nextInt(9000)}-${_rng.nextInt(99)}',
          fuelType: FuelType.petrol,
          transmission: TransmissionType.automatic,
          currentOdo: 20000 + _rng.nextInt(120000),
          createdAt: now,
          updatedAt: now,
          ownerName: c.fullName,
        );
        await vehicleRepository.createVehicle(v);
        poolVehicles.add(v);
      } else {
        poolVehicles.addAll(vehicles);
      }
    }

    if (poolVehicles.isEmpty) return 0;

    final int toCreate = target - existing;
    int created = 0;
    final statuses = PaymentStatus.values;
    final methods = PaymentMethod.values;
    final taxPct = settings.invoiceTaxPercent;

    for (int i = 0; i < toCreate; i++) {
      final vehicle = poolVehicles[_rng.nextInt(poolVehicles.length)];
      final daysAgo = _rng.nextInt(365);
      final serviceDate = DateTime.now().subtract(Duration(days: daysAgo));
      final labour = 20.0 + _rng.nextInt(180);
      final parts = 15.0 + _rng.nextInt(250);
      final total = labour + parts;
      final oil = _oils[_rng.nextInt(_oils.length)];
      final type = _serviceTypes[_rng.nextInt(_serviceTypes.length)];

      final service = ServiceRecord(
        id: _uuid.v4(),
        vehicleId: vehicle.id,
        serviceDate: serviceDate,
        odometerReading: vehicle.currentOdo + _rng.nextInt(5000),
        serviceType: type,
        oilBrand: oil,
        laborCost: labour,
        partsCost: parts,
        totalCost: total,
        createdAt: serviceDate,
        updatedAt: serviceDate,
      );
      await serviceRecordRepository.createServiceRecord(service);

      final discount = _rng.nextBool() ? 0.0 : _rng.nextInt(20).toDouble();
      final taxable = (total - discount).clamp(0, double.infinity);
      final tax = taxable * (taxPct / 100);
      final status = statuses[_rng.nextInt(statuses.length)];
      final method = methods[_rng.nextInt(methods.length)];
      final number = await settings.allocateInvoiceNumber();
      final now = DateTime.now();

      final invoice = Invoice(
        id: _uuid.v4(),
        serviceRecordId: service.id,
        customerId: vehicle.customerId,
        vehicleId: vehicle.id,
        invoiceNumber: number,
        invoiceDate: serviceDate,
        subtotal: total,
        discount: discount,
        tax: tax,
        grandTotal: taxable + tax,
        paymentMethod: method,
        paymentStatus: status,
        paidDate: status == PaymentStatus.paid ? serviceDate : null,
        currency: settings.invoiceCurrency,
        labourDescription: 'Labour',
        labourAmount: labour,
        partsDescription: 'Parts / Oil ($oil)',
        partsAmount: parts,
        serviceDescription: type,
        createdAt: now,
        updatedAt: now,
      );
      await invoiceRepository.create(invoice);
      created++;
    }

    return created;
  }
}
