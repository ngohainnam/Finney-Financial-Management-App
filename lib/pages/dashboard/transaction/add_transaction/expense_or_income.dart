import 'package:finney/pages/dashboard/saving/add_saving/add_edit_goal_page.dart';
import 'package:finney/pages/dashboard/widgets/option_button.dart';
import 'package:flutter/material.dart';
import 'package:finney/pages/dashboard/transaction/add_transaction/add_income_screen.dart';
import 'package:finney/pages/dashboard/transaction/add_transaction/add_expense_screen.dart';
import 'package:finney/pages/dashboard/models/transaction_model.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/localization/locales.dart';

class AddTransactionModal extends StatelessWidget {
  final Function(TransactionModel) onTransactionAdded;

  const AddTransactionModal({super.key, required this.onTransactionAdded});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }

  void _navigateToExpenseScreen(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                AddExpenseScreen(onTransactionAdded: onTransactionAdded),
      ),
    );
  }

  void _navigateToIncomeScreen(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                AddIncomeScreen(onTransactionAdded: onTransactionAdded),
      ),
    );
  }

  void _navigateToAddEditGoalPage(BuildContext context) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => AddEditGoalPage(
            ),
      ),
    );
  }
}
