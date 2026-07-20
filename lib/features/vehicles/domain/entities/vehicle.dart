import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import 'vehicle_enums.dart';

/// Domain entity representing a vehicle owned by a customer.
class Vehicle extends Equatable {
  const Vehicle({
    required this.id,
    required this.customerId,
    required this.make,
    required this.model,
    this.variant,
    this.year,
    required this.registrationNumber,
    this.vinNumber,
    this.engineNumber,
    this.engineCapacity,
    required this.fuelType,
    required this.transmission,
    this.color,
    required this.currentOdo,
    this.purchaseDate,
    this.insuranceExpiry,
    this.registrationExpiry,
    this.imagePath,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.isArchived = false,
    this.ownerName,
  });

  final String id;
  final String customerId;
  final String make;
  final String model;
  final String? variant;
  final int? year;
  final String registrationNumber;
  final String? vinNumber;
  final String? engineNumber;
  final String? engineCapacity;
  final FuelType fuelType;
  final TransmissionType transmission;
  final String? color;
  final int currentOdo;
  final DateTime? purchaseDate;
  final DateTime? insuranceExpiry;
  final DateTime? registrationExpiry;
  final String? imagePath;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isArchived;

  /// Optional joined owner name for list/detail display.
  final String? ownerName;

  String get displayName {
    final String base = '$make $model'.trim();
    if (variant == null || variant!.isEmpty) return base;
    return '$base $variant';
  }

  String get formattedOdo {
    final NumberFormat formatter = NumberFormat('#,###');
    return '${formatter.format(currentOdo)} KM';
  }

  /// Placeholder until service records exist in Phase 4.
  String get serviceSummary => 'No Service History';

  Vehicle copyWith({
    String? id,
    String? customerId,
    String? make,
    String? model,
    String? variant,
    int? year,
    String? registrationNumber,
    String? vinNumber,
    String? engineNumber,
    String? engineCapacity,
    FuelType? fuelType,
    TransmissionType? transmission,
    String? color,
    int? currentOdo,
    DateTime? purchaseDate,
    DateTime? insuranceExpiry,
    DateTime? registrationExpiry,
    String? imagePath,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isArchived,
    String? ownerName,
  }) {
    return Vehicle(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      make: make ?? this.make,
      model: model ?? this.model,
      variant: variant ?? this.variant,
      year: year ?? this.year,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      vinNumber: vinNumber ?? this.vinNumber,
      engineNumber: engineNumber ?? this.engineNumber,
      engineCapacity: engineCapacity ?? this.engineCapacity,
      fuelType: fuelType ?? this.fuelType,
      transmission: transmission ?? this.transmission,
      color: color ?? this.color,
      currentOdo: currentOdo ?? this.currentOdo,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      insuranceExpiry: insuranceExpiry ?? this.insuranceExpiry,
      registrationExpiry: registrationExpiry ?? this.registrationExpiry,
      imagePath: imagePath ?? this.imagePath,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
      ownerName: ownerName ?? this.ownerName,
    );
  }

  @override
  List<Object?> get props => [
        id,
        customerId,
        make,
        model,
        variant,
        year,
        registrationNumber,
        vinNumber,
        engineNumber,
        engineCapacity,
        fuelType,
        transmission,
        color,
        currentOdo,
        purchaseDate,
        insuranceExpiry,
        registrationExpiry,
        imagePath,
        notes,
        createdAt,
        updatedAt,
        isArchived,
        ownerName,
      ];
}
