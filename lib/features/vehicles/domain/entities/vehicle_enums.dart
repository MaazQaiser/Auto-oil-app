/// Supported fuel types for vehicles.
enum FuelType {
  petrol('Petrol'),
  diesel('Diesel'),
  hybrid('Hybrid'),
  electric('Electric');

  const FuelType(this.label);

  final String label;

  static FuelType fromStorage(String value) {
    return FuelType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => FuelType.petrol,
    );
  }
}

/// Supported transmission types for vehicles.
enum TransmissionType {
  automatic('Automatic'),
  manual('Manual'),
  cvt('CVT');

  const TransmissionType(this.label);

  final String label;

  static TransmissionType fromStorage(String value) {
    return TransmissionType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TransmissionType.automatic,
    );
  }
}
