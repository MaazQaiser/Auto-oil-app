import '../entities/vehicle.dart';

/// Contract for vehicle persistence operations.
abstract class VehicleRepository {
  Future<Vehicle> createVehicle(Vehicle vehicle);

  Future<Vehicle> updateVehicle(Vehicle vehicle);

  /// Soft-deletes a vehicle (sets [Vehicle.isArchived] to true).
  Future<void> deleteVehicle(String id);

  Future<void> archiveVehicle(String id);

  Future<void> restoreVehicle(String id);

  Future<Vehicle?> getVehicleById(String id);

  Future<List<Vehicle>> getVehiclesByCustomer(
    String customerId, {
    bool archived = false,
  });

  Future<List<Vehicle>> getAllVehicles({bool archived = false});

  Future<List<Vehicle>> searchVehicles(
    String query, {
    bool archived = false,
  });

  Stream<List<Vehicle>> watchActiveVehicles();

  Stream<List<Vehicle>> watchArchivedVehicles();

  Stream<List<Vehicle>> watchVehiclesByCustomer(String customerId);

  Future<bool> isRegistrationTaken(
    String registrationNumber, {
    String? excludeId,
  });

  Future<int> countActiveVehicles();

  Future<int> countVehiclesByCustomer(String customerId);
}
