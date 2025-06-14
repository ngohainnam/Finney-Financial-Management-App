import 'package:finney/pages/3-dashboard/widgets/option_button.dart';
import 'package:finney/pages/4-saving/add_edit_goal_page.dart';
import 'package:flutter/material.dart';
import 'package:finney/pages/6-transaction/add_transaction/add_income_screen.dart';
import 'package:finney/pages/6-transaction/add_transaction/add_expense_screen.dart';
import 'package:finney/core/storage/cloud/models/transaction_model.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:finney/shared/widgets/common/settings_notifier.dart';

class AddTransactionModal extends StatelessWidget {
  final Function(TransactionModel) onTransactionAdded;

  const AddTransactionModal({super.key, required this.onTransactionAdded});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: SettingsNotifier().textSizeNotifier,
      builder: (context, textSize, child) {
        double textScaleFactor;
        switch (textSize) {
          case 'Small':
            textScaleFactor = 0.8;
            break;
          case 'Large':
            textScaleFactor = 1.2;
            break;
          default:
            textScaleFactor = 1.0;
        }

        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScaleFactor),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  LocaleData.addNew.getString(context),
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OptionButton(
                      label: LocaleData.income.getString(context),
                      icon: Icons.add_circle_outline,
                      color: Colors.green,
                      onTap: () => _navigateToIncomeScreen(context),
                    ),
                    OptionButton(
                      label: LocaleData.expense.getString(context),
                      icon: Icons.remove_circle_outline,
                      color: Colors.red,
                      onTap: () => _navigateToExpenseScreen(context),
                    ),
                    OptionButton(
                      label: LocaleData.savings.getString(context),
                      icon: Icons.savings_outlined,
                      color: Colors.blue,
                      onTap: () => _navigateToAddEditGoalPage(context),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToExpenseScreen(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddExpenseScreen(onTransactionAdded: onTransactionAdded),
      ),
    );
  }

  void _navigateToIncomeScreen(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddIncomeScreen(onTransactionAdded: onTransactionAdded),
      ),
    );
  }

  void _navigateToAddEditGoalPage(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditGoalPage(),
      ),
    );
  }
}