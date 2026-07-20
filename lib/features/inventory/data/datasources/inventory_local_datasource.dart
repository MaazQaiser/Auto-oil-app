import 'package:drift/drift.dart';

import '../../../../core/database/app_database.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/inventory_item.dart';

class InventoryLocalDataSource {
  InventoryLocalDataSource(this._db);

  final AppDatabase _db;

  InventoryItem _toEntity(InventoryItemRow row) {
    return InventoryItem(
      id: row.id,
      itemType: InventoryItemType.fromStorage(row.itemType),
      name: row.name,
      description: row.description,
      price: row.price,
      quantityAvailable: row.quantityAvailable,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      isArchived: row.isArchived,
    );
  }

  InventoryItemsCompanion _toCompanion(InventoryItem item) {
    return InventoryItemsCompanion(
      id: Value(item.id),
      itemType: Value(item.itemType.storageValue),
      name: Value(item.name),
      description: Value(item.description),
      price: Value(item.price),
      quantityAvailable: Value(item.quantityAvailable),
      createdAt: Value(item.createdAt),
      updatedAt: Value(item.updatedAt),
      isArchived: Value(item.isArchived),
    );
  }

  Future<InventoryItem> insert(InventoryItem item) async {
    try {
      await _db.into(_db.inventoryItems).insert(_toCompanion(item));
      return item;
    } catch (e) {
      throw DatabaseException('Failed to create inventory item: $e');
    }
  }

  Future<InventoryItem> update(InventoryItem item) async {
    try {
      final int updated = await (_db.update(
        _db.inventoryItems,
      )..where((t) => t.id.equals(item.id))).write(_toCompanion(item));
      if (updated == 0) {
        throw const NotFoundException('Inventory item not found');
      }
      return item;
    } on NotFoundException {
      rethrow;
    } catch (e) {
      throw DatabaseException('Failed to update inventory item: $e');
    }
  }

  Future<void> setArchived(String id, {required bool archived}) async {
    try {
      final int updated =
          await (_db.update(
            _db.inventoryItems,
          )..where((t) => t.id.equals(id))).write(
            InventoryItemsCompanion(
              isArchived: Value(archived),
              updatedAt: Value(DateTime.now()),
            ),
          );
      if (updated == 0) {
        throw const NotFoundException('Inventory item not found');
      }
    } on NotFoundException {
      rethrow;
    } catch (e) {
      throw DatabaseException('Failed to archive inventory item: $e');
    }
  }

  Future<InventoryItem?> getById(String id) async {
    try {
      final query = _db.select(_db.inventoryItems)
        ..where((t) => t.id.equals(id));
      final InventoryItemRow? row = await query.getSingleOrNull();
      return row == null ? null : _toEntity(row);
    } catch (e) {
      throw DatabaseException('Failed to get inventory item: $e');
    }
  }

  Stream<List<InventoryItem>> watchActive() {
    final query = _db.select(_db.inventoryItems)
      ..where((t) => t.isArchived.equals(false))
      ..orderBy([(t) => OrderingTerm.asc(t.name)]);
    return query.watch().map((rows) => rows.map(_toEntity).toList());
  }
}
