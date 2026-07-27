import 'package:drift/drift.dart';

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
import '../database/app_database.dart';
import 'sync_collections.dart';
import 'sync_serializers.dart';

/// Applies remote Firestore documents into the local Drift database.
class LocalSyncMirror {
  LocalSyncMirror(this._db);

  final AppDatabase _db;

  Future<void> applyRemoteDoc({
    required String collection,
    required Map<String, dynamic> data,
  }) async {
    final String documentId = data['id'] as String;
    if (SyncSerializers.isTombstone(data)) {
      await applyRemoteDelete(collection: collection, documentId: documentId);
      return;
    }

    switch (collection) {
      case SyncCollections.customers:
        await _applyCustomer(SyncSerializers.customerFromMap(data));
      case SyncCollections.vehicles:
        await _applyVehicle(SyncSerializers.vehicleFromMap(data));
      case SyncCollections.serviceRecords:
        await _applyServiceRecord(SyncSerializers.serviceRecordFromMap(data));
      case SyncCollections.maintenanceReminders:
        await _applyReminder(SyncSerializers.reminderFromMap(data));
      case SyncCollections.invoices:
        await _applyInvoice(SyncSerializers.invoiceFromMap(data));
      case SyncCollections.inventoryItems:
        await _applyInventory(SyncSerializers.inventoryFromMap(data));
      case SyncCollections.messageTemplates:
        await _applyTemplate(SyncSerializers.templateFromMap(data));
      case SyncCollections.maintenanceLogs:
        await _applyMaintenanceLog(SyncSerializers.maintenanceLogFromMap(data));
      case SyncCollections.reminderHistory:
        await _applyReminderHistory(
          SyncSerializers.reminderHistoryFromMap(data),
        );
    }
  }

  Future<void> applyRemoteDelete({
    required String collection,
    required String documentId,
  }) async {
    switch (collection) {
      case SyncCollections.customers:
        await (_db.delete(_db.customers)
              ..where((t) => t.id.equals(documentId)))
            .go();
      case SyncCollections.vehicles:
        await (_db.delete(_db.vehicles)..where((t) => t.id.equals(documentId)))
            .go();
      case SyncCollections.serviceRecords:
        await (_db.delete(_db.serviceRecords)
              ..where((t) => t.id.equals(documentId)))
            .go();
      case SyncCollections.maintenanceReminders:
        await (_db.delete(_db.maintenanceReminders)
              ..where((t) => t.id.equals(documentId)))
            .go();
      case SyncCollections.invoices:
        await (_db.delete(_db.invoices)..where((t) => t.id.equals(documentId)))
            .go();
      case SyncCollections.inventoryItems:
        await (_db.delete(_db.inventoryItems)
              ..where((t) => t.id.equals(documentId)))
            .go();
      case SyncCollections.messageTemplates:
        await (_db.delete(_db.messageTemplates)
              ..where((t) => t.id.equals(documentId)))
            .go();
      case SyncCollections.maintenanceLogs:
        await (_db.delete(_db.maintenanceLogs)
              ..where((t) => t.id.equals(documentId)))
            .go();
      case SyncCollections.reminderHistory:
        await (_db.delete(_db.reminderHistory)
              ..where((t) => t.id.equals(documentId)))
            .go();
    }
  }

  /// Local document ids for deletion reconciliation.
  Future<Set<String>> listLocalIds(String collection) async {
    switch (collection) {
      case SyncCollections.customers:
        return (await _db.select(_db.customers).get()).map((r) => r.id).toSet();
      case SyncCollections.vehicles:
        return (await _db.select(_db.vehicles).get()).map((r) => r.id).toSet();
      case SyncCollections.serviceRecords:
        return (await _db.select(_db.serviceRecords).get())
            .map((r) => r.id)
            .toSet();
      case SyncCollections.maintenanceReminders:
        return (await _db.select(_db.maintenanceReminders).get())
            .map((r) => r.id)
            .toSet();
      case SyncCollections.invoices:
        return (await _db.select(_db.invoices).get()).map((r) => r.id).toSet();
      case SyncCollections.inventoryItems:
        return (await _db.select(_db.inventoryItems).get())
            .map((r) => r.id)
            .toSet();
      case SyncCollections.messageTemplates:
        return (await _db.select(_db.messageTemplates).get())
            .map((r) => r.id)
            .toSet();
      case SyncCollections.maintenanceLogs:
        return (await _db.select(_db.maintenanceLogs).get())
            .map((r) => r.id)
            .toSet();
      case SyncCollections.reminderHistory:
        return (await _db.select(_db.reminderHistory).get())
            .map((r) => r.id)
            .toSet();
      default:
        return {};
    }
  }

