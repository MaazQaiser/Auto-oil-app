import 'package:equatable/equatable.dart';

/// Authenticated user identity passed around the app.
class AuthUser extends Equatable {
  const AuthUser({
    required this.uid,
    required this.email,
    this.displayName,
  });

  final String uid;
  final String email;
  final String? displayName;

  String get nameOrEmail => displayName?.isNotEmpty == true ? displayName! : email;

  @override
  List<Object?> get props => [uid, email, displayName];
}
