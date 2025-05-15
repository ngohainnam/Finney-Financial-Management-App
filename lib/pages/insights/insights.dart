import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/components/charts/bar_chart.dart';
import 'package:finney/components/charts/chart_service.dart' as chart_service;
import 'package:finney/components/charts/pie/pie_chart.dart';
import 'package:finney/components/time_selector.dart';
import 'package:finney/pages/dashboard/dashboard.dart';
import 'package:finney/core/storage/local/models/transaction/transaction_model.dart';
import 'package:finney/pages/dashboard/transaction/transaction_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/assets/localization/locales.dart';

enum ChartViewType { expenses, income }

class Insights extends StatefulWidget {
  const Insights({super.key});

  @override
  State<Insights> createState() => _InsightsState();
}

class _InsightsState extends State<Insights> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TransactionService _transactionService = TransactionService();
  final chart_service.ChartService _chartService = chart_service.ChartService();
  
  List<TransactionModel> _transactions = [];
  List<chart_service.PeriodExpense> _periodExpenses = [];
  List<chart_service.PeriodExpense> _periodIncome = [];
  List<chart_service.CategoryExpense> _categoryExpenses = [];
  List<chart_service.CategoryExpense> _categoryIncome = [];
  TimeRangeData _currentTimeRange = DashboardState.currentTimeRange;
  
  // Add view type state
  ChartViewType _currentViewType = ChartViewType.expenses;
  
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    
    _transactionService.getTransactions().listen((transactions) {
      if (mounted) {
        setState(() {
          _transactions = transactions;
          _updateChartsForTimeRange();
          _isLoading = false;
        });
      }
    });
  }
  
  void _onTimeRangeChanged(TimeRangeData newTimeRange) {
    setState(() {
      _currentTimeRange = newTimeRange;
      _updateChartsForTimeRange();
      
      // Update the shared timeRange in Dashboard if needed
      DashboardState.currentTimeRange = newTimeRange;
    });
  }
  
  void _updateChartsForTimeRange() {
    if (_transactions.isEmpty) return;
    
    // Use ChartService to determine interval
    final interval = _chartService.getIntervalForTimeRange(_currentTimeRange);
    
    setState(() {
      // Update bar chart data - both expense and income
      _periodExpenses = _chartService.getPeriodExpenses(
        _transactions,
        _currentTimeRange,
        interval,
        context,
        transactionType: chart_service.TransactionType.expense,
      );
      
      _periodIncome = _chartService.getPeriodExpenses(
        _transactions,
        _currentTimeRange,
        interval,
        context,
        transactionType: chart_service.TransactionType.income,
      );
      
      // Update pie chart data - both expense and income
      _categoryExpenses = _chartService.getCategoryExpenses(
        _transactions,
        _currentTimeRange,
        transactionType: chart_service.TransactionType.expense,
      );
      
      _categoryIncome = _chartService.getCategoryExpenses(
        _transactions,
        _currentTimeRange,
        transactionType: chart_service.TransactionType.income,
      );
    });
  }
  
  // Add this method to build toggle buttons in the Insights page
  Widget _buildToggleButtons() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Expenses button
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _currentViewType = ChartViewType.expenses),
              child: Container(
                decoration: BoxDecoration(
                  color: _currentViewType == ChartViewType.expenses
                      ? Colors.redAccent
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  LocaleData.expenses.getString(context),
                  style: TextStyle(
                    color: _currentViewType == ChartViewType.expenses
                        ? Colors.white
                        : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          
          // Income button
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _currentViewType = ChartViewType.income),
              child: Container(
                decoration: BoxDecoration(
                  color: _currentViewType == ChartViewType.income
                      ? Colors.green
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  LocaleData.income.getString(context),
                  style: TextStyle(
                    color: _currentViewType == ChartViewType.income
                        ? Colors.white
                        : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get current data based on selected view
    final currentPeriodData = _currentViewType == ChartViewType.expenses 
        ? _periodExpenses 
        : _periodIncome;
        
    final currentCategoryData = _currentViewType == ChartViewType.expenses
        ? _categoryExpenses
        : _categoryIncome;

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        title: Text(
          LocaleData.insights.getString(context),
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          tabs:  [
            Tab(
              icon: Icon(Icons.bar_chart),
              text: LocaleData.spendingAnalysis.getString(context),
            ),
            Tab(
              icon: Icon(Icons.pie_chart),
              text: LocaleData.categoryBreakdown.getString(context),
            ),
          ],
        ),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Time selector and toggle buttons
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TimeRangeSelector(
                        initialTimeRange: _currentTimeRange,
                        onTimeRangeChanged: _onTimeRangeChanged,
                      ),
                      const SizedBox(height: 16),
                      _buildToggleButtons(),
                    ],
                  ),
                ),
                
                // Tab content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Bar Chart Tab
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: UnifiedBarChart(
                          title: _currentViewType == ChartViewType.expenses 
                              ? LocaleData.expenseAnalysis.getString(context)
                              : LocaleData.incomeAnalysis.getString(context),
                          periodExpenses: currentPeriodData,
                          interval: _chartService.getIntervalForTimeRange(_currentTimeRange),
                          timeRange: _currentTimeRange,
                          viewType: _currentViewType,
                        ),
                      ),
                      
                      // Pie Chart Tab
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: CategoryPieChart(
                          categoryData: _chartService.convertCategoryExpensesToMap(currentCategoryData),
                          viewType: _currentViewType,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}