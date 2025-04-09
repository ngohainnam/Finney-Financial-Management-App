import 'package:flutter/material.dart';
import 'package:finney/assets/widgets/common/help_dialog.dart';

class DashboardHelp {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AppDialog(
        title: "How to use the Dashboard",
        subtitle: "Track your finances easily",
        headerIcon: Icons.dashboard_rounded,
        instructions: const [
          AppDialogInstruction(
            icon: Icons.account_balance_wallet,
            text: "View your current balance, income, and expenses at a glance",
          ),
          AppDialogInstruction(
            icon: Icons.add_circle_outline,
            text: "Add new transactions using the + button",
          ),
          AppDialogInstruction(
            icon: Icons.swap_horiz,
            text: "Swipe left on transactions to delete them",
          ),
          AppDialogInstruction(
            icon: Icons.bar_chart,
            text: "Monitor weekly spending patterns and category breakdown",
          ),
          AppDialogInstruction(
            icon: Icons.refresh,
            text: "Pull down to refresh your financial data",
          ),
        ],
      ),
    );
  }
}