  Future<DateTime?> localUpdatedAt(String collection, String id) async {
    switch (collection) {
      case SyncCollections.customers:
        final row = await (_db.select(_db.customers)
              ..where((t) => t.id.equals(id)))
            .getSingleOrNull();
        return row?.updatedAt;
      case SyncCollections.vehicles:
        final row = await (_db.select(_db.vehicles)
              ..where((t) => t.id.equals(id)))
            .getSingleOrNull();
        return row?.updatedAt;
      case SyncCollections.serviceRecords:
        final row = await (_db.select(_db.serviceRecords)
              ..where((t) => t.id.equals(id)))
            .getSingleOrNull();
        return row?.updatedAt;
      case SyncCollections.maintenanceReminders:
        final row = await (_db.select(_db.maintenanceReminders)
              ..where((t) => t.id.equals(id)))
            .getSingleOrNull();
        return row?.updatedAt;
      case SyncCollections.invoices:
        final row = await (_db.select(_db.invoices)
              ..where((t) => t.id.equals(id)))
            .getSingleOrNull();
        return row?.updatedAt;
      case SyncCollections.inventoryItems:
        final row = await (_db.select(_db.inventoryItems)
              ..where((t) => t.id.equals(id)))
            .getSingleOrNull();
        return row?.updatedAt;
      case SyncCollections.messageTemplates:
        final row = await (_db.select(_db.messageTemplates)
              ..where((t) => t.id.equals(id)))
            .getSingleOrNull();
        return row?.updatedAt;
      case SyncCollections.maintenanceLogs:
        final row = await (_db.select(_db.maintenanceLogs)
              ..where((t) => t.id.equals(id)))
            .getSingleOrNull();
        return row?.createdAt;
      case SyncCollections.reminderHistory:
        final row = await (_db.select(_db.reminderHistory)
              ..where((t) => t.id.equals(id)))
            .getSingleOrNull();
        return row?.createdAt;
      default:
        return null;
    }
  }

