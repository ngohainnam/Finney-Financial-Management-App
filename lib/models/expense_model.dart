import 'package:flutter/material.dart';
import 'package:visualize_infinance/utils/constants.dart';

class ExpenseData {
  final String day;
  final double amount;

  ExpenseData(this.day, this.amount);
}

class CategoryExpense {
  final String name;
  final double amount;
  final Color color;
  final IconData icon;

  CategoryExpense(this.name, this.amount, this.color, this.icon);
}

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

  // Factory constructor to create a Transaction from Firebase data
  factory Transaction.fromMap(Map<String, dynamic> map, String id) {
    return Transaction(
      id: id,
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      date: map['date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['date'])
          : DateTime.now(),
      icon: _getCategoryIcon(map['category'] ?? ''),
      iconColor: _getCategoryColor(map['category'] ?? ''),
    );
  }

  // Convert to a map for Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'amount': amount,
      'date': date.millisecondsSinceEpoch,
    };
  }

  // Get icon for a category
  static IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food & dining':
        return Icons.restaurant;
      case 'transportation':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_cart;
      case 'bills & utilities':
        return Icons.receipt_long;
      case 'entertainment':
        return Icons.movie;
      case 'income':
        return Icons.account_balance_wallet;
      case 'other':
        return Icons.category;
      default:
        return Icons.attach_money;
    }
  }

  // Get color for a category
  static Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food & dining':
        return AppColors.foodColor;
      case 'transportation':
        return AppColors.transportColor;
      case 'shopping':
        return AppColors.shoppingColor;
      case 'bills & utilities':
        return AppColors.billsColor;
      case 'entertainment':
        return AppColors.entertainmentColor;
      case 'income':
        return Colors.green;
      case 'other':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }
}

class QuickAction {
  final String label;
  final IconData icon;
  final Color color;
  final Function() onTap;

  QuickAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

// Sample data for the app
class DummyData {
  // Weekly expenses data over the last 7 days
  static List<ExpenseData> getWeeklyExpenses() {
    return [
      ExpenseData('Mon', 42.50),
      ExpenseData('Tue', 65.20),
      ExpenseData('Wed', 31.80),
      ExpenseData('Thu', 87.40),
      ExpenseData('Fri', 91.30),
      ExpenseData('Sat', 132.60),
      ExpenseData('Sun', 50.40),
    ];
  }

  // Monthly expenses by category
  static List<CategoryExpense> getCategoryExpenses() {
    return [
      CategoryExpense('Food & Dining', 650.00, AppColors.foodColor, Icons.restaurant),
      CategoryExpense('Transportation', 320.00, AppColors.transportColor, Icons.directions_car),
      CategoryExpense('Shopping', 430.00, AppColors.shoppingColor, Icons.shopping_cart),
      CategoryExpense('Bills & Utilities', 580.00, AppColors.billsColor, Icons.receipt_long),
      CategoryExpense('Entertainment', 250.00, AppColors.entertainmentColor, Icons.movie),
    ];
  }

  // Recent transaction data
  static List<Transaction> getRecentTransactions() {
    final now = DateTime.now();

    return [
      Transaction(
        id: 'tx1',
        name: 'Starbucks Coffee',
        category: 'Food & Dining',
        amount: -4.80,
        date: DateTime(now.year, now.month, now.day, 9, 30),
        icon: Icons.coffee,
        iconColor: Colors.brown,
      ),
      Transaction(
        id: 'tx2',
        name: 'Amazon',
        category: 'Shopping',
        amount: -67.50,
        date: DateTime(now.year, now.month, now.day - 1, 14, 15),
        icon: Icons.shopping_cart,
        iconColor: Colors.orange,
      ),
      Transaction(
        id: 'tx3',
        name: 'Uber Ride',
        category: 'Transportation',
        amount: -24.35,
        date: DateTime(now.year, now.month, now.day - 1, 19, 45),
        icon: Icons.directions_car,
        iconColor: AppColors.transportColor,
      ),
      Transaction(
        id: 'tx4',
        name: 'Electric Bill',
        category: 'Bills & Utilities',
        amount: -87.20,
        date: DateTime(now.year, now.month, now.day - 2, 10, 0),
        icon: Icons.bolt,
        iconColor: Colors.amber,
      ),
      Transaction(
        id: 'tx5',
        name: 'Salary Deposit',
        category: 'Income',
        amount: 2850.00,
        date: DateTime(now.year, now.month, 1, 8, 0),
        icon: Icons.account_balance_wallet,
        iconColor: Colors.green,
      ),
      Transaction(
        id: 'tx6',
        name: 'Spotify Premium',
        category: 'Entertainment',
        amount: -9.99,
        date: DateTime(now.year, now.month, 3, 12, 30),
        icon: Icons.music_note,
        iconColor: AppColors.entertainmentColor,
      ),
    ];
  }

  // Financial summary data
  static Map<String, double> getFinancialSummary() {
    return {
      'totalBalance': 12680.50,
      'monthlyIncome': 3520.80,
      'monthlyExpenses': 2230.40,
    };
  }

  // Get available categories
  static List<String> getCategories() {
    return [
      'Food & Dining',
      'Transportation',
      'Shopping',
      'Bills & Utilities',
      'Entertainment',
      'Income',
      'Other'
    ];
  }
}