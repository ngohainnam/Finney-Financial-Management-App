import 'package:flutter/material.dart';
import 'package:finney/services/transaction_services.dart' as services;

class Transaction {
  final String id;
  final String name;
  final String category;
  final double amount;
  final DateTime date;
  final IconData icon;
  final Color iconColor;

  Transaction({
    required this.id,
    required this.name,
    required this.category,
    required this.amount,
    required this.date,
    required this.icon,
    required this.iconColor,
  });
}

class WeeklyExpense {
  final String day;
  final double amount;

  WeeklyExpense(this.day, this.amount);

  // Convert to service type
  services.WeeklyExpenseData toServiceData() {
    return services.WeeklyExpenseData(day, amount);
  }
}

class CategoryExpense {
  final String name;
  final double amount;
  final Color color;
  final IconData icon;

  CategoryExpense(this.name, this.amount, this.color, this.icon);
}

class DashboardData {
  final double monthlyIncome;
  final double monthlyExpenses;
  final List<WeeklyExpense> weeklyExpenses;
  final List<CategoryExpense> categoryExpenses;

  DashboardData({
    required this.monthlyIncome,
    required this.monthlyExpenses,
    required this.weeklyExpenses,
    required this.categoryExpenses,
  });
}
