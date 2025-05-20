import 'package:finney/shared/widgets/common/chatbot_bar.dart';
import 'package:finney/pages/7-insights/components/charts/chart_service.dart' as chart_service;
import 'package:finney/pages/7-insights/components/time_selector.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:finney/core/storage/cloud/service/transaction_cloud_service.dart';
import 'package:finney/pages/2-chatbot/chatbot.dart';
import 'package:finney/pages/2-chatbot/utils/robot_animation.dart';
import 'package:finney/pages/3-dashboard/widgets/navigation_tiles.dart';
import 'package:finney/pages/6-transaction/add_transaction/expense_or_income.dart';
import 'package:finney/pages/3-dashboard/utils/dashboard_help.dart';
import 'package:finney/pages/6-transaction/view_transaction/recent_transactions.dart';
import 'package:flutter/material.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:finney/pages/3-dashboard/widgets/balance_card.dart';
import 'package:finney/core/storage/storage_manager.dart'; // Added for singleton access
import 'package:finney/core/storage/cloud/models/transaction_model.dart' hide CategoryExpense;
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/shared/widgets/common/snack_bar.dart'; // Added for snackbars

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  late final TransactionCloudService _transactionService; 
  final chart_service.ChartService _chartService = chart_service.ChartService();

  static TimeRangeData currentTimeRange = TimeRangeData.month();

  double _currentBalance = 0.0;
  double _monthlyIncome = 0.0;
  double _monthlyExpenseTotal = 0.0;

  List<TransactionModel> _transactions = [];

  bool _isLoading = true;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    // Get the transaction service from StorageManager
    _transactionService = StorageManager().transactionService;
    _loadDashboardData();
  }

  void _onTimeRangeChanged(TimeRangeData newTimeRange) {
    setState(() {
      currentTimeRange = newTimeRange;
      _updateChartsForTimeRange();
    });
  }

  void _updateChartsForTimeRange() {
    if (_transactions.isEmpty) return;

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

      _transactionService.getTransactions().listen((transactions) {
        if (mounted) {
          setState(() {
            _transactions = transactions;
            _updateChartsForTimeRange();
            _isLoading = false;
            _isRefreshing = false;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _isRefreshing = false;
          });
          // Use AppSnackBar for error messages
          AppSnackBar.showError(
            context,
            message: LocaleData.failedToLoadDashboardData.getString(context),
          );
        }
      });
    } catch (e) {
      debugPrint('Error loading dashboard data: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isRefreshing = false;
        });

        // Use AppSnackBar for error messages
        AppSnackBar.showError(
          context,
          message: LocaleData.failedToLoadDashboardData.getString(context),
        );
      }
    }
  }

  void _handleTransactionAdded(TransactionModel transaction) {
    setState(() {
      _transactions.add(transaction);
      _updateChartsForTimeRange();
    });

    // Use the core transaction service to add the transaction
    // No need to check if id is null as the service will generate one
    _transactionService.addTransaction(transaction).then((_) {
      if (mounted) {
        AppSnackBar.showSuccess(
          context,
          message: LocaleData.transactionSaved.getString(context),
        );
      }
    }).catchError((error) {
      debugPrint('Error adding transaction: $error');
      if (mounted) {
        AppSnackBar.showError(
          context,
          message: LocaleData.failedToSaveTransaction.getString(context),
        );
      }
    });
  }

  void _handleDeleteTransaction(TransactionModel transaction) {
    // Remove from local state first for immediate UI update
    setState(() {
      _transactions.remove(transaction);
      _updateChartsForTimeRange();
    });

    // Then delete from storage
    if (transaction.id != null) {
      _transactionService.deleteTransaction(transaction.id!).then((_) {
        if (mounted) {
          AppSnackBar.showSuccess(
            context,
            message: LocaleData.transactionDeleted.getString(context),
          );
        }
      }).catchError((error) {
        debugPrint('Error deleting transaction: $error');
        if (mounted) {
          // Add back to local state if deletion fails
          setState(() {
            _transactions.add(transaction);
            _updateChartsForTimeRange();
          });
          
          AppSnackBar.showError(
            context,
            message: LocaleData.failedToDeleteTransaction.getString(context),
          );
        }
      });
    }
  }

  void _navigateToChatbot(String question) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chatbot(initialQuestion: question),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        title: Text(
          LocaleData.chatbotTitle.getString(context), 
          style: const TextStyle( // Added const
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
        : Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
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
                            const RobotAnimationHeader(), // Added const
                            const NavigationTiles(),
                            _buildRecentTransactions(),
                            // Add extra padding at the bottom to ensure content isn't hidden behind the chatbot bar
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Chatbot bar at the bottom
                  AppNavbar(onSearchSubmitted: _navigateToChatbot),
                ],
              ),

              Positioned(
                right: 16,
                bottom: 90, // Position above the chatbot bar
                child: FloatingActionButton(
                  backgroundColor: AppColors.darkBlue,
                  onPressed: () => _showAddTransactionModal(context),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildRecentTransactions() {
    final filteredTransactions = _chartService.filterTransactionsByTimeRange(
      _transactions,
      currentTimeRange,
    );

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