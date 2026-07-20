import 'package:equatable/equatable.dart';

import '../../../reminders/domain/entities/maintenance_reminder.dart';

/// Placeholder keys for WhatsApp / notification message templates.
class MessagePlaceholders {
  const MessagePlaceholders._();

  static const String customerName = 'CustomerName';
  static const String workshopName = 'WorkshopName';
  static const String vehicle = 'Vehicle';
  static const String registration = 'Registration';
  static const String lastServiceDate = 'LastServiceDate';
  static const String nextServiceDate = 'NextServiceDate';
  static const String remainingKm = 'RemainingKM';
  static const String remainingDays = 'RemainingDays';

  static const List<String> all = [
    customerName,
    workshopName,
    vehicle,
    registration,
    lastServiceDate,
    nextServiceDate,
    remainingKm,
    remainingDays,
  ];

  static String wrap(String key) => '{{$key}}';
}

/// Values used to fill a message template for a reminder.
class MessageContext extends Equatable {
  const MessageContext({
    required this.customerName,
    required this.workshopName,
    required this.vehicle,
    required this.registration,
    required this.lastServiceDate,
    this.nextServiceDate,
    this.remainingKm,
    this.remainingDays,
    this.phoneNumber,
    this.whatsappNumber,
    this.reminderId,
    this.vehicleId,
    this.customerId,
  });

  final String customerName;
  final String workshopName;
  final String vehicle;
  final String registration;
  final String lastServiceDate;
  final String? nextServiceDate;
  final String? remainingKm;
  final String? remainingDays;
  final String? phoneNumber;
  final String? whatsappNumber;
  final String? reminderId;
  final String? vehicleId;
  final String? customerId;

  String get preferredPhone =>
      (whatsappNumber?.trim().isNotEmpty == true)
          ? whatsappNumber!.trim()
          : (phoneNumber ?? '');

  Map<String, String> toMap() => {
        MessagePlaceholders.customerName: customerName,
        MessagePlaceholders.workshopName: workshopName,
        MessagePlaceholders.vehicle: vehicle,
        MessagePlaceholders.registration: registration,
        MessagePlaceholders.lastServiceDate: lastServiceDate,
        MessagePlaceholders.nextServiceDate: nextServiceDate ?? '—',
        MessagePlaceholders.remainingKm: remainingKm ?? '—',
        MessagePlaceholders.remainingDays: remainingDays ?? '—',
      };

  static MessageContext fromReminder({
    required MaintenanceReminder reminder,
    required String workshopName,
    String? phoneNumber,
    String? whatsappNumber,
  }) {
    return MessageContext(
      customerName: reminder.ownerName ?? 'Customer',
      workshopName: workshopName,
      vehicle: reminder.vehicleDisplayName ?? 'Vehicle',
      registration: reminder.registrationNumber ?? '—',
      lastServiceDate: _fmt(reminder.lastServiceDate),
      nextServiceDate: reminder.nextServiceDate == null
          ? null
          : _fmt(reminder.nextServiceDate!),
      remainingKm: reminder.remainingKm?.toString(),
      remainingDays: reminder.remainingDays?.toString(),
      phoneNumber: phoneNumber,
      whatsappNumber: whatsappNumber,
      reminderId: reminder.id,
      vehicleId: reminder.vehicleId,
      customerId: reminder.customerId,
    );
  }

  static String _fmt(DateTime d) {
    final String month = d.month.toString().padLeft(2, '0');
    final String day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$month-$day';
  }

  @override
  List<Object?> get props => [
        customerName,
        workshopName,
        vehicle,
        registration,
        lastServiceDate,
        nextServiceDate,
        remainingKm,
        remainingDays,
        phoneNumber,
        whatsappNumber,
        reminderId,
        vehicleId,
        customerId,
      ];
}

/// Default WhatsApp reminder body.
const String kDefaultWhatsAppTemplate = '''
Hello {{CustomerName}},

This is a friendly reminder from {{WorkshopName}}.

Your vehicle:
{{Vehicle}}

Registration:
{{Registration}}

is now due for its scheduled maintenance.

Last Service:
{{LastServiceDate}}

Recommended Service:
{{NextServiceDate}}

Please contact us to book your next appointment.

Thank you.
''';
