import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:finney/shared/localization/locales.dart';

/// For localizing string keys like `LocaleData.xxx.getString(context)`
extension FinneyStringExtension on String {
  String getString(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    if (locale == 'bn') return LocaleData.bn[this] ?? this;
    return LocaleData.en[this] ?? this;
  }
}

/// For localizing numbers (integers)
extension BengaliNumberInt on int {
  String toBn(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    if (locale != 'bn') return toString();

    const enToBnDigits = {
      '0': '০',
      '1': '১',
      '2': '২',
      '3': '৩',
      '4': '৪',
      '5': '৫',
      '6': '৬',
      '7': '৭',
      '8': '৮',
      '9': '৯',
    };

    return toString().split('').map((e) => enToBnDigits[e] ?? e).join();
  }
}

/// For localizing decimal/percentage strings
extension BengaliNumberString on String {
  String toBn(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    if (locale != 'bn') return this;

    const enToBnDigits = {
      '0': '০',
      '1': '১',
      '2': '২',
      '3': '৩',
      '4': '৪',
      '5': '৫',
      '6': '৬',
      '7': '৭',
      '8': '৮',
      '9': '৯',
      '.': '.',
    };

    return split('').map((e) => enToBnDigits[e] ?? e).join();
  }
}

/// For localizing formatted date and time in Bengali
String formatBengaliDateTime(BuildContext context, DateTime dateTime) {
  final locale = Localizations.localeOf(context).languageCode;
  if (locale != 'bn') {
    return DateFormat('MMM dd, yyyy – hh:mm a').format(dateTime);
  }

  const enToBn = {
    '0': '০', '1': '১', '2': '২', '3': '৩', '4': '৪',
    '5': '৫', '6': '৬', '7': '৭', '8': '৮', '9': '৯',
    'AM': 'এএম', 'PM': 'পিএম'
  };

  const bnMonths = {
    'Jan': 'জানু',
    'Feb': 'ফেব',
    'Mar': 'মার্চ',
    'Apr': 'এপ্রিল',
    'May': 'মে',
    'Jun': 'জুন',
    'Jul': 'জুলাই',
    'Aug': 'আগস্ট',
    'Sep': 'সেপ্টে',
    'Oct': 'অক্টো',
    'Nov': 'নভে',
    'Dec': 'ডিসে',
  };

  String formatted = DateFormat('dd MMM yyyy, hh:mm a', 'en').format(dateTime);

  // Replace month names first
  for (final entry in bnMonths.entries) {
    formatted = formatted.replaceAll(entry.key, entry.value);
  }

  // Replace digits and AM/PM
  formatted = formatted
      .split('')
      .map((c) => enToBn[c] ?? c)
      .join()
      .replaceAll('AM', enToBn['AM']!)
      .replaceAll('PM', enToBn['PM']!);

  return formatted;
}
