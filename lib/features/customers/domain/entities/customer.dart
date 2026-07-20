import 'package:equatable/equatable.dart';

/// Domain entity representing a customer.
class Customer extends Equatable {
  const Customer({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    this.whatsappNumber,
    this.email,
    this.address,
    this.city,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.isArchived = false,
  });

  final String id;
  final String fullName;
  final String phoneNumber;
  final String? whatsappNumber;
  final String? email;
  final String? address;
  final String? city;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isArchived;

  /// First letter of the full name for avatar display.
  String get initials {
    final String trimmed = fullName.trim();
    if (trimmed.isEmpty) return '?';
    return trimmed[0].toUpperCase();
  }

  Customer copyWith({
    String? id,
    String? fullName,
    String? phoneNumber,
    String? whatsappNumber,
    String? email,
    String? address,
    String? city,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isArchived,
  }) {
    return Customer(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      whatsappNumber: whatsappNumber ?? this.whatsappNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      city: city ?? this.city,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        phoneNumber,
        whatsappNumber,
        email,
        address,
        city,
        notes,
        createdAt,
        updatedAt,
        isArchived,
      ];
}
