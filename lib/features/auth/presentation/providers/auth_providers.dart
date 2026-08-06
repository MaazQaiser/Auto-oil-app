import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/firebase_auth_repository.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthRepository();
});

/// Streams the current [AuthUser] (null = signed out).
final authStateProvider = StreamProvider<AuthUser?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

/// [ChangeNotifier] that forwards auth changes — used as GoRouter refreshListenable.
class AuthChangeNotifier extends ChangeNotifier {
  AuthChangeNotifier(Stream<AuthUser?> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<AuthUser?> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final authChangeNotifierProvider = Provider<AuthChangeNotifier>((ref) {
  final notifier = AuthChangeNotifier(
    ref.read(authRepositoryProvider).authStateChanges,
  );
  ref.onDispose(notifier.dispose);
  return notifier;
});

/// Controller for sign-in and sign-out actions.
class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController(this._repository) : super(const AsyncValue.data(null));

  final AuthRepository _repository;

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repository.signIn(email: email, password: password),
    );
  }

  Future<void> createAccount(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repository.createAccount(email: email, password: password),
    );
  }

  Future<void> sendPasswordReset(String email) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repository.sendPasswordResetEmail(email),
    );
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = const AsyncValue.data(null);
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
      return AuthController(ref.watch(authRepositoryProvider));
    });