  /// Dump all local rows as sync maps for initial cloud seed.
  Future<Map<String, List<Map<String, dynamic>>>> exportAllLocal() async {
    final customers = await _db.select(_db.customers).get();
    final vehicles = await _db.select(_db.vehicles).get();
    final services = await _db.select(_db.serviceRecords).get();
    final reminders = await _db.select(_db.maintenanceReminders).get();
    final invoices = await _db.select(_db.invoices).get();
    final inventory = await _db.select(_db.inventoryItems).get();
    final templates = await _db.select(_db.messageTemplates).get();
    final logs = await _db.select(_db.maintenanceLogs).get();
    final history = await _db.select(_db.reminderHistory).get();

    return {
      SyncCollections.customers: [
        for (final r in customers)
          SyncSerializers.customerToMap(
            Customer(
              id: r.id,
              fullName: r.fullName,
              phoneNumber: r.phoneNumber,
              whatsappNumber: r.whatsappNumber,
              email: r.email,
              address: r.address,
              city: r.city,
              notes: r.notes,
              createdAt: r.createdAt,
              updatedAt: r.updatedAt,
              isArchived: r.isArchived,
            ),
          ),
      ],
      SyncCollections.vehicles: [
        for (final r in vehicles)
          SyncSerializers.vehicleToMap(
            Vehicle(
              id: r.id,
              customerId: r.customerId,
              make: r.make,
              model: r.model,
              variant: r.variant,
              year: r.year,
              registrationNumber: r.registrationNumber,
              vinNumber: r.vinNumber,
              engineNumber: r.engineNumber,
              engineCapacity: r.engineCapacity,
              fuelType: FuelType.fromStorage(r.fuelType),
              transmission: TransmissionType.fromStorage(r.transmission),
              color: r.color,
              currentOdo: r.currentOdo,
              purchaseDate: r.purchaseDate,
              insuranceExpiry: r.insuranceExpiry,
              registrationExpiry: r.registrationExpiry,
              imagePath: r.imagePath,
              notes: r.notes,
              createdAt: r.createdAt,
              updatedAt: r.updatedAt,
              isArchived: r.isArchived,
            ),
          ),
      ],
      SyncCollections.serviceRecords: [
        for (final r in services)
          SyncSerializers.serviceRecordToMap(
            ServiceRecord(
              id: r.id,
              vehicleId: r.vehicleId,
              serviceDate: r.serviceDate,
              odometerReading: r.odometerReading,
              serviceType: r.serviceType,
              description: r.description,
              oilBrand: r.oilBrand,
              laborCost: r.laborCost,
              partsCost: r.partsCost,
              totalCost: r.totalCost,
              notes: r.notes,
              reminderType: r.reminderType == null
                  ? null
                  : ReminderType.fromStorage(r.reminderType!),
              nextServiceOdometer: r.nextServiceOdometer,
              nextServiceDate: r.nextServiceDate,
              reminderEnabled: r.reminderEnabled,
              whatsappEnabled: r.whatsappEnabled,
              createdAt: r.createdAt,
              updatedAt: r.updatedAt,
              isArchived: r.isArchived,
            ),
          ),
      ],
      SyncCollections.maintenanceReminders: [
        for (final r in reminders)
          SyncSerializers.reminderToMap(
            MaintenanceReminder(
              id: r.id,
              vehicleId: r.vehicleId,
              serviceRecordId: r.serviceRecordId,
              currentOdometer: r.currentOdometer,
              nextServiceOdometer: r.nextServiceOdometer,
              lastServiceDate: r.lastServiceDate,
              nextServiceDate: r.nextServiceDate,
              reminderType: ReminderType.fromStorage(r.reminderType),
              status: ReminderStatus.fromStorage(r.status),
              lastReminderSent: r.lastReminderSent,
              notificationEnabled: r.notificationEnabled,
              whatsappEnabled: r.whatsappEnabled,
              notes: r.notes,
              createdAt: r.createdAt,
              updatedAt: r.updatedAt,
            ),
          ),
      ],
      SyncCollections.invoices: [
        for (final r in invoices)
          SyncSerializers.invoiceToMap(
            Invoice(
              id: r.id,
              serviceRecordId: r.serviceRecordId,
              customerId: r.customerId,
              vehicleId: r.vehicleId,
              invoiceNumber: r.invoiceNumber,
              invoiceDate: r.invoiceDate,
              subtotal: r.subtotal,
              discount: r.discount,
              tax: r.tax,
              grandTotal: r.grandTotal,
              paymentMethod: PaymentMethod.fromStorage(r.paymentMethod),
              paymentStatus: PaymentStatus.fromStorage(r.paymentStatus),
              paidDate: r.paidDate,
              currency: r.currency,
              notes: r.notes,
              labourDescription: r.labourDescription,
              labourAmount: r.labourAmount,
              partsDescription: r.partsDescription,
              partsAmount: r.partsAmount,
              serviceDescription: r.serviceDescription,
              createdAt: r.createdAt,
              updatedAt: r.updatedAt,
            ),
          ),
      ],
      SyncCollections.inventoryItems: [
        for (final r in inventory)
          SyncSerializers.inventoryToMap(
            InventoryItem(
              id: r.id,
              itemType: InventoryItemType.fromStorage(r.itemType),
              name: r.name,
              description: r.description,
              price: r.price,
              quantityAvailable: r.quantityAvailable,
              createdAt: r.createdAt,
              updatedAt: r.updatedAt,
              isArchived: r.isArchived,
            ),
          ),
      ],
      SyncCollections.messageTemplates: [
        for (final r in templates)
          SyncSerializers.templateToMap(
            MessageTemplate(
              id: r.id,
              name: r.name,
              body: r.body,
              category: MessageTemplateCategory.fromStorage(r.category),
              isDefault: r.isDefault,
              createdAt: r.createdAt,
              updatedAt: r.updatedAt,
            ),
          ),
      ],
      SyncCollections.maintenanceLogs: [
        for (final r in logs)
          SyncSerializers.maintenanceLogToMap(
            MaintenanceLog(
              id: r.id,
              vehicleId: r.vehicleId,
              note: r.note,
              createdAt: r.createdAt,
            ),
          ),
      ],
      SyncCollections.reminderHistory: [
        for (final r in history)
          SyncSerializers.reminderHistoryToMap(
            ReminderHistoryEntry(
              id: r.id,
              reminderId: r.reminderId,
              vehicleId: r.vehicleId,
              customerId: r.customerId,
              actionType: ReminderHistoryAction.fromStorage(r.actionType),
              title: r.title,
              details: r.details,
              createdAt: r.createdAt,
            ),
          ),
      ],
    };
  }

