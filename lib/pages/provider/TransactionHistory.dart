import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/assets/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'ExpenseProvider.dart';

class TransactionHistory {
  final List<Expense> _transactions = [];

  List<Expense> get transactions => _transactions;

  void addTransaction(Expense expense) {
    _transactions.add(expense);
  }

  List<Expense> filterTransactions({
    String? category,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _transactions.where((transaction) {
      final matchesCategory =
          category == null || transaction.category == category;
      final matchesDateRange =
          (startDate == null || transaction.date.isAfter(startDate)) &&
          (endDate == null || transaction.date.isBefore(endDate));
      return matchesCategory && matchesDateRange;
    }).toList();
  }
}
