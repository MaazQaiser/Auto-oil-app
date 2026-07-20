import '../entities/service_record.dart';

abstract class ServiceRecordRepository {
  Future<ServiceRecord> createServiceRecord(ServiceRecord record);

  Future<ServiceRecord> updateServiceRecord(ServiceRecord record);

  Future<void> deleteServiceRecord(String id);

  Future<ServiceRecord?> getById(String id);

  Future<List<ServiceRecord>> getByVehicle(String vehicleId);

  Stream<List<ServiceRecord>> watchByVehicle(String vehicleId);

  Future<double> totalRevenue();
}
