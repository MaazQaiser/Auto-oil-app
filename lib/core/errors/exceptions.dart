/// Application-level exceptions.
class AppException implements Exception {
  const AppException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() =>
      'AppException(message: $message${code != null ? ', code: $code' : ''})';
}

class CacheException extends AppException {
  const CacheException(super.message, {super.code});
}

class DatabaseException extends AppException {
  const DatabaseException(super.message, {super.code});
}

class NetworkException extends AppException {
  const NetworkException([
    super.message = 'No internet connection',
    String? code,
  ]) : super(code: code);
}

class ValidationException extends AppException {
  const ValidationException(super.message, {super.code});
}

class NotFoundException extends AppException {
  const NotFoundException([
    super.message = 'Resource not found',
    String? code,
  ]) : super(code: code);
}