  Future<void> _applyCustomer(Customer c) async {
    final local = await localUpdatedAt(SyncCollections.customers, c.id);
    if (!SyncSerializers.shouldApplyRemote(
      localUpdatedAt: local,
      remoteUpdatedAt: c.updatedAt,
    )) {
      return;
    }
    await _db.into(_db.customers).insertOnConflictUpdate(
          CustomersCompanion(
            id: Value(c.id),
            fullName: Value(c.fullName),
            phoneNumber: Value(c.phoneNumber),
            whatsappNumber: Value(c.whatsappNumber),
            email: Value(c.email),
            address: Value(c.address),
            city: Value(c.city),
            notes: Value(c.notes),
            createdAt: Value(c.createdAt),
            updatedAt: Value(c.updatedAt),
            isArchived: Value(c.isArchived),
          ),
        );
  }

  Future<void> _applyVehicle(Vehicle v) async {
    final local = await localUpdatedAt(SyncCollections.vehicles, v.id);
    if (!SyncSerializers.shouldApplyRemote(
      localUpdatedAt: local,
      remoteUpdatedAt: v.updatedAt,
    )) {
      return;
    }
    await _db.into(_db.vehicles).insertOnConflictUpdate(
          VehiclesCompanion(
            id: Value(v.id),
            customerId: Value(v.customerId),
            make: Value(v.make),
            model: Value(v.model),
            variant: Value(v.variant),
            year: Value(v.year),
            registrationNumber: Value(v.registrationNumber),
            vinNumber: Value(v.vinNumber),
            engineNumber: Value(v.engineNumber),
            engineCapacity: Value(v.engineCapacity),
            fuelType: Value(v.fuelType.name),
            transmission: Value(v.transmission.name),
            color: Value(v.color),
            currentOdo: Value(v.currentOdo),
            purchaseDate: Value(v.purchaseDate),
            insuranceExpiry: Value(v.insuranceExpiry),
            registrationExpiry: Value(v.registrationExpiry),
            imagePath: Value(v.imagePath),
            notes: Value(v.notes),
            createdAt: Value(v.createdAt),
            updatedAt: Value(v.updatedAt),
            isArchived: Value(v.isArchived),
          ),
        );
  }

  Future<void> _applyServiceRecord(ServiceRecord r) async {
    final local = await localUpdatedAt(SyncCollections.serviceRecords, r.id);
    if (!SyncSerializers.shouldApplyRemote(
      localUpdatedAt: local,
      remoteUpdatedAt: r.updatedAt,
    )) {
      return;
    }
    await _db.into(_db.serviceRecords).insertOnConflictUpdate(
          ServiceRecordsCompanion(
            id: Value(r.id),
            vehicleId: Value(r.vehicleId),
            serviceDate: Value(r.serviceDate),
            odometerReading: Value(r.odometerReading),
            serviceType: Value(r.serviceType),
            description: Value(r.description),
            oilBrand: Value(r.oilBrand),
            laborCost: Value(r.laborCost),
            partsCost: Value(r.partsCost),
            totalCost: Value(r.totalCost),
            notes: Value(r.notes),
            reminderType: Value(r.reminderType?.name),
            nextServiceOdometer: Value(r.nextServiceOdometer),
            nextServiceDate: Value(r.nextServiceDate),
            reminderEnabled: Value(r.reminderEnabled),
            whatsappEnabled: Value(r.whatsappEnabled),
            createdAt: Value(r.createdAt),
            updatedAt: Value(r.updatedAt),
            isArchived: Value(r.isArchived),
          ),
        );
  }

  Future<void> _applyReminder(MaintenanceReminder r) async {
    final local =
        await localUpdatedAt(SyncCollections.maintenanceReminders, r.id);
    if (!SyncSerializers.shouldApplyRemote(
      localUpdatedAt: local,
      remoteUpdatedAt: r.updatedAt,
    )) {
      return;
    }
    await _db.into(_db.maintenanceReminders).insertOnConflictUpdate(
          MaintenanceRemindersCompanion(
            id: Value(r.id),
            vehicleId: Value(r.vehicleId),
            serviceRecordId: Value(r.serviceRecordId),
            currentOdometer: Value(r.currentOdometer),
            nextServiceOdometer: Value(r.nextServiceOdometer),
            lastServiceDate: Value(r.lastServiceDate),
            nextServiceDate: Value(r.nextServiceDate),
            reminderType: Value(r.reminderType.name),
            status: Value(r.status.name),
            lastReminderSent: Value(r.lastReminderSent),
            notificationEnabled: Value(r.notificationEnabled),
            whatsappEnabled: Value(r.whatsappEnabled),
            notes: Value(r.notes),
            createdAt: Value(r.createdAt),
            updatedAt: Value(r.updatedAt),
          ),
        );
  }

