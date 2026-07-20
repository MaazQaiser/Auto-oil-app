import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/services/settings_service.dart';
import '../../../../shared/providers/database_provider.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../../service_records/domain/entities/service_record.dart';
import '../../../settings/providers/settings_provider.dart';
import '../../../vehicles/presentation/providers/vehicle_providers.dart';
import '../../data/datasources/invoice_local_datasource.dart';
import '../../data/repositories/invoice_repository_impl.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_enums.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../../domain/services/invoice_pdf_service.dart';

final invoiceLocalDataSourceProvider = Provider<InvoiceLocalDataSource>((ref) {
  return InvoiceLocalDataSource(ref.watch(databaseProvider));
});

final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  return InvoiceRepositoryImpl(
    ref.watch(invoiceLocalDataSourceProvider),
    ref.watch(syncQueueProvider),
  );
});

final invoicePdfServiceProvider = Provider<InvoicePdfService>((ref) {
  return InvoicePdfService();
});

final allInvoicesStreamProvider = StreamProvider<List<Invoice>>((ref) {
  return ref.watch(invoiceRepositoryProvider).watchAll();
});

final recentInvoicesProvider = FutureProvider<List<Invoice>>((ref) async {
  ref.watch(allInvoicesStreamProvider);
  return ref.watch(invoiceRepositoryProvider).getRecent(limit: 8);
});

final outstandingPaymentsProvider = FutureProvider<double>((ref) async {
  ref.watch(allInvoicesStreamProvider);
  return ref.watch(invoiceRepositoryProvider).outstandingTotal();
});

final monthInvoiceRevenueProvider = FutureProvider<double>((ref) async {
  ref.watch(allInvoicesStreamProvider);
  final now = DateTime.now();
  final start = DateTime(now.year, now.month);
  final end = DateTime(now.year, now.month + 1);
  return ref.watch(invoiceRepositoryProvider).monthPaidRevenue(start, end);
});

final invoiceSearchQueryProvider = StateProvider<String>((ref) => '');

final invoiceStatusFilterProvider =
    StateProvider<PaymentStatus?>((ref) => null);

final invoiceDateRangeProvider =
    StateProvider<({DateTime? start, DateTime? end})?>(
  (ref) => null,
);

final filteredInvoicesProvider =
    Provider<AsyncValue<List<Invoice>>>((ref) {
  final all = ref.watch(allInvoicesStreamProvider);
  final query = ref.watch(invoiceSearchQueryProvider).trim().toLowerCase();
  final status = ref.watch(invoiceStatusFilterProvider);
  final range = ref.watch(invoiceDateRangeProvider);

  return all.whenData((list) {
    Iterable<Invoice> result = list;
    if (status != null) {
      result = result.where((i) => i.paymentStatus == status);
    }
    if (range?.start != null) {
      result = result.where(
        (i) => !i.invoiceDate.isBefore(range!.start!),
      );
    }
    if (range?.end != null) {
      result = result.where((i) => i.invoiceDate.isBefore(range!.end!));
    }
    if (query.isNotEmpty) {
      result = result.where((i) {
        return i.invoiceNumber.toLowerCase().contains(query) ||
            (i.customerName?.toLowerCase().contains(query) ?? false) ||
            (i.vehicleDisplayName?.toLowerCase().contains(query) ?? false) ||
            (i.registrationNumber?.toLowerCase().contains(query) ?? false);
      });
    }
    return result.toList();
  });
});

final invoiceByIdProvider =
    FutureProvider.family<Invoice?, String>((ref, id) async {
  ref.watch(allInvoicesStreamProvider);
  return ref.watch(invoiceRepositoryProvider).getById(id);
});

class InvoiceActionsNotifier extends StateNotifier<AsyncValue<void>> {
  InvoiceActionsNotifier(this._repo, this._settings)
      : super(const AsyncData(null));

  final InvoiceRepository _repo;
  final SettingsService _settings;
  static const Uuid _uuid = Uuid();

  InvoiceWorkshopInfo workshopInfo() {
    return InvoiceWorkshopInfo(
      name: _settings.workshopDisplayName,
      address: _settings.workshopAddress.isEmpty
          ? null
          : _settings.workshopAddress,
      phone:
          _settings.workshopPhone.isEmpty ? null : _settings.workshopPhone,
      taxPercent: _settings.invoiceTaxPercent,
      currencySymbol: _settings.invoiceCurrencySymbol,
    );
  }

  Future<Invoice?> createInvoice({
    required String customerId,
    required String vehicleId,
    String? serviceRecordId,
    required String serviceDescription,
    required double labourAmount,
    required double partsAmount,
    String? labourDescription,
    String? partsDescription,
    double discount = 0,
    PaymentMethod method = PaymentMethod.cash,
    PaymentStatus status = PaymentStatus.pending,
    String? notes,
  }) async {
    state = const AsyncLoading();
    try {
      final subtotal = labourAmount + partsAmount;
      final taxable = (subtotal - discount).clamp(0, double.infinity);
      final tax = taxable * (_settings.invoiceTaxPercent / 100);
      final grand = taxable + tax;
      final number = await _settings.allocateInvoiceNumber();
      final now = DateTime.now();

      final invoice = Invoice(
        id: _uuid.v4(),
        serviceRecordId: serviceRecordId,
        customerId: customerId,
        vehicleId: vehicleId,
        invoiceNumber: number,
        invoiceDate: now,
        subtotal: subtotal,
        discount: discount,
        tax: tax,
        grandTotal: grand,
        paymentMethod: method,
        paymentStatus: status,
        paidDate: status == PaymentStatus.paid ? now : null,
        currency: _settings.invoiceCurrency,
        notes: notes,
        labourDescription: labourDescription ?? 'Labour',
        labourAmount: labourAmount,
        partsDescription: partsDescription ?? 'Parts',
        partsAmount: partsAmount,
        serviceDescription: serviceDescription,
        createdAt: now,
        updatedAt: now,
      );

      final created = await _repo.create(invoice);
      state = const AsyncData(null);
      return created;
    } catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }

  Future<bool> markPaid(Invoice invoice) async {
    state = const AsyncLoading();
    try {
      await _repo.update(
        invoice.copyWith(
          paymentStatus: PaymentStatus.paid,
          paidDate: DateTime.now(),
        ),
      );
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  Future<bool> updateInvoice(Invoice invoice) async {
    state = const AsyncLoading();
    try {
      await _repo.update(invoice);
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final invoiceActionsProvider =
    StateNotifierProvider<InvoiceActionsNotifier, AsyncValue<void>>((ref) {
  return InvoiceActionsNotifier(
    ref.watch(invoiceRepositoryProvider),
    ref.watch(settingsServiceProvider),
  );
});

/// Helper to create invoice from an existing service record.
final createInvoiceFromServiceProvider =
    Provider<Future<Invoice?> Function(ServiceRecord)>((ref) {
  return (ServiceRecord record) async {
    final vehicle = await ref
        .read(vehicleRepositoryProvider)
        .getVehicleById(record.vehicleId);
    if (vehicle == null) return null;
    return ref.read(invoiceActionsProvider.notifier).createInvoice(
          customerId: vehicle.customerId,
          vehicleId: record.vehicleId,
          serviceRecordId: record.id,
          serviceDescription: record.serviceType,
          labourAmount: record.laborCost,
          partsAmount: record.partsCost,
          labourDescription: 'Labour',
          partsDescription: record.oilBrand != null
              ? 'Parts / Oil (${record.oilBrand})'
              : 'Parts',
          notes: record.notes,
          status: PaymentStatus.pending,
        );
  };
});
