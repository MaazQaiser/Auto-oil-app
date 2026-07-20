import 'dart:convert';

import '../../features/customers/domain/entities/customer.dart';
import '../../features/inventory/domain/entities/inventory_item.dart';
import '../../features/invoices/domain/entities/invoice.dart';
import '../../features/invoices/domain/entities/invoice_enums.dart';
import '../../features/notifications/domain/entities/message_template.dart';
import '../../features/notifications/domain/entities/reminder_history_entry.dart';
import '../../features/reminders/domain/entities/maintenance_reminder.dart';
import '../../features/reminders/domain/entities/reminder_enums.dart';
import '../../features/service_records/domain/entities/service_record.dart';
import '../../features/vehicles/domain/entities/maintenance_log.dart';
import '../../features/vehicles/domain/entities/vehicle.dart';
import '../../features/vehicles/domain/entities/vehicle_enums.dart';

/// Serialize / deserialize domain entities for Firestore + outbox JSON.
abstract final class SyncSerializers {
  static String encodePayload(Map<String, dynamic> data) => jsonEncode(data);

  static Map<String, dynamic> decodePayload(String json) {
    return Map<String, dynamic>.from(jsonDecode(json) as Map);
  }

  static String? _iso(DateTime? value) => value?.toUtc().toIso8601String();

