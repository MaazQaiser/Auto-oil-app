import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../shared/providers/database_provider.dart';
import 'firestore_remote_datasource.dart';
import 'local_sync_mirror.dart';
import 'sync_engine.dart';
import 'sync_outbox_datasource.dart';
import 'sync_queue.dart';

final syncOutboxDataSourceProvider = Provider<SyncOutboxDataSource>((ref) {
  return SyncOutboxDataSource(ref.watch(databaseProvider));
});

final firestoreRemoteDataSourceProvider =
    Provider<FirestoreRemoteDataSource>((ref) {
  return FirestoreRemoteDataSource();
});

final localSyncMirrorProvider = Provider<LocalSyncMirror>((ref) {
  return LocalSyncMirror(ref.watch(databaseProvider));
});

final syncEngineProvider = Provider<SyncEngine>((ref) {
  final engine = SyncEngine(
    outbox: ref.watch(syncOutboxDataSourceProvider),
    remote: ref.watch(firestoreRemoteDataSourceProvider),
    mirror: ref.watch(localSyncMirrorProvider),
  );
  ref.onDispose(engine.dispose);
  return engine;
});

/// Prefer [syncEngineProvider] when authenticated; otherwise a no-op queue.
final syncQueueProvider = Provider<SyncQueue>((ref) {
  final auth = ref.watch(authStateProvider);
  return auth.maybeWhen(
    data: (user) => user == null
        ? const NoopSyncQueue()
        : ref.watch(syncEngineProvider),
    orElse: () => const NoopSyncQueue(),
  );
});

/// Starts connectivity listeners and runs sync when the user is signed in.
final syncBootstrapProvider = Provider<void>((ref) {
  final auth = ref.watch(authStateProvider);
  final engine = ref.watch(syncEngineProvider);

  auth.whenData((user) {
    if (user != null) {
      engine.start();
      engine.scheduleSync();
    }
  });
});

final syncStatusProvider = StreamProvider<SyncStatus>((ref) {
  return ref.watch(syncEngineProvider).statusStream;
});
