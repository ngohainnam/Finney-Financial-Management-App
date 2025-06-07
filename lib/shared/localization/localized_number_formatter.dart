import 'package:flutter/material.dart';

class LocalizedNumberFormatter {
  static String formatNumber(String input, BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    if (locale.languageCode == 'bn') {
      return _englishToBengaliNumber(input);
    }
    return input;
  }

  static String formatDouble(double value, BuildContext context) {
    return formatNumber(value.toStringAsFixed(2), context);
  }

  static String _englishToBengaliNumber(String input) {
    const en = ['0','1','2','3','4','5','6','7','8','9'];
    const bn = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    for (int i = 0; i < en.length; i++) {
      input = input.replaceAll(en[i], bn[i]);
    }
    return input;
  }

  /// Bengali numerals to English
  static String bengaliToEnglishNumber(String input) {
    const bn = ['০','১','২','৩','৪','৫','৬','৭','৮','৯'];
    for (int i = 0; i < bn.length; i++) {
      input = input.replaceAll(bn[i], i.toString());
    }
    return input;
  }

  /// Bengali months to English months
  static String bengaliMonthToEnglish(String input) {
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

  static String formatDate(String date, BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    if (locale.languageCode == 'bn') {
      // Convert digits and months to Bengali
      String result = _englishToBengaliNumber(date);
      // Optionally, convert months to Bengali if you have a map
      const months = {
        'January': 'জানুয়ারী',
        'February': 'ফেব্রুয়ারী',
        'March': 'মার্চ',
        'April': 'এপ্রিল',
        'May': 'মে',
        'June': 'জুন',
        'July': 'জুলাই',
        'August': 'আগস্ট',
        'September': 'সেপ্টেম্বর',
        'October': 'অক্টোবর',
        'November': 'নভেম্বর',
        'December': 'ডিসেম্বর',
      };
      months.forEach((en, bn) {
        result = result.replaceAll(en, bn);
      });
      return result;
    }
    return date;
  }
}