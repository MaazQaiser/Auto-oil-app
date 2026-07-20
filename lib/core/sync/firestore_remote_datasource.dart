import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/logger.dart';

/// Thin Firestore accessor scoped to `users/{uid}/{collection}/{id}`.
class FirestoreRemoteDataSource {
  FirestoreRemoteDataSource({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _col(
    String uid,
    String collection,
  ) {
    return _db.collection('users').doc(uid).collection(collection);
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

  Future<void> delete({
    required String uid,
    required String collection,
    required String documentId,
  }) async {
    await _col(uid, collection).doc(documentId).delete();
  }

  Future<List<Map<String, dynamic>>> fetchAll({
    required String uid,
    required String collection,
  }) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snap =
          await _col(uid, collection).get();
      return snap.docs.map((d) {
        final Map<String, dynamic> data = Map<String, dynamic>.from(d.data());
        data['id'] = data['id'] ?? d.id;
        return data;
      }).toList();
    } catch (e, st) {
      AppLogger.error(
        'Firestore fetch failed for $collection',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  Future<bool> collectionHasDocs({
    required String uid,
    required String collection,
  }) async {
    final snap = await _col(uid, collection).limit(1).get();
    return snap.docs.isNotEmpty;
  }
}
