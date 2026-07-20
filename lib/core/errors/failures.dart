import 'package:equatable/equatable.dart';

/// Base failure type for domain / presentation error handling.
abstract class Failure extends Equatable {
  const Failure({required this.message, this.code});

  final String message;
  final String? code;

  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code});
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({required super.message, super.code});
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection',
    super.code,
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code});
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    super.message = 'Something went wrong',
    super.code,
  });
}
