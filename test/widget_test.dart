import 'package:flutter_test/flutter_test.dart';

import 'package:autocare_manager/core/config/app_config.dart';
import 'package:autocare_manager/core/utils/validators.dart';
import 'package:autocare_manager/core/utils/currency_formatter.dart';

void main() {
  group('AppConfig', () {
    test('has expected app name', () {
      expect(AppConfig.appName, 'AutoCare Manager');
    });
  });

  group('Validators', () {
    test('required rejects empty values', () {
      expect(Validators.required(null), isNotNull);
      expect(Validators.required(''), isNotNull);
      expect(Validators.required('  '), isNotNull);
      expect(Validators.required('ok'), isNull);
    });

    test('email validates format', () {
      expect(Validators.email('bad'), isNotNull);
      expect(Validators.email('user@example.com'), isNull);
    });
  });

  group('CurrencyFormatter', () {
    test('formats amount with symbol', () {
      final String result = CurrencyFormatter.format(12.5);
      expect(result.contains('12'), isTrue);
    });
  });
}
