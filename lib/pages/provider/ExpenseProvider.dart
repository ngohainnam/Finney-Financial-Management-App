import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/assets/widgets/app_drawer.dart';
import 'package:flutter/material.dart';

class Expense {
  final String id;
  final String category;
  final double amount;
  final DateTime date;
  final String description;

  Expense({
    required this.id,
    required this.category,
    required this.amount,
    required this.date,
    required this.description,
  });
}

class ExpenseProvider with ChangeNotifier {
  final List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  void addExpense(Expense expense) {
    _expenses.add(expense);
    notifyListeners();
  }

  void editExpense(String id, Expense newExpense) {
    final index = _expenses.indexWhere((expense) => expense.id == id);
    if (index >= 0) {
      _expenses[index] = newExpense;
      notifyListeners();
    }
  }

  void deleteExpense(String id) {
    _expenses.removeWhere((expense) => expense.id == id);
    notifyListeners();
  }
}
//Expense Tracking