  static DateTime _parseDate(dynamic value, {DateTime? fallback}) {
    if (value == null) return fallback ?? DateTime.fromMillisecondsSinceEpoch(0);
    if (value is DateTime) return value.toUtc();
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
    }
    if (value is String) {
      return DateTime.tryParse(value)?.toUtc() ??
          (fallback ?? DateTime.fromMillisecondsSinceEpoch(0));
    }
    // cloud_firestore Timestamp
    try {
      final dynamic seconds = value.seconds;
      final dynamic nanoseconds = value.nanoseconds;
      if (seconds is int) {
        return DateTime.fromMillisecondsSinceEpoch(
          seconds * 1000 + ((nanoseconds as int?) ?? 0) ~/ 1000000,
          isUtc: true,
        );
      }
    } catch (_) {}
    return fallback ?? DateTime.fromMillisecondsSinceEpoch(0);
  }

  static DateTime? _parseDateOrNull(dynamic value) {
    if (value == null) return null;
    return _parseDate(value);
  }

  // ── Customers ──────────────────────────────────────────────

  static Map<String, dynamic> customerToMap(Customer c) => {
        'id': c.id,
        'fullName': c.fullName,
        'phoneNumber': c.phoneNumber,
        'whatsappNumber': c.whatsappNumber,
        'email': c.email,
        'address': c.address,
        'city': c.city,
        'notes': c.notes,
        'createdAt': _iso(c.createdAt),
        'updatedAt': _iso(c.updatedAt),
        'isArchived': c.isArchived,
      };

  static Customer customerFromMap(Map<String, dynamic> m) => Customer(
        id: m['id'] as String,
        fullName: m['fullName'] as String? ?? '',
        phoneNumber: m['phoneNumber'] as String? ?? '',
        whatsappNumber: m['whatsappNumber'] as String?,
        email: m['email'] as String?,
        address: m['address'] as String?,
        city: m['city'] as String?,
        notes: m['notes'] as String?,
        createdAt: _parseDate(m['createdAt']),
        updatedAt: _parseDate(m['updatedAt']),
        isArchived: m['isArchived'] as bool? ?? false,
      );

  // ── Vehicles ───────────────────────────────────────────────

  static Map<String, dynamic> vehicleToMap(Vehicle v) => {
        'id': v.id,
        'customerId': v.customerId,
        'make': v.make,
        'model': v.model,
        'variant': v.variant,
        'year': v.year,
        'registrationNumber': v.registrationNumber,
        'vinNumber': v.vinNumber,
        'engineNumber': v.engineNumber,
        'engineCapacity': v.engineCapacity,
        'fuelType': v.fuelType.name,
        'transmission': v.transmission.name,
        'color': v.color,
        'currentOdo': v.currentOdo,
        'purchaseDate': _iso(v.purchaseDate),
        'insuranceExpiry': _iso(v.insuranceExpiry),
        'registrationExpiry': _iso(v.registrationExpiry),
        'imagePath': v.imagePath,
        'notes': v.notes,
        'createdAt': _iso(v.createdAt),
        'updatedAt': _iso(v.updatedAt),
        'isArchived': v.isArchived,
      };

  static Vehicle vehicleFromMap(Map<String, dynamic> m) => Vehicle(
        id: m['id'] as String,
        customerId: m['customerId'] as String,
        make: m['make'] as String? ?? '',
        model: m['model'] as String? ?? '',
        variant: m['variant'] as String?,
        year: m['year'] as int?,
        registrationNumber: m['registrationNumber'] as String? ?? '',
        vinNumber: m['vinNumber'] as String?,
        engineNumber: m['engineNumber'] as String?,
        engineCapacity: m['engineCapacity'] as String?,
        fuelType: FuelType.fromStorage(m['fuelType'] as String? ?? 'petrol'),
        transmission: TransmissionType.fromStorage(
          m['transmission'] as String? ?? 'automatic',
        ),
        color: m['color'] as String?,
        currentOdo: m['currentOdo'] as int? ?? 0,
        purchaseDate: _parseDateOrNull(m['purchaseDate']),
        insuranceExpiry: _parseDateOrNull(m['insuranceExpiry']),
        registrationExpiry: _parseDateOrNull(m['registrationExpiry']),
        imagePath: m['imagePath'] as String?,
        notes: m['notes'] as String?,
        createdAt: _parseDate(m['createdAt']),
        updatedAt: _parseDate(m['updatedAt']),
        isArchived: m['isArchived'] as bool? ?? false,
      );

  // ── Service records ────────────────────────────────────────

  static Map<String, dynamic> serviceRecordToMap(ServiceRecord r) => {
        'id': r.id,
        'vehicleId': r.vehicleId,
        'serviceDate': _iso(r.serviceDate),
        'odometerReading': r.odometerReading,
        'serviceType': r.serviceType,
        'description': r.description,
        'oilBrand': r.oilBrand,
        'laborCost': r.laborCost,
        'partsCost': r.partsCost,
        'totalCost': r.totalCost,
        'notes': r.notes,
        'reminderType': r.reminderType?.name,
        'nextServiceOdometer': r.nextServiceOdometer,
        'nextServiceDate': _iso(r.nextServiceDate),
        'reminderEnabled': r.reminderEnabled,
        'whatsappEnabled': r.whatsappEnabled,
        'createdAt': _iso(r.createdAt),
        'updatedAt': _iso(r.updatedAt),
        'isArchived': r.isArchived,
      };

  static ServiceRecord serviceRecordFromMap(Map<String, dynamic> m) {
    final String? reminderType = m['reminderType'] as String?;
    return ServiceRecord(
      id: m['id'] as String,
      vehicleId: m['vehicleId'] as String,
      serviceDate: _parseDate(m['serviceDate']),
      odometerReading: m['odometerReading'] as int? ?? 0,
      serviceType: m['serviceType'] as String? ?? '',
      description: m['description'] as String?,
      oilBrand: m['oilBrand'] as String?,
      laborCost: (m['laborCost'] as num?)?.toDouble() ?? 0,
      partsCost: (m['partsCost'] as num?)?.toDouble() ?? 0,
      totalCost: (m['totalCost'] as num?)?.toDouble() ?? 0,
      notes: m['notes'] as String?,
      reminderType:
          reminderType == null ? null : ReminderType.fromStorage(reminderType),
      nextServiceOdometer: m['nextServiceOdometer'] as int?,
      nextServiceDate: _parseDateOrNull(m['nextServiceDate']),
      reminderEnabled: m['reminderEnabled'] as bool? ?? true,
      whatsappEnabled: m['whatsappEnabled'] as bool? ?? false,
      createdAt: _parseDate(m['createdAt']),
      updatedAt: _parseDate(m['updatedAt']),
      isArchived: m['isArchived'] as bool? ?? false,
    );
  }

  // ── Reminders ──────────────────────────────────────────────

  static Map<String, dynamic> reminderToMap(MaintenanceReminder r) => {
        'id': r.id,
        'vehicleId': r.vehicleId,
        'serviceRecordId': r.serviceRecordId,
        'currentOdometer': r.currentOdometer,
        'nextServiceOdometer': r.nextServiceOdometer,
        'lastServiceDate': _iso(r.lastServiceDate),
        'nextServiceDate': _iso(r.nextServiceDate),
        'reminderType': r.reminderType.name,
        'status': r.status.name,
        'lastReminderSent': _iso(r.lastReminderSent),
        'notificationEnabled': r.notificationEnabled,
        'whatsappEnabled': r.whatsappEnabled,
        'notes': r.notes,
        'createdAt': _iso(r.createdAt),
        'updatedAt': _iso(r.updatedAt),
      };

  static MaintenanceReminder reminderFromMap(Map<String, dynamic> m) =>
      MaintenanceReminder(
        id: m['id'] as String,
        vehicleId: m['vehicleId'] as String,
        serviceRecordId: m['serviceRecordId'] as String,
        currentOdometer: m['currentOdometer'] as int? ?? 0,
        nextServiceOdometer: m['nextServiceOdometer'] as int?,
        lastServiceDate: _parseDate(m['lastServiceDate']),
        nextServiceDate: _parseDateOrNull(m['nextServiceDate']),
        reminderType:
            ReminderType.fromStorage(m['reminderType'] as String? ?? 'both'),
        status: ReminderStatus.fromStorage(m['status'] as String? ?? 'upcoming'),
        lastReminderSent: _parseDateOrNull(m['lastReminderSent']),
        notificationEnabled: m['notificationEnabled'] as bool? ?? true,
        whatsappEnabled: m['whatsappEnabled'] as bool? ?? false,
        notes: m['notes'] as String?,
        createdAt: _parseDate(m['createdAt']),
        updatedAt: _parseDate(m['updatedAt']),
      );

  // ── Invoices ───────────────────────────────────────────────

  static Map<String, dynamic> invoiceToMap(Invoice i) => {
        'id': i.id,
        'serviceRecordId': i.serviceRecordId,
        'customerId': i.customerId,
        'vehicleId': i.vehicleId,
        'invoiceNumber': i.invoiceNumber,
        'invoiceDate': _iso(i.invoiceDate),
        'subtotal': i.subtotal,
        'discount': i.discount,
        'tax': i.tax,
        'grandTotal': i.grandTotal,
        'paymentMethod': i.paymentMethod.storageValue,
        'paymentStatus': i.paymentStatus.storageValue,
        'paidDate': _iso(i.paidDate),
        'currency': i.currency,
        'notes': i.notes,
        'labourDescription': i.labourDescription,
        'labourAmount': i.labourAmount,
        'partsDescription': i.partsDescription,
        'partsAmount': i.partsAmount,
        'serviceDescription': i.serviceDescription,
        'createdAt': _iso(i.createdAt),
        'updatedAt': _iso(i.updatedAt),
      };

  static Invoice invoiceFromMap(Map<String, dynamic> m) => Invoice(
        id: m['id'] as String,
        serviceRecordId: m['serviceRecordId'] as String?,
        customerId: m['customerId'] as String,
        vehicleId: m['vehicleId'] as String,
        invoiceNumber: m['invoiceNumber'] as String? ?? '',
        invoiceDate: _parseDate(m['invoiceDate']),
        subtotal: (m['subtotal'] as num?)?.toDouble() ?? 0,
        discount: (m['discount'] as num?)?.toDouble() ?? 0,
        tax: (m['tax'] as num?)?.toDouble() ?? 0,
        grandTotal: (m['grandTotal'] as num?)?.toDouble() ?? 0,
        paymentMethod: PaymentMethod.fromStorage(
          m['paymentMethod'] as String? ?? 'cash',
        ),
        paymentStatus: PaymentStatus.fromStorage(
          m['paymentStatus'] as String? ?? 'pending',
        ),
        paidDate: _parseDateOrNull(m['paidDate']),
        currency: m['currency'] as String? ?? 'USD',
        notes: m['notes'] as String?,
        labourDescription: m['labourDescription'] as String?,
        labourAmount: (m['labourAmount'] as num?)?.toDouble() ?? 0,
        partsDescription: m['partsDescription'] as String?,
        partsAmount: (m['partsAmount'] as num?)?.toDouble() ?? 0,
        serviceDescription: m['serviceDescription'] as String?,
        createdAt: _parseDate(m['createdAt']),
        updatedAt: _parseDate(m['updatedAt']),
      );

  // ── Inventory ──────────────────────────────────────────────

  static Map<String, dynamic> inventoryToMap(InventoryItem i) => {
        'id': i.id,
        'itemType': i.itemType.storageValue,
        'name': i.name,
        'description': i.description,
        'price': i.price,
        'quantityAvailable': i.quantityAvailable,
        'createdAt': _iso(i.createdAt),
        'updatedAt': _iso(i.updatedAt),
        'isArchived': i.isArchived,
      };

  static InventoryItem inventoryFromMap(Map<String, dynamic> m) =>
      InventoryItem(
        id: m['id'] as String,
        itemType: InventoryItemType.fromStorage(
          m['itemType'] as String? ?? 'part',
        ),
        name: m['name'] as String? ?? '',
        description: m['description'] as String?,
        price: (m['price'] as num?)?.toDouble() ?? 0,
        quantityAvailable: m['quantityAvailable'] as int? ?? 0,
        createdAt: _parseDate(m['createdAt']),
        updatedAt: _parseDate(m['updatedAt']),
        isArchived: m['isArchived'] as bool? ?? false,
      );

  // ── Message templates ──────────────────────────────────────

  static Map<String, dynamic> templateToMap(MessageTemplate t) => {
        'id': t.id,
        'name': t.name,
        'body': t.body,
        'category': t.category.storageValue,
        'isDefault': t.isDefault,
        'createdAt': _iso(t.createdAt),
        'updatedAt': _iso(t.updatedAt),
      };

  static MessageTemplate templateFromMap(Map<String, dynamic> m) =>
      MessageTemplate(
        id: m['id'] as String,
        name: m['name'] as String? ?? '',
        body: m['body'] as String? ?? '',
        category: MessageTemplateCategory.fromStorage(
          m['category'] as String? ?? 'custom',
        ),
        isDefault: m['isDefault'] as bool? ?? false,
        createdAt: _parseDate(m['createdAt']),
        updatedAt: _parseDate(m['updatedAt']),
      );

  // ── Maintenance logs ───────────────────────────────────────

  static Map<String, dynamic> maintenanceLogToMap(MaintenanceLog l) => {
        'id': l.id,
        'vehicleId': l.vehicleId,
        'note': l.note,
        'createdAt': _iso(l.createdAt),
        'updatedAt': _iso(l.createdAt),
      };

  static MaintenanceLog maintenanceLogFromMap(Map<String, dynamic> m) =>
      MaintenanceLog(
        id: m['id'] as String,
        vehicleId: m['vehicleId'] as String,
        note: m['note'] as String? ?? '',
        createdAt: _parseDate(m['createdAt']),
      );

  // ── Reminder history ───────────────────────────────────────

  static Map<String, dynamic> reminderHistoryToMap(ReminderHistoryEntry e) => {
        'id': e.id,
        'reminderId': e.reminderId,
        'vehicleId': e.vehicleId,
        'customerId': e.customerId,
        'actionType': e.actionType.storageValue,
        'title': e.title,
        'details': e.details,
        'createdAt': _iso(e.createdAt),
        'updatedAt': _iso(e.createdAt),
      };

  static ReminderHistoryEntry reminderHistoryFromMap(Map<String, dynamic> m) =>
      ReminderHistoryEntry(
        id: m['id'] as String,
        reminderId: m['reminderId'] as String?,
        vehicleId: m['vehicleId'] as String?,
        customerId: m['customerId'] as String?,
        actionType: ReminderHistoryAction.fromStorage(
          m['actionType'] as String? ?? 'reminder_sent',
        ),
        title: m['title'] as String?,
        details: m['details'] as String?,
        createdAt: _parseDate(m['createdAt']),
      );

  /// Prefer remote when remote is newer or equal (last-write-wins).
  static bool shouldApplyRemote({
    required DateTime? localUpdatedAt,
    required DateTime remoteUpdatedAt,
  }) {
    if (localUpdatedAt == null) return true;
    return !remoteUpdatedAt.isBefore(localUpdatedAt);
  }
}
