import 'package:flutter/widgets.dart';
import 'package:finney/shared/localization/locales.dart';

extension FinneyStringExtension on String {
  String getString(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    if (locale == 'bn') return LocaleData.bn[this] ?? this;
    return LocaleData.en[this] ?? this;
  }
}
