import '../entities/auth_user.dart';

abstract class AuthRepository {
  /// Emits the current user whenever auth state changes.
  Stream<AuthUser?> get authStateChanges;

  /// Returns the currently signed-in user, or null.
  AuthUser? get currentUser;

  /// Signs in with email + password. Throws [AuthException] on failure.
  Future<AuthUser> signIn({required String email, required String password});

  /// Signs out the current user.
  Future<void> signOut();

  /// Sends a password-reset email.
  Future<void> sendPasswordResetEmail(String email);
}

/// Wraps Firebase auth error codes into a readable message.
class AuthException implements Exception {
  const AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}
