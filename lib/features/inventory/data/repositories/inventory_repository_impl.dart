import '../../../../core/errors/exceptions.dart';
import '../../../../core/sync/sync_collections.dart';
import '../../../../core/sync/sync_queue.dart';
import '../../../../core/sync/sync_serializers.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/inventory_item.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/inventory_local_datasource.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  InventoryRepositoryImpl(
    this._dataSource, [
    this._sync = const NoopSyncQueue(),
  ]);

  final InventoryLocalDataSource _dataSource;
  final SyncQueue _sync;

  Future<void> _enqueue(InventoryItem item) {
    return _sync.enqueueUpsert(
      SyncCollections.inventoryItems,
      item.id,
      SyncSerializers.inventoryToMap(item),
    );
  }

  @override
  Future<InventoryItem> createItem(InventoryItem item) async {
    try {
      final created = await _dataSource.insert(item);
      await _enqueue(created);
      AppLogger.info('Inventory item created: ${created.id}');
      return created;
    } on AppException {
      rethrow;
    } catch (e, st) {
      AppLogger.error('createItem failed', error: e, stackTrace: st);
      throw const DatabaseException('Failed to create inventory item');
    }
  }

  @override
  Future<InventoryItem> updateItem(InventoryItem item) async {
    try {
      final updated = await _dataSource.update(
        item.copyWith(updatedAt: DateTime.now()),
      );
      await _enqueue(updated);
      AppLogger.info('Inventory item updated: ${updated.id}');
      return updated;
    } on AppException {
      rethrow;
    } catch (e, st) {
      AppLogger.error('updateItem failed', error: e, stackTrace: st);
      throw const DatabaseException('Failed to update inventory item');
    }
  }

  @override
  Future<void> archiveItem(String id) async {
    try {
      await _dataSource.setArchived(id, archived: true);
      final item = await _dataSource.getById(id);
      if (item != null) await _enqueue(item);
      AppLogger.info('Inventory item archived: $id');
    } on AppException {
      rethrow;
    } catch (e, st) {
      AppLogger.error('archiveItem failed', error: e, stackTrace: st);
      throw const DatabaseException('Failed to archive inventory item');
    }
  }

  @override
  Future<InventoryItem?> getItemById(String id) => _dataSource.getById(id);

  @override
  Stream<List<InventoryItem>> watchActiveItems() => _dataSource.watchActive();
}
