import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CurrencyFormatter {
  static String _currentCurrency = 'BDT';
  
  // Initialize formatters for different currencies
  static final Map<String, NumberFormat> _formatters = {
    'BDT': NumberFormat.currency(
      symbol: '৳',
      locale: 'bn_BD',
      decimalDigits: 2,
    ),
    'AUD': NumberFormat.currency(
      symbol: '\$',
      locale: 'en_AU',
      decimalDigits: 2,
    ),
  };

  static void updateCurrency(String currencyCode) {
    if (_formatters.containsKey(currencyCode)) {
      _currentCurrency = currencyCode;
    }
  }

  // Get the appropriate formatter based on current settings
  static NumberFormat get _currencyFormat {
    // Try to get from settings box if available
    try {
      final userBox = Hive.box('userBox');
      final storedCurrency = userBox.get('currency', defaultValue: 'BDT');
      if (_formatters.containsKey(storedCurrency)) {
        _currentCurrency = storedCurrency;
      }
    } catch (e) {
      // If any error, use the default or last set currency
    }
    
    return _formatters[_currentCurrency]!;
  }

  static String getCurrencySymbol() {
    return _currentCurrency == 'BDT' ? '৳' : '\$';
  }

  static String format(double amount) {
    return _currencyFormat.format(amount);
  }

  static String formatWithoutSymbol(double amount) {
    String symbol = _currentCurrency == 'BDT' ? '৳' : '\$';
    return _currencyFormat.format(amount).replaceAll(symbol, '').trim();
  }

  static double parse(String amount) {
    try {
      // Remove currency symbol and any whitespace
      String cleanAmount = amount
          .replaceAll('৳', '')
          .replaceAll('\$', '')
          .trim();
      // Replace any commas with empty string
      cleanAmount = cleanAmount.replaceAll(',', '');
      return double.parse(cleanAmount);
    } catch (e) {
      return 0.0;
    }
  }
}