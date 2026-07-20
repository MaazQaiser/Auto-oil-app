import 'package:equatable/equatable.dart';

import '../../../reminders/domain/entities/reminder_enums.dart';

/// A completed service / maintenance visit.
class ServiceRecord extends Equatable {
  const ServiceRecord({
    required this.id,
    required this.vehicleId,
    required this.serviceDate,
    required this.odometerReading,
    required this.serviceType,
    this.description,
    this.oilBrand,
    this.laborCost = 0,
    this.partsCost = 0,
    this.totalCost = 0,
    this.notes,
    this.reminderType,
    this.nextServiceOdometer,
    this.nextServiceDate,
    this.reminderEnabled = true,
    this.whatsappEnabled = false,
    required this.createdAt,
    required this.updatedAt,
    this.isArchived = false,
    this.vehicleDisplayName,
    this.registrationNumber,
    this.ownerName,
  });

  final String id;
  final String vehicleId;
  final DateTime serviceDate;
  final int odometerReading;
  final String serviceType;
  final String? description;
  final String? oilBrand;
  final double laborCost;
  final double partsCost;
  final double totalCost;
  final String? notes;
  final ReminderType? reminderType;
  final int? nextServiceOdometer;
  final DateTime? nextServiceDate;
  final bool reminderEnabled;
  final bool whatsappEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isArchived;
  final String? vehicleDisplayName;
  final String? registrationNumber;
  final String? ownerName;

  @override
  List<Object?> get props => [
        id,
        vehicleId,
        serviceDate,
        odometerReading,
        serviceType,
        description,
        oilBrand,
        laborCost,
        partsCost,
        totalCost,
        notes,
        reminderType,
        nextServiceOdometer,
        nextServiceDate,
        reminderEnabled,
        whatsappEnabled,
        createdAt,
        updatedAt,
        isArchived,
      ];
}