  Future<void> _applyInvoice(Invoice i) async {
    final local = await localUpdatedAt(SyncCollections.invoices, i.id);
    if (!SyncSerializers.shouldApplyRemote(
      localUpdatedAt: local,
      remoteUpdatedAt: i.updatedAt,
    )) {
      return;
    }
    await _db.into(_db.invoices).insertOnConflictUpdate(
          InvoicesCompanion(
            id: Value(i.id),
            serviceRecordId: Value(i.serviceRecordId),
            customerId: Value(i.customerId),
            vehicleId: Value(i.vehicleId),
            invoiceNumber: Value(i.invoiceNumber),
            invoiceDate: Value(i.invoiceDate),
            subtotal: Value(i.subtotal),
            discount: Value(i.discount),
            tax: Value(i.tax),
            grandTotal: Value(i.grandTotal),
            paymentMethod: Value(i.paymentMethod.storageValue),
            paymentStatus: Value(i.paymentStatus.storageValue),
            paidDate: Value(i.paidDate),
            currency: Value(i.currency),
            notes: Value(i.notes),
            labourDescription: Value(i.labourDescription),
            labourAmount: Value(i.labourAmount),
            partsDescription: Value(i.partsDescription),
            partsAmount: Value(i.partsAmount),
            serviceDescription: Value(i.serviceDescription),
            createdAt: Value(i.createdAt),
            updatedAt: Value(i.updatedAt),
          ),
        );
  }

  Future<void> _applyInventory(InventoryItem i) async {
    final local = await localUpdatedAt(SyncCollections.inventoryItems, i.id);
    if (!SyncSerializers.shouldApplyRemote(
      localUpdatedAt: local,
      remoteUpdatedAt: i.updatedAt,
    )) {
      return;
    }
    await _db.into(_db.inventoryItems).insertOnConflictUpdate(
          InventoryItemsCompanion(
            id: Value(i.id),
            itemType: Value(i.itemType.storageValue),
            name: Value(i.name),
            description: Value(i.description),
            price: Value(i.price),
            quantityAvailable: Value(i.quantityAvailable),
            createdAt: Value(i.createdAt),
            updatedAt: Value(i.updatedAt),
            isArchived: Value(i.isArchived),
          ),
        );
  }

  Future<void> _applyTemplate(MessageTemplate t) async {
    final local = await localUpdatedAt(SyncCollections.messageTemplates, t.id);
    if (!SyncSerializers.shouldApplyRemote(
      localUpdatedAt: local,
      remoteUpdatedAt: t.updatedAt,
    )) {
      return;
    }
    await _db.into(_db.messageTemplates).insertOnConflictUpdate(
          MessageTemplatesCompanion(
            id: Value(t.id),
            name: Value(t.name),
            body: Value(t.body),
            category: Value(t.category.storageValue),
            isDefault: Value(t.isDefault),
            createdAt: Value(t.createdAt),
            updatedAt: Value(t.updatedAt),
          ),
        );
  }

  Future<void> _applyMaintenanceLog(MaintenanceLog l) async {
    final local = await localUpdatedAt(SyncCollections.maintenanceLogs, l.id);
    if (!SyncSerializers.shouldApplyRemote(
      localUpdatedAt: local,
      remoteUpdatedAt: l.createdAt,
    )) {
      return;
    }
    await _db.into(_db.maintenanceLogs).insertOnConflictUpdate(
          MaintenanceLogsCompanion(
            id: Value(l.id),
            vehicleId: Value(l.vehicleId),
            note: Value(l.note),
            createdAt: Value(l.createdAt),
          ),
        );
  }

  Future<void> _applyReminderHistory(ReminderHistoryEntry e) async {
    final local = await localUpdatedAt(SyncCollections.reminderHistory, e.id);
    if (!SyncSerializers.shouldApplyRemote(
      localUpdatedAt: local,
      remoteUpdatedAt: e.createdAt,
    )) {
      return;
    }
    await _db.into(_db.reminderHistory).insertOnConflictUpdate(
          ReminderHistoryCompanion(
            id: Value(e.id),
            reminderId: Value(e.reminderId),
            vehicleId: Value(e.vehicleId),
            customerId: Value(e.customerId),
            actionType: Value(e.actionType.storageValue),
            title: Value(e.title),
            details: Value(e.details),
            createdAt: Value(e.createdAt),
          ),
        );
  }
}
