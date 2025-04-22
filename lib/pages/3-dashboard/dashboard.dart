import 'package:finney/pages/3-dashboard/widgets/navigation_tiles.dart';
import 'package:finney/pages/3-dashboard/transaction/add_transaction/expense_or_income.dart';
import 'package:finney/pages/3-dashboard/services/chart_service.dart';
import 'package:finney/pages/3-dashboard/utils/dashboard_help.dart';
import 'package:finney/pages/3-dashboard/transaction/view_transaction/recent_transactions.dart';
import 'package:flutter/material.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/pages/3-dashboard/widgets/balance_card.dart';
import 'package:finney/pages/3-dashboard/widgets/charts/spending_bar_chart.dart';
import 'package:finney/pages/3-dashboard/widgets/charts/category_pie_chart.dart';
import 'package:finney/pages/3-dashboard/widgets/charts/monthly_expense_chart.dart';
import 'package:finney/pages/3-dashboard/services/transaction_services.dart';
import 'package:finney/pages/3-dashboard/models/transaction_model.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  final TransactionService _transactionService = TransactionService();
  final ChartService _chartService = ChartService();

  double _currentBalance = 0.0;
  double _monthlyIncome = 0.0;
  double _monthlyExpenseTotal = 0.0;

  List<WeeklyExpense> _weeklyExpenses = [];
  List<CategoryExpense> _categoryExpenses = [];
  List<MonthlyExpense> _monthlyExpenseList = [];
  List<TransactionModel> _recentTransactions = [];

  bool _isLoading = true;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    if (_isRefreshing) return;

    try {
      setState(() {
        _isLoading = _recentTransactions.isEmpty;
        _isRefreshing = true;
      });

      final results = await Future.wait([
        _transactionService.getCurrentMonthIncome(),
        _transactionService.getCurrentMonthExpenses(),
        _transactionService.getWeeklyExpenses(),
        _transactionService.getCategoryExpenses(),
        _transactionService.getMonthlyExpenses(),
      ]);

      if (_recentTransactions.isEmpty) {
        _transactionService.getTransactions().listen((transactions) {
          if (mounted) {
            setState(() {
              _recentTransactions = transactions;
            });
          }
        });
      }

      if (mounted) {
        setState(() {
          _monthlyIncome = results[0] as double;
          _monthlyExpenseTotal = results[1] as double;
          _weeklyExpenses = results[2] as List<WeeklyExpense>;
          _categoryExpenses = results[3] as List<CategoryExpense>;
          _monthlyExpenseList = results[4] as List<MonthlyExpense>;
          _currentBalance = _monthlyIncome - _monthlyExpenseTotal;
          _isLoading = false;
          _isRefreshing = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading dashboard data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isRefreshing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load dashboard data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleTransactionAdded(TransactionModel transaction) {
    setState(() {
      _recentTransactions.add(transaction);

      if (transaction.isIncome) {
        _monthlyIncome += transaction.amount;
      } else {
        _monthlyExpenseTotal += transaction.amount.abs();
      }
      _currentBalance = _monthlyIncome - _monthlyExpenseTotal;

      if (transaction.id != null) {
        _transactionService.addTransaction;
      }

      _weeklyExpenses = _chartService.updateWeeklyExpenses(
        transaction: transaction,
        currentWeeklyExpenses: _weeklyExpenses,
        isDelete: false,
      );

      _categoryExpenses = _chartService.updateCategoryExpenses(
        transaction: transaction,
        currentCategoryExpenses: _categoryExpenses,
        isDelete: false,
      );
    });
  }

  void _handleDeleteTransaction(TransactionModel transaction) {
    setState(() {
      _recentTransactions.remove(transaction);

      if (transaction.isIncome) {
        _monthlyIncome -= transaction.amount;
      } else {
        _monthlyExpenseTotal -= transaction.amount.abs();
      }
      _currentBalance = _monthlyIncome - _monthlyExpenseTotal;

      if (transaction.id != null) {
        _transactionService.deleteTransaction(transaction.id!);
      }

      _weeklyExpenses = _chartService.updateWeeklyExpenses(
        transaction: transaction,
        currentWeeklyExpenses: _weeklyExpenses,
        isDelete: true,
      );

      _categoryExpenses = _chartService.updateCategoryExpenses(
        transaction: transaction,
        currentCategoryExpenses: _categoryExpenses,
        isDelete: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        title: Text(
          'Finney AI',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => DashboardHelp.show(context),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadDashboardData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BalanceCard(
                balance: _currentBalance,
                income: _monthlyIncome,
                expenses: _monthlyExpenseTotal,
              ),
              const SizedBox(height: 20),
              const NavigationTiles(),
              const SizedBox(height: 20),
              MonthlyExpenseChart(monthlyExpenses: _monthlyExpenseList),
              const SizedBox(height: 20),
              SpendingBarChart(weeklyExpenses: _weeklyExpenses),
              const SizedBox(height: 20),
              CategoryPieChart(categoryExpenses: _categoryExpenses),
              const SizedBox(height: 20),
              _buildRecentTransactions(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _showAddTransactionModal(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return RecentTransactions(
      transactions: _recentTransactions,
      onDeleteTransaction: _handleDeleteTransaction,
    );
  }

  void _showAddTransactionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddTransactionModal(
        onTransactionAdded: _handleTransactionAdded,
      ),
    );
  }
}