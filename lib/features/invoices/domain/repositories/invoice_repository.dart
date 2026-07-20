import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_enums.dart';

abstract class InvoiceRepository {
  Future<Invoice> create(Invoice invoice);
  Future<Invoice> update(Invoice invoice);
  Future<void> delete(String id);
  Future<Invoice?> getById(String id);
  Stream<List<Invoice>> watchAll();
  Future<List<Invoice>> getRecent({int limit = 10});
  Future<List<Invoice>> search(String query);
  Future<List<Invoice>> filter({
    DateTime? start,
    DateTime? end,
    PaymentStatus? status,
    String? customerId,
    String? vehicleId,
  });
  Future<int> countAll();
  Future<double> outstandingTotal();
  Future<double> monthPaidRevenue(DateTime monthStart, DateTime monthEnd);
}
