import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';
import '../utils/logger.dart';

/// Tracks whether [Firebase.initializeApp] succeeded for this process.
class FirebaseBootstrap {
  FirebaseBootstrap._();

  static bool _initialized = false;

  static bool get isReady => _initialized;

  /// Initializes Firebase once. Safe to call multiple times.
  static Future<bool> ensureInitialized() async {
    if (_initialized) return true;

    try {
      if (Firebase.apps.isNotEmpty) {
        _initialized = true;
        return true;
      }

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).timeout(const Duration(seconds: 10));
      _initialized = true;
      return true;
    } catch (e, st) {
      debugPrint('AutoCare: Firebase init failed: $e');
      AppLogger.error('Firebase init failed', error: e, stackTrace: st);
      return false;
    }
  }

  /// Returns the current user when Firebase is ready; otherwise null.
  static User? get currentUser {
    if (!_initialized) return null;
    try {
      return FirebaseAuth.instance.currentUser;
    } catch (e, st) {
      AppLogger.error('FirebaseAuth.currentUser failed', error: e, stackTrace: st);
      return null;
    }
  }

  /// Returns FirebaseAuth when ready; otherwise null.
  static FirebaseAuth? get auth {
    if (!_initialized) return null;
    try {
      return FirebaseAuth.instance;
    } catch (e, st) {
      AppLogger.error('FirebaseAuth.instance failed', error: e, stackTrace: st);
      return null;
    }
  }

  /// Auth state stream that retries initialization before subscribing.
  static Stream<User?> authStateChanges() {
    return Stream.fromFuture(ensureInitialized()).asyncExpand((ready) {
      if (!ready) return Stream<User?>.value(null);
      try {
        return FirebaseAuth.instance.authStateChanges();
      } catch (e, st) {
        AppLogger.error(
          'FirebaseAuth.authStateChanges failed',
          error: e,
          stackTrace: st,
        );
        return Stream<User?>.value(null);
      }
    });
  }
}
