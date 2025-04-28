import 'package:finney/components/lanaguage_button.dart';
import 'package:finney/components/charts/chart_service.dart' as chart_service;
import 'package:finney/components/time_selector.dart';
import 'package:finney/localization/locales.dart';
import 'package:finney/pages/2-chatbot/utils/robot_animation.dart';
import 'package:finney/pages/3-dashboard/widgets/navigation_tiles.dart';
import 'package:finney/pages/3-dashboard/transaction/add_transaction/expense_or_income.dart';
import 'package:finney/pages/3-dashboard/utils/dashboard_help.dart';
import 'package:finney/pages/3-dashboard/transaction/view_transaction/recent_transactions.dart';
import 'package:flutter/material.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/pages/3-dashboard/widgets/balance_card.dart';
import 'package:finney/pages/3-dashboard/transaction/transaction_services.dart';
import 'package:finney/pages/3-dashboard/models/transaction_model.dart' hide CategoryExpense;
import 'package:flutter_localization/flutter_localization.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  final TransactionService _transactionService = TransactionService();
  final chart_service.ChartService _chartService = chart_service.ChartService();

  // Current time range for filtering data - make this accessible to other widgets
  static TimeRangeData currentTimeRange = TimeRangeData.month();
  
  double _currentBalance = 0.0;
  double _monthlyIncome = 0.0;
  double _monthlyExpenseTotal = 0.0;

  // Raw transaction data - always store all transactions
  List<TransactionModel> _transactions = [];
  
  bool _isLoading = true;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  void _onTimeRangeChanged(TimeRangeData newTimeRange) {
    setState(() {
      currentTimeRange = newTimeRange;
      _updateChartsForTimeRange();
    });
  }

  void _updateChartsForTimeRange() {
    // No data to update
    if (_transactions.isEmpty) return;

    // Update balance data
    _updateBalanceData();
  }
  
  void _updateBalanceData() {
    final filteredTransactions = _chartService.filterTransactionsByTimeRange(
      _transactions,
      currentTimeRange,
    );
    
    double income = 0.0;
    double expenses = 0.0;
    
    for (var transaction in filteredTransactions) {
      if (transaction.amount > 0) {
        income += transaction.amount;
      } else {
        expenses += transaction.amount.abs();
      }
    }
    
    setState(() {
      _monthlyIncome = income;
      _monthlyExpenseTotal = expenses;
      _currentBalance = income - expenses;
    });
  }

  Future<void> _loadDashboardData() async {
    if (_isRefreshing) return;

    try {
      setState(() {
        _isLoading = _transactions.isEmpty;
        _isRefreshing = true;
      });

      // Start listening for all transactions
      _transactionService.getTransactions().listen((transactions) {
        if (mounted) {
          setState(() {
            _transactions = transactions;
            _updateChartsForTimeRange();
            _isLoading = false;
            _isRefreshing = false;
          });
        }
      });
    } catch (e) {
      debugPrint('Error loading dashboard data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isRefreshing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocaleData.failedToLoadDashboardData.getString(context)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleTransactionAdded(TransactionModel transaction) {
    setState(() {
      _transactions.add(transaction);
      _updateChartsForTimeRange();

      if (transaction.id != null) {
        _transactionService.addTransaction(transaction);
      }
    });
  }

  void _handleDeleteTransaction(TransactionModel transaction) {
    setState(() {
      _transactions.remove(transaction);
      _updateChartsForTimeRange();

      if (transaction.id != null) {
        _transactionService.deleteTransaction(transaction.id!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        title: Text(
          LocaleData.chatbotTitle.getString(context),
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: true,
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: LanguageButton(showText: false),
          ),
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
                timeRange: currentTimeRange,
              ),
              TimeRangeSelector(
                initialTimeRange: currentTimeRange,
                onTimeRangeChanged: _onTimeRangeChanged,
              ),              
              RobotAnimationHeader(),
              const NavigationTiles(),
              _buildRecentTransactions(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.darkBlue,
        onPressed: () => _showAddTransactionModal(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildRecentTransactions() {
    final filteredTransactions = _chartService.filterTransactionsByTimeRange(
      _transactions,
      currentTimeRange,
    );
    
    // Pass time range data and callback
    return RecentTransactions(
      transactions: filteredTransactions,
      onDeleteTransaction: _handleDeleteTransaction,
      timeRange: currentTimeRange,
      onTimeRangeChanged: _onTimeRangeChanged,
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