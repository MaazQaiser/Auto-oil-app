import 'package:equatable/equatable.dart';

enum InventoryItemType {
  part,
  oil,
  service;

  String get label {
    switch (this) {
      case InventoryItemType.part:
        return 'Part';
      case InventoryItemType.oil:
        return 'Oil';
      case InventoryItemType.service:
        return 'Service';
    }
  }

  String get storageValue => name;

  static InventoryItemType fromStorage(String value) {
    return InventoryItemType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => InventoryItemType.part,
    );
  }
}

/// A catalog item (part, oil, or service) with price and stock.
class InventoryItem extends Equatable {
  const InventoryItem({
    required this.id,
    required this.itemType,
    required this.name,
    this.description,
    required this.price,
    required this.quantityAvailable,
    required this.createdAt,
    required this.updatedAt,
    this.isArchived = false,
  });

  final String id;
  final InventoryItemType itemType;
  final String name;
  final String? description;
  final double price;
  final int quantityAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isArchived;

  InventoryItem copyWith({
    String? id,
    InventoryItemType? itemType,
    String? name,
    String? description,
    double? price,
    int? quantityAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isArchived,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      itemType: itemType ?? this.itemType,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      quantityAvailable: quantityAvailable ?? this.quantityAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  @override
  List<Object?> get props => [
    id,
    itemType,
    name,
    description,
    price,
    quantityAvailable,
    createdAt,
    updatedAt,
    isArchived,
  ];
}
