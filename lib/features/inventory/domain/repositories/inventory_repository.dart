import '../entities/inventory_item.dart';

abstract class InventoryRepository {
  Future<InventoryItem> createItem(InventoryItem item);

  Future<InventoryItem> updateItem(InventoryItem item);

  Future<void> archiveItem(String id);

  Future<InventoryItem?> getItemById(String id);

  Stream<List<InventoryItem>> watchActiveItems();
}
