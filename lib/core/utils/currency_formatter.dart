import 'package:intl/intl.dart';

import '../constants/app_constants.dart';

/// Currency formatting helpers.
class CurrencyFormatter {
  const CurrencyFormatter._();

  static String format(
    num amount, {
    String? symbol,
    String? locale,
    int decimalDigits = 2,
  }) {
    final NumberFormat formatter = NumberFormat.currency(
      symbol: symbol ?? AppConstants.defaultCurrencySymbol,
      locale: locale ?? 'en_US',
      decimalDigits: decimalDigits,
    );
    return formatter.format(amount);
  }

  static String compact(num amount, {String? symbol}) {
    final NumberFormat formatter = NumberFormat.compactCurrency(
      symbol: symbol ?? AppConstants.defaultCurrencySymbol,
      decimalDigits: 1,
    );
    return formatter.format(amount);
  }
}
