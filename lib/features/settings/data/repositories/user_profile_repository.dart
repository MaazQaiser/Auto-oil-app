import '../../../../core/sync/firestore_remote_datasource.dart';
import '../../../../core/utils/logger.dart';
import '../../domain/entities/user_profile.dart';
import '../datasources/user_profile_local_datasource.dart';

class UserProfileRepository {
  UserProfileRepository(this._local, this._remote);

  final UserProfileLocalDataSource _local;
  final FirestoreRemoteDataSource _remote;

  Future<UserProfile?> getByUid(String uid) => _local.getByUid(uid);

  Future<UserProfile> getOrCreate({
    required String uid,
    required String email,
    String? displayName,
  }) async {
    final UserProfile? existing = await _local.getByUid(uid);
    if (existing != null) {
      return existing;
    }

    final UserProfile created = UserProfile.defaults(
      uid: uid,
      email: email,
      displayName: displayName,
    );
    await _local.upsert(created);
    AppLogger.info('Created local user profile for uid=$uid');
    return created;
  }

  Future<UserProfile> save(UserProfile profile) async {
    final UserProfile updated = profile.copyWith(updatedAt: DateTime.now().toUtc());
    await _local.upsert(updated);
    try {
      await _remote.setUserProfile(updated);
    } catch (e, st) {
      AppLogger.error('Failed to sync user profile to Firestore', error: e, stackTrace: st);
    }
    return updated;
  }

  Future<UserProfile> ensureSynced({
    required String uid,
    required String email,
    String? displayName,
  }) async {
    UserProfile local = await getOrCreate(
      uid: uid,
      email: email,
      displayName: displayName,
    );

    try {
      final UserProfile? remote = await _remote.getUserProfile(uid);
      if (remote == null) {
        await _remote.setUserProfile(local);
        AppLogger.info('Seeded Firestore user profile for uid=$uid');
        return local;
      }

      if (remote.updatedAt.isAfter(local.updatedAt)) {
        await _local.upsert(remote);
        AppLogger.info('Applied remote user profile for uid=$uid');
        return remote;
      }

      if (local.updatedAt.isAfter(remote.updatedAt)) {
        await _remote.setUserProfile(local);
        AppLogger.info('Pushed newer local user profile for uid=$uid');
      }
    } catch (e, st) {
      AppLogger.error('User profile cloud sync failed', error: e, stackTrace: st);
    }

    return (await _local.getByUid(uid)) ?? local;
  }
}
