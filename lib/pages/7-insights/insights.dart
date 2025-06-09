import 'package:finney/shared/localization/localized_number_formatter.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:finney/pages/7-insights/components/charts/bar_chart.dart';
import 'package:finney/pages/7-insights/components/charts/chart_service.dart' as chart_service;
import 'package:finney/pages/7-insights/components/charts/pie/pie_chart.dart';
import 'package:finney/pages/7-insights/components/time_selector.dart';
import 'package:finney/core/storage/cloud/service/transaction_cloud_service.dart';
import 'package:finney/pages/3-dashboard/dashboard.dart';
import 'package:finney/core/storage/cloud/models/transaction_model.dart';
import 'package:finney/core/storage/storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:finney/shared/widgets/common/snack_bar.dart';
import 'package:finney/shared/widgets/common/settings_notifier.dart';

enum ChartViewType { expenses, income }

class Insights extends StatefulWidget {
  const Insights({super.key});

  @override
  State<Insights> createState() => _InsightsState();
}

class _InsightsState extends State<Insights> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final TransactionCloudService _transactionService;
  final chart_service.ChartService _chartService = chart_service.ChartService();

  List<TransactionModel> _transactions = [];
  List<chart_service.PeriodExpense> _periodExpenses = [];
  List<chart_service.PeriodExpense> _periodIncome = [];
  List<chart_service.CategoryExpense> _categoryExpenses = [];
  List<chart_service.CategoryExpense> _categoryIncome = [];
  TimeRangeData _currentTimeRange = DashboardState.currentTimeRange;

  ChartViewType _currentViewType = ChartViewType.expenses;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _transactionService = StorageManager().transactionService;
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

    try {
      _transactionService.getTransactions().listen(
        (transactions) {
          if (mounted) {
            setState(() {
              _transactions = transactions;
              _updateChartsForTimeRange();
              _isLoading = false;
            });
          }
        },
        onError: (error) {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
            AppSnackBar.showError(
              context,
              message: 'Error loading transactions: ${error.toString()}',
            );
          }
        }
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        AppSnackBar.showError(
          context,
          message: 'Error loading transactions: ${e.toString()}',
        );
      }
    }
  }

  void _onTimeRangeChanged(TimeRangeData newTimeRange) {
    setState(() {
      _currentTimeRange = newTimeRange;
      _updateChartsForTimeRange();
      DashboardState.currentTimeRange = newTimeRange;
    });
  }

  void _updateChartsForTimeRange() {
    if (_transactions.isEmpty) return;

    final interval = _chartService.getIntervalForTimeRange(_currentTimeRange);

    setState(() {
      if (_currentTimeRange.range == TimeRange.allTime) {
        // Group by year for all time, each year is a bar
        _periodExpenses = _groupByYear(_transactions, chart_service.TransactionType.expense);
        _periodIncome = _groupByYear(_transactions, chart_service.TransactionType.income);
      } else {
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
      }

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

  // Use 'isIncome' property from TransactionModel for type check
  List<chart_service.PeriodExpense> _groupByYear(
      List<TransactionModel> transactions, chart_service.TransactionType type) {
    final Map<int, double> yearTotals = {};
    for (final tx in transactions) {
      // For expenses, amount < 0 or isIncome == false
      // For income, amount > 0 or isIncome == true
      if (type == chart_service.TransactionType.all ||
          (type == chart_service.TransactionType.expense && !tx.isIncome) ||
          (type == chart_service.TransactionType.income && tx.isIncome)) {
        final year = tx.date.year;
        yearTotals[year] = (yearTotals[year] ?? 0) + tx.amount.abs();
      }
    }
    final years = yearTotals.keys.toList()..sort();
    return years
        .map((year) => chart_service.PeriodExpense(
              period: LocalizedNumberFormatter.formatNumber(year.toString(), context),
              amount: yearTotals[year]!,
            ))
        .toList();
  }

  Widget _buildToggleButtons() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(25),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
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
    final currentPeriodData = _currentViewType == ChartViewType.expenses
        ? _periodExpenses
        : _periodIncome;
    final currentCategoryData = _currentViewType == ChartViewType.expenses
        ? _categoryExpenses
        : _categoryIncome;

    return ValueListenableBuilder<String>(
      valueListenable: SettingsNotifier().textSizeNotifier,
      builder: (context, textSize, child) {
        double textScaleFactor;
        switch (textSize) {
          case 'Small':
            textScaleFactor = 0.8;
            break;
          case 'Large':
            textScaleFactor = 1.2;
            break;
          default:
            textScaleFactor = 1.0;
        }
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScaleFactor),
          ),
          child: Scaffold(
            backgroundColor: AppColors.lightBackground,
            appBar: AppBar(
              backgroundColor: AppColors.lightBackground,
              title: Text(
                LocaleData.insights.getString(context),
                style: const TextStyle(
                  color: AppColors.darkBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  letterSpacing: 1.2,
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                labelColor: AppColors.darkBlue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: AppColors.darkBlue,
                tabs: [
                  Tab(
                    icon: const Icon(Icons.bar_chart),
                    text: LocaleData.spendingAnalysis.getString(context),
                  ),
                  Tab(
                    icon: const Icon(Icons.pie_chart),
                    text: LocaleData.categoryBreakdown.getString(context),
                  ),
                ],
              ),
            ),
            body: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2))
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            TimeRangeSelector(
                              initialTimeRange: _currentTimeRange,
                              onTimeRangeChanged: _onTimeRangeChanged,
                              firstTransactionDate: _transactions.isNotEmpty
                                  ? _transactions.map((t) => t.date).reduce((a, b) => a.isBefore(b) ? a : b)
                                  : DateTime.now(),
                            ),
                            const SizedBox(height: 16),
                            _buildToggleButtons(),
                          ],
                        ),
                      ),
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
          ),
        );
      },
    );
  }
}