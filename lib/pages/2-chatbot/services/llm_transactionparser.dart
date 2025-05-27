import 'package:finney/core/storage/cloud/models/transaction_model.dart';
import 'package:intl/intl.dart';

class TransactionParser {
  static bool hasTransactionInfo(String message) {
    return message.contains("[AT]");
  }

  static bool isConfirmingTransaction(String message) {
    String lowercase = message.toLowerCase();
    return lowercase.contains('yes') || lowercase.contains('হ্যাঁ');
  }

  static bool isCancelingTransaction(String message) {
    String lowercase = message.toLowerCase();
    return lowercase.contains('no') || lowercase.contains('না');
  }

  static Map<String, dynamic>? extractTransactionFromMessage(String message) {
    try {
      // Amount: $30.00 or পরিমাণ: ৳৩০.০০
      RegExp amountRegex = RegExp(r'(Amount|পরিমাণ):\s*[\$৳]?\s*([\d,.০-৯]+)');
      final amountMatch = amountRegex.firstMatch(message);
      if (amountMatch == null) return null;
      String amountStr = _bengaliToEnglishNumber(amountMatch.group(2) ?? '0');
      double amount = double.tryParse(amountStr.replaceAll(',', '')) ?? 0;

      // Name: KFC or নাম: KFC
      RegExp nameRegex = RegExp(r'(Name|নাম):\s*([^\n\r-]+)');
      final nameMatch = nameRegex.firstMatch(message);
      String name = nameMatch?.group(2)?.trim() ?? 'Unknown';

      // Category: Food or বিভাগ: খাবার
      RegExp categoryRegex = RegExp(r'(Category|বিভাগ):\s*([^\n\r-]+)');
      final categoryMatch = categoryRegex.firstMatch(message);
      String category = categoryMatch?.group(2)?.trim().replaceAll('।', '').replaceAll('.', '') ?? 'Others';

      // Date: Apr 16, 2025 or তারিখ: ১৬ এপ্রিল, ২০২৫
      RegExp dateRegex = RegExp(r'(Date|তারিখ):\s*([^\n\r-]+)');
      final dateMatch = dateRegex.firstMatch(message);
      String dateStr = dateMatch?.group(2)?.trim() ?? '';

      DateTime date;
      try {
        // Try English format first
        if (RegExp(r'[A-Za-z]').hasMatch(dateStr)) {
          date = DateFormat('MMM d, yyyy', 'en').parse(dateStr);
        } else if (RegExp(r'\d{1,2} [\u0980-\u09FF]+, \d{4}').hasMatch(dateStr)) {
          // Bengali format: ১৬ এপ্রিল, ২০২৫
          String engDateStr = _bengaliToEnglishNumber(dateStr);
          engDateStr = _bengaliMonthToEnglish(engDateStr);
          date = DateFormat('d MMMM, yyyy', 'en').parse(engDateStr);
        } else {
          date = DateTime.now();
        }
      } catch (e) {
        date = DateTime.now();
      }

      // Description: spent on KFC or বিবরণ: KFC-তে খরচ
      RegExp descRegex = RegExp(r'(Description|বিবরণ):\s*([^\n\r-]+)');
      final descMatch = descRegex.firstMatch(message);
      String description = descMatch?.group(2)?.trim() ?? '';

      bool isIncome = isIncomeCategory(category);

      return {
        'amount': amount,
        'name': name,
        'category': category,
        'date': date,
        'description': description,
        'isIncome': isIncome,
      };
    } catch (e) {
      return null;
    }
  }

  // Helper: Bengali numerals to English
  static String _bengaliToEnglishNumber(String input) {
    const bn = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    for (int i = 0; i < bn.length; i++) {
      input = input.replaceAll(bn[i], i.toString());
    }
    return input;
  }

  // Helper: Bengali months to English months
  static String _bengaliMonthToEnglish(String input) {
    const months = {
      'জানুয়ারী': 'January',
      'ফেব্রুয়ারী': 'February',
      'মার্চ': 'March',
      'এপ্রিল': 'April',
      'মে': 'May',
      'জুন': 'June',
      'জুলাই': 'July',
      'আগস্ট': 'August',
      'সেপ্টেম্বর': 'September',
      'অক্টোবর': 'October',
      'নভেম্বর': 'November',
      'ডিসেম্বর': 'December',
    };
    months.forEach((bn, en) {
      input = input.replaceAll(bn, en);
    });
    return input;
  }

  static bool isIncomeCategory(String category) {
    final incomeCategories = [
      'salary', 'investment', 'business', 'gift', 'income', 'others',
      'বেতন', 'বিনিয়োগ', 'ব্যবসা', 'উপহার', 'আয়', 'অন্যান্য'
    ];
    final normalized = category.trim().toLowerCase();
    return incomeCategories.any((c) => normalized.contains(c));
  }

  static TransactionModel createTransactionModel(Map<String, dynamic> data) {
    double finalAmount = data['isIncome'] ? data['amount'] : -data['amount'];

    return TransactionModel(
      name: data['name'],
      category: data['category'],
      amount: finalAmount,
      date: data['date'],
      description: data['description'],
    );
  }
}