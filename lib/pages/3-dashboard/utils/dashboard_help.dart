import 'package:flutter/material.dart';
import 'package:finney/shared/widgets/common/help_pages.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:finney/shared/path/app_images.dart';

class DashboardHelp {
  static void show(BuildContext context) {
    final pages = [
      AppHelpPage(
        title: LocaleData.dashboardHelpTitle.getString(context),
        image: Image.asset(
          AppImages.dashboardOverview,
          fit: BoxFit.contain,
        ),
        description: LocaleData.dashboardHelpSubtitle.getString(context),
      ),
      AppHelpPage(
        title: LocaleData.dashboardHelpTitle.getString(context),
        image: Image.asset(
          AppImages.dashboardBalance,
          fit: BoxFit.contain,
        ),
        description: LocaleData.dashboardHelpBalance.getString(context),
      ),
      AppHelpPage(
        title: LocaleData.dashboardHelpTitle.getString(context),
        image: Image.asset(
          AppImages.dashboardAddTransaction,
          fit: BoxFit.contain,
        ),
        description: LocaleData.dashboardHelpAddTransaction.getString(context),
      ),
      AppHelpPage(
        title: LocaleData.dashboardHelpTitle.getString(context),
        image: Image.asset(
          AppImages.dashboardDeleteTransaction,
          fit: BoxFit.contain,
        ),
        description: LocaleData.dashboardHelpDeleteTransaction.getString(context),
      ),
      AppHelpPage(
        title: LocaleData.dashboardHelpTitle.getString(context),
        image: Image.asset(
          AppImages.dashboardSpendingPatterns,
          fit: BoxFit.contain,
        ),
        description: LocaleData.dashboardHelpSpendingPatterns.getString(context),
      ),
      AppHelpPage(
        title: LocaleData.dashboardHelpTitle.getString(context),
        image: Image.asset(
          AppImages.dashboardRefresh,
          fit: BoxFit.contain,
        ),
        description: LocaleData.dashboardHelpRefresh.getString(context),
      ),
    ];
    
    AppHelp.show(context, pages);
  }
}