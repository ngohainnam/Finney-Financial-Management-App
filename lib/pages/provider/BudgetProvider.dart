import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/assets/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'ExpenseProvider.dart';

class Budget {
  final String category;
  final double limit;

  Budget({required this.category, required this.limit});
}

class BudgetProvider with ChangeNotifier {
  final List<Budget> _budgets = [];
  final ExpenseProvider expenseProvider;
  BudgetProvider(this.expenseProvider);
  List<Budget> get budgets => _budgets;

  void setBudget(Budget budget) {
    final index = _budgets.indexWhere((b) => b.category == budget.category);
    if (index >= 0) {
      _budgets[index] = budget;
    } else {
      _budgets.add(budget);
    }
    notifyListeners();
  }

  double getRemainingBudget(String category) {
    final budget = _budgets.firstWhere(
      (b) => b.category == category,
      orElse: () => Budget(category: category, limit: 0),
    );
    final totalSpent = expenseProvider.expenses
        .where((expense) => expense.category == category)
        .fold(0.0, (sum, expense) => sum + expense.amount);
    return budget.limit - totalSpent;
  }
}
//Budget Planning