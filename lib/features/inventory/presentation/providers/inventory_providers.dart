import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../shared/providers/database_provider.dart';
import '../../../../core/sync/sync_providers.dart';
import '../../data/datasources/inventory_local_datasource.dart';
import '../../data/repositories/inventory_repository_impl.dart';
import '../../domain/entities/inventory_item.dart';
import '../../domain/repositories/inventory_repository.dart';

const _uuid = Uuid();

final inventoryLocalDataSourceProvider = Provider<InventoryLocalDataSource>((
  ref,
) {
  return InventoryLocalDataSource(ref.watch(databaseProvider));
});

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  return InventoryRepositoryImpl(
    ref.watch(inventoryLocalDataSourceProvider),
    ref.watch(syncQueueProvider),
  );
});

final inventorySearchQueryProvider = StateProvider<String>((ref) => '');

/// null = all types
final inventoryTypeFilterProvider = StateProvider<InventoryItemType?>(
  (ref) => null,
);

final activeInventoryStreamProvider = StreamProvider<List<InventoryItem>>((
  ref,
) {
  return ref.watch(inventoryRepositoryProvider).watchActiveItems();
});

final filteredInventoryProvider = Provider<AsyncValue<List<InventoryItem>>>((
  ref,
) {
  final itemsAsync = ref.watch(activeInventoryStreamProvider);
  final query = ref.watch(inventorySearchQueryProvider).trim().toLowerCase();
  final typeFilter = ref.watch(inventoryTypeFilterProvider);

  return itemsAsync.whenData((list) {
    return list.where((item) {
      if (typeFilter != null && item.itemType != typeFilter) return false;
      if (query.isEmpty) return true;
      return item.name.toLowerCase().contains(query) ||
          (item.description?.toLowerCase().contains(query) ?? false);
    }).toList();
  });
});

class InventoryFormData extends Equatable {
  const InventoryFormData({
    required this.itemType,
    required this.name,
    this.description,
    required this.price,
    required this.quantityAvailable,
  });

  final InventoryItemType itemType;
  final String name;
  final String? description;
  final double price;
  final int quantityAvailable;

  @override
  List<Object?> get props => [
    itemType,
    name,
    description,
    price,
    quantityAvailable,
  ];
}

class InventoryActionState extends Equatable {
  const InventoryActionState({this.isLoading = false, this.errorMessage});

  final bool isLoading;
  final String? errorMessage;

  InventoryActionState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return InventoryActionState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [isLoading, errorMessage];
}

class InventoryActionsNotifier extends StateNotifier<InventoryActionState> {
  InventoryActionsNotifier(this._repository)
    : super(const InventoryActionState());

  final InventoryRepository _repository;

  Future<InventoryItem?> create(InventoryFormData data) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final now = DateTime.now();
      final item = InventoryItem(
        id: _uuid.v4(),
        itemType: data.itemType,
        name: data.name.trim(),
        description: _nullableTrim(data.description),
        price: data.price,
        quantityAvailable: data.quantityAvailable,
        createdAt: now,
        updatedAt: now,
      );
      final created = await _repository.createItem(item);
      state = state.copyWith(isLoading: false);
      return created;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e is AppException ? e.message : 'Something went wrong',
      );
      return null;
    }
  }

  Future<bool> archive(String id) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.archiveItem(id);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e is AppException ? e.message : 'Something went wrong',
      );
      return false;
    }
  }
}

final inventoryActionsProvider =
    StateNotifierProvider<InventoryActionsNotifier, InventoryActionState>((
      ref,
    ) {
      return InventoryActionsNotifier(ref.watch(inventoryRepositoryProvider));
    });

String? _nullableTrim(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  return trimmed;
}
