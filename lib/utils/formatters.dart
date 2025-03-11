import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat currencyFormatter = NumberFormat.currency(symbol: '\$');

  static String format(double amount) {
    return currencyFormatter.format(amount);
  }

  static String formatWithSign(double amount) {
    if (amount >= 0) {
      return '+${format(amount)}';
    } else {
      return format(amount);
    }
  }
}

class DateFormatter {
  static final DateFormat fullDateFormatter = DateFormat('MMM d, yyyy');
  static final DateFormat shortDateFormatter = DateFormat('MMM d');
  static final DateFormat timeFormatter = DateFormat('h:mm a');

  static String formatFullDate(DateTime date) {
    return fullDateFormatter.format(date);
  }

  static String formatShortDate(DateTime date) {
    return shortDateFormatter.format(date);
  }

  static String formatTime(DateTime date) {
    return timeFormatter.format(date);
  }

  static String formatTransactionDate(DateTime date) {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today, ${timeFormatter.format(date)}';
    } else if (date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day) {
      return 'Yesterday, ${timeFormatter.format(date)}';
    } else {
      return '${shortDateFormatter.format(date)}, ${timeFormatter.format(date)}';
    }
  }
}

class PercentFormatter {
  static String format(double percentage) {
    return '${percentage.toStringAsFixed(1)}%';
  }
}