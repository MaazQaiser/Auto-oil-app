import 'package:equatable/equatable.dart';

/// A single maintenance log note for a vehicle.
class MaintenanceLog extends Equatable {
  const MaintenanceLog({
    required this.id,
    required this.vehicleId,
    required this.note,
    required this.createdAt,
  });

  final String id;
  final String vehicleId;
  final String note;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, vehicleId, note, createdAt];
}
