import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/assets/widgets/dashboard/spending_bar_chart.dart';
import 'package:finney/assets/widgets/dashboard/category_pie_chart.dart';
import 'package:finney/services/transaction_services.dart' as services;
import 'package:finney/models/transaction_data.dart';
import 'package:finney/models/transaction_model.dart';
import 'package:finney/assets/widgets/savingsbudget/saving_pred_card.dart';
import 'package:finney/assets/widgets/savingsbudget/budget_pred_card.dart';
import 'dart:async';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => ReportScreenState();
}

class ReportScreenState extends State<ReportScreen> {
  final services.TransactionService _transactionService = services.TransactionService();

  List<TransactionModel> transactions = [];
  List<WeeklyExpense> _weeklyExpenses = [];
  List<CategoryExpense> categoryExpenses = [];

  late StreamSubscription<List<TransactionModel>> _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = _transactionService.getTransactions().listen((data) {
      setState(() {
        transactions = data;
        _calculateWeeklyExpenses();
        _calculateCategoryExpenses();
      });
    });
  }

  void _calculateWeeklyExpenses() {
    Map<String, double> weeklyMap = {};
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final orderedDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    for (var tx in transactions) {
      if (tx.date.isAfter(weekStart)) {
        String day = DateFormat('EEE').format(tx.date);
        weeklyMap[day] = (weeklyMap[day] ?? 0) + (tx.amount < 0 ? tx.amount.abs() : 0);
      }
    }

    _weeklyExpenses = orderedDays
        .map((day) => WeeklyExpense(day, weeklyMap[day] ?? 0))
        .toList();
  }

  void _calculateCategoryExpenses() {
    Map<String, double> categoryMap = {};

    for (var tx in transactions) {
      if (tx.amount < 0) {
        categoryMap[tx.category] =
            (categoryMap[tx.category] ?? 0) + tx.amount.abs();
      }
    }

    categoryExpenses = categoryMap.entries
        .map((e) => CategoryExpense(
              e.key,
              e.value,
              getColorForCategory(e.key),
              getIconForCategory(e.key),
            ))
        .toList();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.lightBackground,
    appBar: AppBar(
      title: const Text('Report'),
      backgroundColor: AppColors.lightBackground,
    ),
    body: transactions.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SpendingBarChart(
                  weeklyExpenses: _weeklyExpenses
                      .map((e) => services.WeeklyExpenseData(e.day, e.amount))
                      .toList(),
                ),
                const SizedBox(height: 20),
                SavingPredCard(transactions: transactions),
                const SizedBox(height: 20),
                BudgetPredCard(transactions: transactions),
                const SizedBox(height: 20),
                CategoryPieChart(categoryExpenses: categoryExpenses),
                const SizedBox(height: 20),
              ],
            ),
          ),
  );
}


  IconData getIconForCategory(String category) {
    switch (category) {
      case 'Shopping':
        return Icons.shopping_bag;
      case 'Food':
        return Icons.restaurant;
      case 'Entertainment':
        return Icons.movie;
      case 'Transport':
        return Icons.directions_car;
      case 'Health':
        return Icons.medical_services;
      case 'Utilities':
        return Icons.phone;
      default:
        return Icons.category_outlined;
    }
  }

  Color getColorForCategory(String category) {
    switch (category) {
      case 'Shopping':
        return const Color(0xFFFF9800);
      case 'Food':
        return const Color(0xFF2196F3);
      case 'Entertainment':
        return const Color(0xFFE91E63);
      case 'Transport':
        return const Color(0xFF4CAF50);
      case 'Health':
        return const Color(0xFFF44336);
      case 'Utilities':
        return const Color(0xFF9C27B0);
      default:
        return const Color(0xFF9E9E9E);
    }
  }
}
