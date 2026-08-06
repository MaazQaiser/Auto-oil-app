import 'package:firebase_auth/firebase_auth.dart' as fb;

import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository() : _auth = fb.FirebaseAuth.instance;

  final fb.FirebaseAuth _auth;

  @override
  Stream<AuthUser?> get authStateChanges =>
      _auth.authStateChanges().map(_mapUser);

  @override
  AuthUser? get currentUser => _mapUser(_auth.currentUser);

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return _mapUser(credential.user)!;
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_friendlyMessage(e.code));
    }
  }

  @override
  Future<AuthUser> createAccount({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return _mapUser(credential.user)!;
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_friendlyMessage(e.code));
    }
  }

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on fb.FirebaseAuthException catch (e) {
      throw AuthException(_friendlyMessage(e.code));
    }
  }

  AuthUser? _mapUser(fb.User? user) {
    if (user == null) return null;
    return AuthUser(
      uid: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
    );
  }

  String _friendlyMessage(String code) {
    return switch (code) {
      'user-not-found' => 'No account found for this email.',
      'wrong-password' => 'Incorrect password. Please try again.',
      'invalid-email' => 'Please enter a valid email address.',
      'email-already-in-use' => 'An account already exists for this email.',
      'weak-password' => 'Use a password with at least 6 characters.',
      'operation-not-allowed' =>
        'Email/password sign-in is not enabled in Firebase.',
      'user-disabled' => 'This account has been disabled.',
      'too-many-requests' => 'Too many failed attempts. Try again later.',
      'network-request-failed' => 'No internet connection.',
      'invalid-credential' => 'Invalid email or password.',
      _ => 'Sign in failed. Please try again.',
    };
  }
}
