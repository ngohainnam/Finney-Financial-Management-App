import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: '৳',
    locale: 'bn_BD',
    decimalDigits: 2,
  );

  static String format(double amount) {
    return _currencyFormat.format(amount);
  }

  static String formatWithoutSymbol(double amount) {
    return _currencyFormat.format(amount).replaceAll('৳', '').trim();
  }

  static double parse(String amount) {
    try {

      String cleanAmount = amount.replaceAll('৳', '').trim();

      cleanAmount = cleanAmount.replaceAll(',', '');
      return double.parse(cleanAmount);
    } catch (e) {
      return 0.0;
    }
  }
}