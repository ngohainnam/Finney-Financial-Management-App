import 'package:flutter/material.dart';
import 'package:finney/assets/theme/app_color.dart';

class WeeklyExpense {
  final String day;
  final double amount;

  const WeeklyExpense(this.day, this.amount);
}

class CategoryExpense {
  final String name;
  final double amount;
  final Color color;
  final IconData icon;

  const CategoryExpense(this.name, this.amount, this.color, this.icon);
}

class Transaction {
  final String id;
  final String name;
  final String category;
  final double amount;
  final DateTime date;
  final IconData icon;
  final Color iconColor;

  const Transaction({
    required this.id,
    required this.name,
    required this.category,
    required this.amount,
    required this.date,
    required this.icon,
    required this.iconColor,
  });
}

// Sample data for weekly expenses
const List<WeeklyExpense> sampleWeeklyExpenses = [
  WeeklyExpense('Mon', 42.50),
  WeeklyExpense('Tue', 65.20),
  WeeklyExpense('Wed', 31.80),
  WeeklyExpense('Thu', 87.40),
  WeeklyExpense('Fri', 91.30),
  WeeklyExpense('Sat', 132.60),
  WeeklyExpense('Sun', 50.40),
];

// Sample data for category expenses
const List<CategoryExpense> sampleCategoryExpenses = [
  CategoryExpense('Food & Dining', 650.00, Colors.orange, Icons.restaurant),
  CategoryExpense('Transportation', 320.00, AppColors.primary, Icons.directions_car),
  CategoryExpense('Shopping', 430.00, Color(0xFF9C27B0), Icons.shopping_cart),
  CategoryExpense('Bills & Utilities', 580.00, Colors.red, Icons.receipt_long),
  CategoryExpense('Entertainment', 250.00, Colors.green, Icons.movie),
];

// Sample transactions
final List<Transaction> sampleTransactions = [
  Transaction(
    id: 'tx1',
    name: 'Starbucks Coffee',
    category: 'Food & Dining',
    amount: -4.80,
    date: DateTime.now(),
    icon: Icons.coffee,
    iconColor: Colors.brown,
  ),
  Transaction(
    id: 'tx2',
    name: 'Amazon',
    category: 'Shopping',
    amount: -67.50,
    date: DateTime.now().subtract(const Duration(days: 1)),
    icon: Icons.shopping_cart,
    iconColor: Colors.orange,
  ),
  Transaction(
    id: 'tx3',
    name: 'Uber Ride',
    category: 'Transportation',
    amount: -24.35,
    date: DateTime.now().subtract(const Duration(days: 1)),
    icon: Icons.directions_car,
    iconColor: AppColors.primary,
  ),
  Transaction(
    id: 'tx4',
    name: 'Salary Deposit',
    category: 'Income',
    amount: 2850.00,
    date: DateTime.now().subtract(const Duration(days: 3)),
    icon: Icons.account_balance_wallet,
    iconColor: Colors.green,
  ),
];