import 'package:finney/core/storage/cloud/models/transaction_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:finney/shared/localization/localized_number_formatter.dart';

class TransactionParser {
  /// Checks if the message contains transaction info (English or Bengali)
  static bool hasTransactionInfo(String message) {
    return message.contains("I think you want to add this transaction") ||
           message.contains("আমি মনে");
  }

  /// Extracts transaction fields from the LLM message (English or Bengali)
  static Map<String, dynamic>? extractTransactionFromMessage(String message) {
    try {
      // Amount: $30.00 or পরিমাণ: ৳৩০.০০
      RegExp amountRegex = RegExp(r'(Amount|পরিমাণ)\s*:\s*[\$৳]?\s*([\d,.০-৯]+)');
      final amountMatch = amountRegex.firstMatch(message);
      if (amountMatch == null) return null;
      String amountStr = LocalizedNumberFormatter.bengaliToEnglishNumber(amountMatch.group(2) ?? '0');
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
          String engDateStr = LocalizedNumberFormatter.bengaliToEnglishNumber(dateStr);
          engDateStr = LocalizedNumberFormatter.bengaliMonthToEnglish(engDateStr);
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

  /// Checks if the category is an income type (English or Bengali)
  static bool isIncomeCategory(String category) {
    final incomeCategories = [
      'salary', 'investment', 'business', 'gift', 'income', 'others',
      'বেতন', 'বিনিয়োগ', 'ব্যবসা', 'উপহার', 'আয়', 'অন্যান্য'
    ];
    final normalized = category.trim().toLowerCase();
    return incomeCategories.any((c) => normalized.contains(c));
  }

  /// Creates a TransactionModel from parsed data
  static TransactionModel createTransactionModel(Map<String, dynamic> data) {
    double finalAmount = data['isIncome'] ? data['amount'] : -data['amount'];
    return TransactionModel(
      category: data['category'],
      amount: finalAmount,
      date: data['date'],
      description: data['description'],
    );
  }

  /// English to Bengali number conversion for display
  static String englishToBengaliNumber(String input, BuildContext context) {
    return LocalizedNumberFormatter.formatNumber(input, context);
  }

  /// Bengali numerals to English
  static String bengaliToEnglishNumber(String input) {
    return LocalizedNumberFormatter.bengaliToEnglishNumber(input);
  }

  /// Bengali months to English months
  static String bengaliMonthToEnglish(String input) {
    return LocalizedNumberFormatter.bengaliMonthToEnglish(input);
  }
}