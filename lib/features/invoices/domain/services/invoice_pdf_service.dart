import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../entities/invoice.dart';

class InvoiceWorkshopInfo {
  const InvoiceWorkshopInfo({
    required this.name,
    this.address,
    this.phone,
    this.taxPercent = 0,
    this.currencySymbol = '\$',
  });

  final String name;
  final String? address;
  final String? phone;
  final double taxPercent;
  final String currencySymbol;
}

/// Builds a professional invoice PDF document.
class InvoicePdfService {
  Future<Uint8List> buildPdf({
    required Invoice invoice,
    required InvoiceWorkshopInfo workshop,
  }) async {
    final doc = pw.Document();
    final currency = NumberFormat.currency(symbol: workshop.currencySymbol);
    final dateFmt = DateFormat.yMMMMd();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        workshop.name,
                        style: pw.TextStyle(
                          fontSize: 22,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blue800,
                        ),
                      ),
                      if (workshop.address != null)
                        pw.Text(workshop.address!, style: const pw.TextStyle(fontSize: 10)),
                      if (workshop.phone != null)
                        pw.Text(workshop.phone!, style: const pw.TextStyle(fontSize: 10)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'INVOICE',
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text('No. ${invoice.invoiceNumber}'),
                      pw.Text(dateFmt.format(invoice.invoiceDate)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 24),
              pw.Divider(),
              pw.SizedBox(height: 12),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Bill To',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(invoice.customerName ?? 'Customer'),
                        if (invoice.customerPhone != null)
                          pw.Text(invoice.customerPhone!),
                        if (invoice.customerAddress != null &&
                            invoice.customerAddress!.isNotEmpty)
                          pw.Text(invoice.customerAddress!),
                      ],
                    ),
                  ),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Vehicle',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(invoice.vehicleDisplayName ?? 'Vehicle'),
                        if (invoice.registrationNumber != null)
                          pw.Text('Reg: ${invoice.registrationNumber}'),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 24),
              pw.TableHelper.fromTextArray(
                headers: ['Description', 'Amount'],
                data: [
                  [
                    invoice.serviceDescription ?? 'Service',
                    '',
                  ],
                  [
                    'Labour${invoice.labourDescription != null ? ' — ${invoice.labourDescription}' : ''}',
                    currency.format(invoice.labourAmount),
                  ],
                  [
                    'Parts${invoice.partsDescription != null ? ' — ${invoice.partsDescription}' : ''}',
                    currency.format(invoice.partsAmount),
                  ],
                ],
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
                cellAlignment: pw.Alignment.centerLeft,
                cellPadding: const pw.EdgeInsets.all(6),
              ),
              pw.SizedBox(height: 16),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.SizedBox(
                  width: 220,
                  child: pw.Column(
                    children: [
                      _totalRow('Subtotal', currency.format(invoice.subtotal)),
                      _totalRow('Discount', currency.format(invoice.discount)),
                      _totalRow('Tax', currency.format(invoice.tax)),
                      pw.Divider(),
                      _totalRow(
                        'Grand Total',
                        currency.format(invoice.grandTotal),
                        bold: true,
                      ),
                    ],
                  ),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Payment: ${invoice.paymentMethod.label} · ${invoice.paymentStatus.label}',
                style: const pw.TextStyle(fontSize: 11),
              ),
              if (invoice.notes != null && invoice.notes!.isNotEmpty) ...[
                pw.SizedBox(height: 8),
                pw.Text('Notes: ${invoice.notes}'),
              ],
              pw.Spacer(),
              pw.Divider(),
              pw.SizedBox(height: 8),
              pw.Center(
                child: pw.Text(
                  'Thank you for choosing ${workshop.name}. We appreciate your business.',
                  style: pw.TextStyle(
                    fontSize: 11,
                    fontStyle: pw.FontStyle.italic,
                    color: PdfColors.grey700,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ],
          );
        },
      ),
    );

    return doc.save();
  }

  pw.Widget _totalRow(String label, String value, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: bold
                ? pw.TextStyle(fontWeight: pw.FontWeight.bold)
                : const pw.TextStyle(),
          ),
          pw.Text(
            value,
            style: bold
                ? pw.TextStyle(fontWeight: pw.FontWeight.bold)
                : const pw.TextStyle(),
          ),
        ],
      ),
    );
  }
}
