import '../constants/string_constants.dart';

/// Form field validators.
class Validators {
  const Validators._();

  static String? required(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? StringConstants.fieldRequired;
    }
    return null;
  }

  static String? email(String? value) {
    final String? requiredError = required(value);
    if (requiredError != null) return requiredError;

    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value!.trim())) {
      return StringConstants.invalidEmail;
    }
    return null;
  }

  /// Validates email only when a value is provided.
  static String? optionalEmail(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return email(value);
  }

  static String? phone(String? value) {
    final String? requiredError = required(value);
    if (requiredError != null) return requiredError;

    final String digits = value!.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 7 || digits.length > 15) {
      return StringConstants.invalidPhone;
    }
    return null;
  }

  /// Validates phone only when a value is provided.
  static String? optionalPhone(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return phone(value);
  }

  static String? year(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final int? parsed = int.tryParse(value.trim());
    final int currentYear = DateTime.now().year + 1;
    if (parsed == null || parsed < 1950 || parsed > currentYear) {
      return StringConstants.invalidYear;
    }
    return null;
  }

  static String? odometer(String? value) {
    final String? requiredError = required(value);
    if (requiredError != null) return requiredError;
    final int? parsed = int.tryParse(value!.trim().replaceAll(',', ''));
    if (parsed == null || parsed < 0 || parsed > 9999999) {
      return StringConstants.invalidOdo;
    }
    return null;
  }

  static String? minLength(String? value, int min, {String? message}) {
    final String? requiredError = required(value);
    if (requiredError != null) return requiredError;

    if (value!.trim().length < min) {
      return message ?? 'Must be at least $min characters';
    }
    return null;
  }

  static String? maxLength(String? value, int max, {String? message}) {
    if (value != null && value.trim().length > max) {
      return message ?? 'Must be at most $max characters';
    }
    return null;
  }

  /// Combines multiple validators; returns the first error.
  static String? combine(
    String? value,
    List<String? Function(String?)> validators,
  ) {
    for (final validator in validators) {
      final String? error = validator(value);
      if (error != null) return error;
    }
    return null;
  }
}
