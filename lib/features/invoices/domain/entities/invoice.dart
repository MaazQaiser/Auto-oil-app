import 'package:equatable/equatable.dart';

import 'invoice_enums.dart';

class Invoice extends Equatable {
  const Invoice({
    required this.id,
    this.serviceRecordId,
    required this.customerId,
    required this.vehicleId,
    required this.invoiceNumber,
    required this.invoiceDate,
    this.subtotal = 0,
    this.discount = 0,
    this.tax = 0,
    this.grandTotal = 0,
    this.paymentMethod = PaymentMethod.cash,
    this.paymentStatus = PaymentStatus.pending,
    this.paidDate,
    this.currency = 'USD',
    this.notes,
    this.labourDescription,
    this.labourAmount = 0,
    this.partsDescription,
    this.partsAmount = 0,
    this.serviceDescription,
    required this.createdAt,
    required this.updatedAt,
    this.customerName,
    this.customerPhone,
    this.customerAddress,
    this.vehicleDisplayName,
    this.registrationNumber,
  });

  final String id;
  final String? serviceRecordId;
  final String customerId;
  final String vehicleId;
  final String invoiceNumber;
  final DateTime invoiceDate;
  final double subtotal;
  final double discount;
  final double tax;
  final double grandTotal;
  final PaymentMethod paymentMethod;
  final PaymentStatus paymentStatus;
  final DateTime? paidDate;
  final String currency;
  final String? notes;
  final String? labourDescription;
  final double labourAmount;
  final String? partsDescription;
  final double partsAmount;
  final String? serviceDescription;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Joined display fields.
  final String? customerName;
  final String? customerPhone;
  final String? customerAddress;
  final String? vehicleDisplayName;
  final String? registrationNumber;

  bool get isOutstanding =>
      paymentStatus == PaymentStatus.pending ||
      paymentStatus == PaymentStatus.partiallyPaid;

  Invoice copyWith({
    String? id,
    String? serviceRecordId,
    String? customerId,
    String? vehicleId,
    String? invoiceNumber,
    DateTime? invoiceDate,
    double? subtotal,
    double? discount,
    double? tax,
    double? grandTotal,
    PaymentMethod? paymentMethod,
    PaymentStatus? paymentStatus,
    DateTime? paidDate,
    String? currency,
    String? notes,
    String? labourDescription,
    double? labourAmount,
    String? partsDescription,
    double? partsAmount,
    String? serviceDescription,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? customerName,
    String? customerPhone,
    String? customerAddress,
    String? vehicleDisplayName,
    String? registrationNumber,
    bool clearPaidDate = false,
  }) {
    return Invoice(
      id: id ?? this.id,
      serviceRecordId: serviceRecordId ?? this.serviceRecordId,
      customerId: customerId ?? this.customerId,
      vehicleId: vehicleId ?? this.vehicleId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      grandTotal: grandTotal ?? this.grandTotal,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paidDate: clearPaidDate ? null : (paidDate ?? this.paidDate),
      currency: currency ?? this.currency,
      notes: notes ?? this.notes,
      labourDescription: labourDescription ?? this.labourDescription,
      labourAmount: labourAmount ?? this.labourAmount,
      partsDescription: partsDescription ?? this.partsDescription,
      partsAmount: partsAmount ?? this.partsAmount,
      serviceDescription: serviceDescription ?? this.serviceDescription,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerAddress: customerAddress ?? this.customerAddress,
      vehicleDisplayName: vehicleDisplayName ?? this.vehicleDisplayName,
      registrationNumber: registrationNumber ?? this.registrationNumber,
    );
  }

  @override
  List<Object?> get props => [
        id,
        serviceRecordId,
        customerId,
        vehicleId,
        invoiceNumber,
        invoiceDate,
        subtotal,
        discount,
        tax,
        grandTotal,
        paymentMethod,
        paymentStatus,
        paidDate,
        currency,
        notes,
        labourAmount,
        partsAmount,
        createdAt,
        updatedAt,
      ];
}
