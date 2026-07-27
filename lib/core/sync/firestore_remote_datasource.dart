import 'package:cloud_firestore/cloud_firestore.dart';

import '../../features/settings/domain/entities/user_profile.dart';
import '../utils/logger.dart';

/// Thin Firestore accessor scoped to `users/{uid}/{collection}/{id}`.
class FirestoreRemoteDataSource {
  FirestoreRemoteDataSource({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) {
    return _db.collection('users').doc(uid);
  }

  CollectionReference<Map<String, dynamic>> _col(
    String uid,
    String collection,
  ) {
    return _db.collection('users').doc(uid).collection(collection);
  }

  Map<String, dynamic> _normalizeDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> d,
  ) {
    final Map<String, dynamic> data = Map<String, dynamic>.from(d.data());
    data['id'] = data['id'] ?? d.id;
    return data;
  }

  Future<void> upsert({
    required String uid,
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    final Map<String, dynamic> payload = Map<String, dynamic>.from(data)
      ..['id'] = documentId
      ..['ownerUid'] = uid
      ..['syncedAt'] = FieldValue.serverTimestamp();
    await _col(uid, collection).doc(documentId).set(
          payload,
          SetOptions(merge: true),
        );
  }

  /// Tombstone delete — other devices receive the change via incremental pull.
  Future<void> tombstone({
    required String uid,
    required String collection,
    required String documentId,
    required DateTime updatedAt,
  }) async {
    await upsert(
      uid: uid,
      collection: collection,
      documentId: documentId,
      data: {
        'isDeleted': true,
        'updatedAt': updatedAt.toUtc().toIso8601String(),
      },
    );
  }

  Future<void> delete({
    required String uid,
    required String collection,
    required String documentId,
  }) async {
    await _col(uid, collection).doc(documentId).delete();
  }

  Future<Map<String, dynamic>?> fetchDocument({
    required String uid,
    required String collection,
    required String documentId,
  }) async {
    try {
      final snap = await _col(uid, collection).doc(documentId).get();
      if (!snap.exists) return null;
      final raw = snap.data();
      if (raw == null) return null;
      final data = Map<String, dynamic>.from(raw);
      data['id'] = data['id'] ?? documentId;
      return data;
    } catch (e, st) {
      AppLogger.error(
        'Firestore fetchDocument failed for $collection/$documentId',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  /// Full fetch — used for initial seed / reconcile ID lists.
  Future<List<Map<String, dynamic>>> fetchAll({
    required String uid,
    required String collection,
  }) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snap =
          await _col(uid, collection).get();
      return snap.docs.map(_normalizeDoc).toList();
    } catch (e, st) {
      AppLogger.error(
        'Firestore fetch failed for $collection',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  /// Incremental fetch — documents with [updatedAt] after [since] (ISO-8601).
  /// When [since] is null, returns all documents (first pull).
  Future<List<Map<String, dynamic>>> fetchChangedSince({
    required String uid,
    required String collection,
    DateTime? since,
  }) async {
    try {
      if (since == null) {
        return fetchAll(uid: uid, collection: collection);
      }

      final String cursor = since.toUtc().toIso8601String();
      final QuerySnapshot<Map<String, dynamic>> snap = await _col(uid, collection)
          .where('updatedAt', isGreaterThan: cursor)
          .get();
      return snap.docs.map(_normalizeDoc).toList();
    } catch (e, st) {
      AppLogger.warning(
        'Incremental fetch failed for $collection — falling back to full pull',
        error: e,
        stackTrace: st,
      );
      return fetchAll(uid: uid, collection: collection);
    }
  }

  Future<Set<String>> fetchAllDocumentIds({
    required String uid,
    required String collection,
  }) async {
    final snap = await _col(uid, collection).get();
    return snap.docs.map((d) => d.id).toSet();
  }

  Future<bool> collectionHasDocs({
    required String uid,
    required String collection,
  }) async {
    final snap = await _col(uid, collection).limit(1).get();
    return snap.docs.isNotEmpty;
  }

  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final snap = await _userDoc(uid).get();
      if (!snap.exists) return null;
      final raw = snap.data();
      if (raw == null) return null;
      final data = Map<String, dynamic>.from(raw);
      data['uid'] = uid;
      return UserProfile.fromFirestoreMap(data);
    } catch (e, st) {
      AppLogger.error('Firestore user profile fetch failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<void> setUserProfile(UserProfile profile) async {
    final payload = Map<String, dynamic>.from(profile.toFirestoreMap())
      ..['ownerUid'] = profile.uid
      ..['syncedAt'] = FieldValue.serverTimestamp();
    await _userDoc(profile.uid).set(payload, SetOptions(merge: true));
  }
}
