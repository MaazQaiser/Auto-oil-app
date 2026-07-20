import 'dart:typed_data';

import 'package:csv/csv.dart' hide excel;
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/utils/logger.dart';
import '../../../customers/domain/entities/customer.dart';
import '../../../invoices/domain/entities/invoice.dart';
import '../../../reminders/domain/entities/maintenance_reminder.dart';
import '../../../service_records/domain/entities/service_record.dart';
import '../../../vehicles/domain/entities/vehicle.dart';

enum ExportFormat { pdf, csv, excel }

/// Exports lists and reports to CSV / Excel and shares via the OS sheet.
class ExportService {
  Future<void> shareBytes({
    required Uint8List bytes,
    required String filename,
    required String mimeType,
  }) async {
    await SharePlus.instance.share(
      ShareParams(
        files: [
          XFile.fromData(bytes, mimeType: mimeType, name: filename),
        ],
        fileNameOverrides: [filename],
      ),
    );
  }

  Future<void> exportInvoicesCsv(List<Invoice> invoices) async {
    final rows = <List<dynamic>>[
      [
        'Invoice Number',
        'Date',
        'Customer',
        'Vehicle',
        'Registration',
        'Subtotal',
        'Discount',
        'Tax',
        'Grand Total',
        'Payment Method',
        'Payment Status',
      ],
      for (final i in invoices)
        [
          i.invoiceNumber,
          DateFormat('yyyy-MM-dd').format(i.invoiceDate),
          i.customerName ?? '',
          i.vehicleDisplayName ?? '',
          i.registrationNumber ?? '',
          i.subtotal,
          i.discount,
          i.tax,
          i.grandTotal,
          i.paymentMethod.label,
          i.paymentStatus.label,
        ],
    ];
    final csvText = csv.encode(rows);
    await shareBytes(
      bytes: Uint8List.fromList(csvText.codeUnits),
      filename: 'invoices_export.csv',
      mimeType: 'text/csv',
    );
  }

  Future<void> exportInvoicesExcel(List<Invoice> invoices) async {
    final excel = Excel.createExcel();
    final sheet = excel['Invoices'];
    sheet.appendRow([
      TextCellValue('Invoice Number'),
      TextCellValue('Date'),
      TextCellValue('Customer'),
      TextCellValue('Vehicle'),
      TextCellValue('Grand Total'),
      TextCellValue('Status'),
    ]);
    for (final i in invoices) {
      sheet.appendRow([
        TextCellValue(i.invoiceNumber),
        TextCellValue(DateFormat('yyyy-MM-dd').format(i.invoiceDate)),
        TextCellValue(i.customerName ?? ''),
        TextCellValue(i.vehicleDisplayName ?? ''),
        DoubleCellValue(i.grandTotal),
        TextCellValue(i.paymentStatus.label),
      ]);
    }
    final bytes = excel.encode();
    if (bytes == null) {
      AppLogger.warning('Excel encode returned null');
      return;
    }
    await shareBytes(
      bytes: Uint8List.fromList(bytes),
      filename: 'invoices_export.xlsx',
      mimeType:
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    );
  }

  Future<void> exportCustomersCsv(List<Customer> customers) async {
    final rows = <List<dynamic>>[
      ['Name', 'Phone', 'Email', 'City', 'Created'],
      for (final c in customers)
        [
          c.fullName,
          c.phoneNumber,
          c.email ?? '',
          c.city ?? '',
          DateFormat('yyyy-MM-dd').format(c.createdAt),
        ],
    ];
    final csvText = csv.encode(rows);
    await shareBytes(
      bytes: Uint8List.fromList(csvText.codeUnits),
      filename: 'customers_export.csv',
      mimeType: 'text/csv',
    );
  }

  Future<void> exportVehiclesCsv(List<Vehicle> vehicles) async {
    final rows = <List<dynamic>>[
      ['Make', 'Model', 'Registration', 'ODO', 'Owner'],
      for (final v in vehicles)
        [
          v.make,
          v.model,
          v.registrationNumber,
          v.currentOdo,
          v.ownerName ?? '',
        ],
    ];
    final csvText = csv.encode(rows);
    await shareBytes(
      bytes: Uint8List.fromList(csvText.codeUnits),
      filename: 'vehicles_export.csv',
      mimeType: 'text/csv',
    );
  }

  Future<void> exportServicesCsv(List<ServiceRecord> services) async {
    final rows = <List<dynamic>>[
      ['Date', 'Type', 'Vehicle', 'ODO', 'Labour', 'Parts', 'Total'],
      for (final s in services)
        [
          DateFormat('yyyy-MM-dd').format(s.serviceDate),
          s.serviceType,
          s.vehicleDisplayName ?? '',
          s.odometerReading,
          s.laborCost,
          s.partsCost,
          s.totalCost,
        ],
    ];
    final csvText = csv.encode(rows);
    await shareBytes(
      bytes: Uint8List.fromList(csvText.codeUnits),
      filename: 'services_export.csv',
      mimeType: 'text/csv',
    );
  }

  Future<void> exportRemindersCsv(List<MaintenanceReminder> reminders) async {
    final rows = <List<dynamic>>[
      ['Vehicle', 'Registration', 'Owner', 'Status', 'Due Date', 'Remaining KM'],
      for (final r in reminders)
        [
          r.vehicleDisplayName ?? '',
          r.registrationNumber ?? '',
          r.ownerName ?? '',
          r.status.name,
          r.nextServiceDate == null
              ? ''
              : DateFormat('yyyy-MM-dd').format(r.nextServiceDate!),
          r.remainingKm ?? '',
        ],
    ];
    final csvText = csv.encode(rows);
    await shareBytes(
      bytes: Uint8List.fromList(csvText.codeUnits),
      filename: 'reminders_export.csv',
      mimeType: 'text/csv',
    );
  }

  Future<void> exportRevenueSummaryCsv({
    required double today,
    required double week,
    required double month,
    required double year,
  }) async {
    final rows = [
      ['Metric', 'Amount'],
      ["Today's Revenue", today],
      ['Weekly Revenue', week],
      ['Monthly Revenue', month],
      ['Yearly Revenue', year],
    ];
    final csvText = csv.encode(rows);
    await shareBytes(
      bytes: Uint8List.fromList(csvText.codeUnits),
      filename: 'revenue_report.csv',
      mimeType: 'text/csv',
    );
  }
}
