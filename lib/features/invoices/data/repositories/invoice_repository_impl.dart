import '../../../../core/sync/sync_collections.dart';
import '../../../../core/sync/sync_queue.dart';
import '../../../../core/sync/sync_serializers.dart';
import '../../domain/entities/invoice.dart';
import '../../domain/entities/invoice_enums.dart';
import '../../domain/repositories/invoice_repository.dart';
import '../datasources/invoice_local_datasource.dart';

class InvoiceRepositoryImpl implements InvoiceRepository {
  InvoiceRepositoryImpl(this._ds, [this._sync = const NoopSyncQueue()]);

  final InvoiceLocalDataSource _ds;
  final SyncQueue _sync;

  Future<void> _enqueue(Invoice invoice) {
    return _sync.enqueueUpsert(
      SyncCollections.invoices,
      invoice.id,
      SyncSerializers.invoiceToMap(invoice),
    );
  }

  @override
  Future<Invoice> create(Invoice invoice) async {
    final created = await _ds.insert(invoice);
    await _enqueue(created);
    return created;
  }

  @override
  Future<Invoice> update(Invoice invoice) async {
    final updated = await _ds.update(invoice);
    await _enqueue(updated);
    return updated;
  }

  @override
  Future<void> delete(String id) async {
    await _ds.delete(id);
    await _sync.enqueueDelete(SyncCollections.invoices, id);
  }

  @override
  Future<Invoice?> getById(String id) => _ds.getById(id);

  @override
  Stream<List<Invoice>> watchAll() => _ds.watchAll();

  @override
  Future<List<Invoice>> getRecent({int limit = 10}) =>
      _ds.getRecent(limit: limit);

  @override
  Future<List<Invoice>> search(String query) => _ds.search(query);

  @override
  Future<List<Invoice>> filter({
    DateTime? start,
    DateTime? end,
    PaymentStatus? status,
    String? customerId,
    String? vehicleId,
  }) =>
      _ds.filter(
        start: start,
        end: end,
        status: status,
        customerId: customerId,
        vehicleId: vehicleId,
      );

  @override
  Future<int> countAll() => _ds.countAll();

  @override
  Future<double> outstandingTotal() async {
    final pending = await _ds.sumByStatus(PaymentStatus.pending);
    final partial = await _ds.sumByStatus(PaymentStatus.partiallyPaid);
    return pending + partial;
  }

  @override
  Future<double> monthPaidRevenue(DateTime monthStart, DateTime monthEnd) =>
      _ds.sumPaidInRange(monthStart, monthEnd);
}
