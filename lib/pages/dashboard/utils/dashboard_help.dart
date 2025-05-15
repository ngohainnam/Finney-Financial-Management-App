import 'package:flutter/material.dart';
import 'package:finney/assets/widgets/common/help_dialog.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/assets/localization/locales.dart';

class DashboardHelp {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AppDialog(
        title:  LocaleData.dashboardHelpTitle.getString(context),
        subtitle: LocaleData.dashboardHelpSubtitle.getString(context),
        headerIcon: Icons.dashboard_rounded,
        instructions: const [
          AppDialogInstruction(
            icon: Icons.account_balance_wallet,
            text: LocaleData.dashboardHelpBalance,
          ),
          AppDialogInstruction(
            icon: Icons.add_circle_outline,
            text: LocaleData.dashboardHelpAddTransaction,
          ),
          AppDialogInstruction(
            icon: Icons.swap_horiz,
            text: LocaleData.dashboardHelpDeleteTransaction,
          ),
          AppDialogInstruction(
            icon: Icons.bar_chart,
            text:  LocaleData.dashboardHelpSpendingPatterns,
          ),
          AppDialogInstruction(
            icon: Icons.refresh,
            text:  LocaleData.dashboardHelpRefresh,
          ),
        ],
      ),
    );
  }
}