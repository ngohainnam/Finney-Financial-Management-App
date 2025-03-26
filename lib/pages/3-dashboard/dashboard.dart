import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/pages/3-dashboard/widgets/balance_card.dart';
import 'package:finney/pages/3-dashboard/widgets/spending_chart.dart';
import 'package:finney/pages/3-dashboard/widgets/category_breakdown.dart';
import 'package:finney/pages/3-dashboard/transactions/add_income_screen.dart';
import 'package:finney/pages/3-dashboard/transactions/add_expense_screen.dart';
import 'package:finney/services/transaction_services.dart' as services;
import 'package:finney/pages/3-dashboard/models/transaction_data.dart';
import 'package:finney/models/transaction_model.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  final services.TransactionService _transactionService = services.TransactionService();

  double _currentBalance = 0.0;
  double _monthlyIncome = 0.0;
  double _monthlyExpenses = 0.0;

  List<WeeklyExpense> _weeklyExpenses = [];
  List<CategoryExpense> _categoryExpenses = [];
  List<Transaction> _recentTransactions = [];

  bool _isLoading = true;
  bool _isRefreshing = false;

  // Cache the data
  final Map<String, IconData> _categoryIconCache = {};
  final Map<String, Color> _categoryColorCache = {};

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    if (_isRefreshing) return; // Prevent multiple simultaneous refreshes

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
      ]);

      final monthlyIncome = results[0] as double;
      final monthlyExpenses = results[1] as double;
      final weeklyExpensesData = results[2] as List<dynamic>;
      final categoryExpensesData = results[3] as List<dynamic>;

      // Convert data
      final weeklyExpenses = weeklyExpensesData.map((data) =>
          WeeklyExpense(data.day, data.amount)
      ).toList();

      final categoryExpenses = categoryExpensesData.map((data) =>
          CategoryExpense(data.name, data.amount, data.color, data.icon)
      ).toList();

      if (_recentTransactions.isEmpty) {
        _transactionService.getTransactions().listen((transactionModels) {
          if (mounted) {
            final transactions = transactionModels.take(5).map((model) {
              return Transaction(
                id: model.id ?? '',
                name: model.name,
                category: model.category,
                amount: model.amount,
                date: model.date,
                icon: _getIconForCategory(model.category),
                iconColor: _getColorForCategory(model.category),
              );
            }).toList();

            setState(() {
              _recentTransactions = transactions;
            });
          }
        });
      }

      // Update state with fetched data
      setState(() {
        _monthlyIncome = monthlyIncome;
        _monthlyExpenses = monthlyExpenses;
        _weeklyExpenses = weeklyExpenses;
        _categoryExpenses = categoryExpenses;
        _currentBalance = monthlyIncome - monthlyExpenses;
        _isLoading = false;
        _isRefreshing = false;
      });
    } catch (e) {
      debugPrint('Error loading dashboard data: $e');
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

  // Optimized to use cache
  IconData _getIconForCategory(String category) {
    if (_categoryIconCache.containsKey(category)) {
      return _categoryIconCache[category]!;
    }

    IconData icon;
    switch (category) {
      case 'Shopping':
        icon = Icons.shopping_bag;
      case 'Food':
        icon = Icons.restaurant;
      case 'Entertainment':
        icon = Icons.movie;
      case 'Transport':
        icon = Icons.directions_car;
      case 'Health':
        icon = Icons.medical_services;
      case 'Utilities':
        icon = Icons.phone;
      default:
        icon = Icons.category_outlined;
    }

    _categoryIconCache[category] = icon;
    return icon;
  }

  Color _getColorForCategory(String category) {
    if (_categoryColorCache.containsKey(category)) {
      return _categoryColorCache[category]!;
    }

    Color color;
    switch (category) {
      case 'Shopping':
        color = const Color(0xFFFF9800);
      case 'Food':
        color = const Color(0xFF2196F3);
      case 'Entertainment':
        color = const Color(0xFFE91E63);
      case 'Transport':
        color = const Color(0xFF4CAF50);
      case 'Health':
        color = const Color(0xFFF44336);
      case 'Utilities':
        color = const Color(0xFF9C27B0);
      default:
        color = const Color(0xFF9E9E9E);
    }

    _categoryColorCache[category] = color;
    return color;
  }

  // Handle optimistic updates by immediately adding new transaction
  void _handleTransactionAdded(TransactionModel model) {
    final transaction = Transaction(
      id: DateTime.now().toString(),
      name: model.name,
      category: model.category,
      amount: model.amount,
      date: model.date,
      icon: _getIconForCategory(model.category),
      iconColor: _getColorForCategory(model.category),
    );

    setState(() {
      // Update balance immediately
      if (model.amount > 0) {
        _monthlyIncome += model.amount;
      } else {
        _monthlyExpenses += model.amount.abs();
      }
      _currentBalance = _monthlyIncome - _monthlyExpenses;

      // Add to recent transactions
      _recentTransactions = [transaction, ..._recentTransactions.take(4)];

      // Update weekly expenses if it's an expense
      if (model.amount < 0) {
        final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        final dayIndex = model.date.weekday - 1;

        final updatedWeeklyExpenses = List<WeeklyExpense>.from(_weeklyExpenses);
        final currentDayExpense = updatedWeeklyExpenses[dayIndex];

        updatedWeeklyExpenses[dayIndex] = WeeklyExpense(
            dayNames[dayIndex],
            currentDayExpense.amount + model.amount.abs()
        );

        _weeklyExpenses = updatedWeeklyExpenses;
      }

      // Update category expenses if it's an expense
      if (model.amount < 0) {
        final existingCategoryIndex = _categoryExpenses.indexWhere(
                (expense) => expense.name == model.category
        );

        if (existingCategoryIndex != -1) {
          // Update existing category
          final updatedCategoryExpenses = List<CategoryExpense>.from(_categoryExpenses);
          final existingCategory = updatedCategoryExpenses[existingCategoryIndex];

          updatedCategoryExpenses[existingCategoryIndex] = CategoryExpense(
              existingCategory.name,
              existingCategory.amount + model.amount.abs(),
              existingCategory.color,
              existingCategory.icon
          );

          _categoryExpenses = updatedCategoryExpenses;
        } else {
          // Add new category
          _categoryExpenses.add(CategoryExpense(
              model.category,
              model.amount.abs(),
              _getColorForCategory(model.category),
              _getIconForCategory(model.category)
          ));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboardData,
            tooltip: 'Refresh Dashboard',
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
                expenses: _monthlyExpenses,
              ),
              const SizedBox(height: 20),
              SpendingChart(
                  weeklyExpenses: _weeklyExpenses.map((e) =>
                      services.WeeklyExpenseData(e.day, e.amount)
                  ).toList()
              ),
              const SizedBox(height: 20),
              CategoryBreakdown(categoryExpenses: _categoryExpenses),
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
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                },
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _recentTransactions.isEmpty
              ? const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'No transactions yet',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
              : Column(
            children: _recentTransactions.map((transaction) {
              return _buildTransactionItem(transaction);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final dateFormat = DateFormat('MMM d, h:mm a');
    final isIncome = transaction.amount > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: transaction.iconColor.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              transaction.icon,
              color: transaction.iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.category,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isIncome
                    ? '+${currencyFormat.format(transaction.amount)}'
                    : currencyFormat.format(transaction.amount),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isIncome ? Colors.green : null,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                dateFormat.format(transaction.date),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddTransactionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add Transaction',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOptionButton(
                  context: context,
                  label: 'Expense',
                  icon: Icons.remove_circle_outline,
                  color: Colors.red,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddExpenseScreen(
                              onExpenseAdded: _handleTransactionAdded,
                            )
                        )
                    );
                  },
                ),
                _buildOptionButton(
                  context: context,
                  label: 'Income',
                  icon: Icons.add_circle_outline,
                  color: Colors.green,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddIncomeScreen(
                              onIncomeAdded: _handleTransactionAdded,
                            )
                        )
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final backgroundColor = const Color(0xFFF5F5F5);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 1),
            ),
            child: Center(
              child: Icon(
                icon,
                color: color,
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}