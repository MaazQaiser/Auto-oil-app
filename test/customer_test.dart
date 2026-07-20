import 'package:flutter_test/flutter_test.dart';

import 'package:autocare_manager/core/utils/validators.dart';
import 'package:autocare_manager/features/customers/domain/entities/customer.dart';

void main() {
  group('Customer', () {
    test('initials uses first letter of full name', () {
      final Customer customer = Customer(
        id: '1',
        fullName: 'Ahmed Khan',
        phoneNumber: '+923001112233',
        createdAt: DateTime(2026, 1, 1),
        updatedAt: DateTime(2026, 1, 1),
      );
      expect(customer.initials, 'A');
    });
  });

  group('Validators for customer form', () {
    test('optionalEmail allows empty', () {
      expect(Validators.optionalEmail(null), isNull);
      expect(Validators.optionalEmail(''), isNull);
      expect(Validators.optionalEmail('bad'), isNotNull);
      expect(Validators.optionalEmail('a@b.com'), isNull);
    });

    test('optionalPhone allows empty', () {
      expect(Validators.optionalPhone(null), isNull);
      expect(Validators.optionalPhone('123'), isNotNull);
      expect(Validators.optionalPhone('+923001112233'), isNull);
    });
  });
}
