import '../config/firebase_bootstrap.dart';

import '../database/app_database.dart';
import '../services/auth_preferences.dart';
import '../utils/logger.dart';
import 'firestore_remote_datasource.dart';
import 'local_sync_mirror.dart';
import 'sync_engine.dart';
import 'sync_outbox_datasource.dart';

/// Runs a full sync cycle from a background isolate (Workmanager).
class BackgroundSyncRunner {
  static Future<bool> run() async {
    try {
      final ready = await FirebaseBootstrap.ensureInitialized();
      if (!ready) {
        AppLogger.info('Background sync skipped — Firebase unavailable');
        return true;
      }

      final authPrefs = await AuthPreferences.create();
      final String? uid =
          authPrefs.activeUid ?? FirebaseBootstrap.currentUser?.uid;
      if (uid == null) {
        AppLogger.info('Background sync skipped — no active user');
        return true;
      }

      if (FirebaseBootstrap.currentUser == null) {
        AppLogger.info('Background sync skipped — not authenticated');
        return true;
      }

      final db = AppDatabase();
      final engine = SyncEngine(
        outbox: SyncOutboxDataSource(db),
        remote: FirestoreRemoteDataSource(),
        mirror: LocalSyncMirror(db),
      );

      await engine.syncNow();
      await db.close();
      AppLogger.info('Background sync completed');
      return true;
    } catch (e, st) {
      AppLogger.error('Background sync failed', error: e, stackTrace: st);
      return false;
    }
  }
}
