import 'package:finney/pages/7-insights/components/charts/chart_service.dart';
import 'package:finney/pages/7-insights/components/time_selector.dart';
import 'package:finney/pages/7-insights/chart_query.dart';
import 'package:finney/pages/7-insights/insights.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:flutter_localization/flutter_localization.dart';

class UnifiedBarChart extends StatefulWidget {
  final String title;
  final List<PeriodExpense> periodExpenses;
  final ChartInterval interval;
  final TimeRangeData timeRange;
  final ChartViewType viewType;

  const UnifiedBarChart({
    super.key,
    required this.title,
    required this.periodExpenses,
    required this.interval,
    required this.timeRange,
    required this.viewType,
  });

  @override
  State<UnifiedBarChart> createState() => _UnifiedBarChartState();
}

class _UnifiedBarChartState extends State<UnifiedBarChart> with SingleTickerProviderStateMixin {
  int _currentPage = 0;
  String? _selectedPeriodInfo;
  int? _selectedBarIndex;
  late AnimationController _animationController;
  late Animation<double> _animation;

  final int _itemsPerPage = 12;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(UnifiedBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.periodExpenses != oldWidget.periodExpenses ||
        widget.timeRange.range != oldWidget.timeRange.range) {
      _currentPage = 0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color get _barColor {
    return widget.viewType == ChartViewType.income
        ? Colors.green
        : Colors.redAccent;
  }

  int get _totalPages {
    return (widget.periodExpenses.length / _itemsPerPage).ceil().clamp(1, 999);
  }

  List<PeriodExpense> get _currentPageData {
    if (widget.periodExpenses.isEmpty) return [];
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex = (startIndex + _itemsPerPage).clamp(0, widget.periodExpenses.length);
    return widget.periodExpenses.sublist(startIndex, endIndex);
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      setState(() => _currentPage++);
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
    }
  }

  String _formatFullDate(String period, ChartInterval interval) {
    if (widget.timeRange.range == TimeRange.allTime) {
      return period;
    }
    final now = DateTime.now();
    switch (interval) {
      case ChartInterval.week:
        final weekday = period.toLowerCase();
        final weekdayIndex = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'].indexOf(weekday);
        final daysToSubtract = now.weekday - (weekdayIndex + 1);
        final date = now.subtract(Duration(days: daysToSubtract));
        return DateFormat('EEEE, MMMM d, yyyy').format(date);
      case ChartInterval.month:
        final day = int.tryParse(period) ?? 1;
        final date = DateTime(now.year, now.month, day);
        return DateFormat('EEEE, MMMM d, yyyy').format(date);
      case ChartInterval.year:
        final month = period.toLowerCase();
        final monthIndex = ['january', 'february', 'march', 'april', 'may', 'june', 'july', 'august', 'september', 'october', 'november', 'december'].indexOf(month);
        final date = DateTime(now.year, monthIndex + 1, 1);
        return DateFormat('MMMM yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '৳');
    final totalAmount = _currentPageData.isEmpty
        ? 0.0
        : _currentPageData.fold(0.0, (sum, expense) => sum + expense.amount);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(currencyFormat, totalAmount),
          const SizedBox(height: 8),
          if (_currentPageData.isEmpty)
            _buildEmptyState()
          else
            _buildChart(currencyFormat),
          ChartQuery(
            chartData: _getChartDataForLLM(),
            chartType: 'bar chart',
            viewType: widget.viewType == ChartViewType.expenses ? 'expenses' : 'income',
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(NumberFormat currencyFormat, double totalAmount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${LocaleData.total.getString(context)}: ${currencyFormat.format(totalAmount)}',
          style: TextStyle(
            color: _barColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Text(
          widget.viewType == ChartViewType.income
              ? LocaleData.noIncomeData.getString(context)
              : LocaleData.noExpenseData.getString(context),
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildChart(NumberFormat currencyFormat) {
    return Column(
      children: [
        SizedBox(
          height: 250,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: _calculateMaxY(_currentPageData),
              titlesData: _buildTitlesData(currencyFormat),
              gridData: _buildGridData(),
              borderData: FlBorderData(show: false),
              barGroups: _buildBarGroups(),
              barTouchData: _buildBarTouchData(currencyFormat),
            ),
            swapAnimationDuration: const Duration(milliseconds: 150),
            swapAnimationCurve: Curves.linear,
          ),
        ),
        if (_totalPages > 1)
          _buildPagination(),
        const SizedBox(height: 16),
        _buildSummaryText(currencyFormat),
      ],
    );
  }

  Widget _buildSummaryText(NumberFormat currencyFormat) {
    if (_currentPageData.isEmpty) return const SizedBox.shrink();

    if (_selectedPeriodInfo != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          _selectedPeriodInfo!,
          style: const TextStyle(
            fontSize: 14,
            height: 1.5,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    return const SizedBox.shrink();
  }

  FlTitlesData _buildTitlesData(NumberFormat currencyFormat) {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index >= 0 && index < _currentPageData.length) {
              final label = _currentPageData[index].period;
              final displayLabel = label.length > 5 ? label.substring(0, 5) : label;
              return SideTitleWidget(
                axisSide: meta.axisSide,
                space: 8,
                child: Text(
                  displayLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              );
            }
            return const SizedBox();
          },
          reservedSize: 30,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
          getTitlesWidget: (value, meta) {
            if (value == 0) return const SizedBox();
            return SideTitleWidget(
              axisSide: meta.axisSide,
              space: 8,
              child: Text(
                currencyFormat.format(value),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            );
          },
          interval: _calculateYAxisInterval(_currentPageData),
          reservedSize: 60,
        ),
      ),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  FlGridData _buildGridData() {
    return FlGridData(
      show: false,
      drawVerticalLine: false,
      horizontalInterval: _calculateYAxisInterval(_currentPageData),
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.grey.withOpacity(0.2),
          strokeWidth: 1,
          dashArray: [5, 5],
        );
      },
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return _currentPageData.asMap().entries.map((entry) {
      final isSelected = entry.key == _selectedBarIndex;
      final baseColor = _barColor;
      final color = isSelected
          ? baseColor.withOpacity((_animation.value * 0.3 + 0.7).clamp(0.0, 1.0))
          : baseColor;

      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.amount,
            color: color,
            width: 20,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            borderSide: isSelected
                ? const BorderSide(color: Colors.white, width: 2)
                : BorderSide.none,
          ),
        ],
        showingTooltipIndicators: isSelected ? [0] : [],
      );
    }).toList();
  }

  BarTouchData _buildBarTouchData(NumberFormat currencyFormat) {
    return BarTouchData(
      touchCallback: (FlTouchEvent event, response) {
        if (response == null || response.spot == null) {
          setState(() {
            _selectedBarIndex = null;
            _selectedPeriodInfo = null;
          });
          return;
        }

        final index = response.spot!.touchedBarGroupIndex;
        final expense = _currentPageData[index];
        final amount = currencyFormat.format(expense.amount);
        final fullDate = _formatFullDate(expense.period, widget.interval);

        setState(() {
          _selectedBarIndex = index;
          if (widget.viewType == ChartViewType.expenses) {
            _selectedPeriodInfo = 'You spent $amount in $fullDate';
          } else {
            _selectedPeriodInfo = 'You earned $amount in $fullDate';
          }
        });

        _animationController.reset();
        _animationController.forward();
      },
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Colors.transparent,
        tooltipRoundedRadius: 0,
        tooltipPadding: EdgeInsets.zero,
        tooltipMargin: 0,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          return null;
        },
      ),
      handleBuiltInTouches: true,
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: _currentPage > 0 ? _barColor : Colors.grey.shade300,
              size: 18,
            ),
            onPressed: _currentPage > 0 ? _previousPage : null,
          ),
          Text(
            'Page ${_currentPage + 1} of $_totalPages',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_forward_ios,
              color: _currentPage < _totalPages - 1 ? _barColor : Colors.grey.shade300,
              size: 18,
            ),
            onPressed: _currentPage < _totalPages - 1 ? _nextPage : null,
          ),
        ],
      ),
    );
  }

  double _calculateMaxY(List<PeriodExpense> data) {
    if (data.isEmpty) return 100;

    final maxAmount = data
        .map((expense) => expense.amount)
        .reduce((a, b) => a > b ? a : b);

    if (maxAmount == 0) return 100;

    final interval = _calculateYAxisInterval(data);
    return ((maxAmount / interval).ceil() * interval).toDouble();
  }

  double _calculateYAxisInterval(List<PeriodExpense> data) {
    if (data.isEmpty) return 100;

    final maxAmount = data
        .map((expense) => expense.amount)
        .reduce((a, b) => a > b ? a : b);

    if (maxAmount == 0) return 100;

    if (maxAmount > 1000) return 250;
    if (maxAmount > 500) return 100;
    return 50;
  }

  Map<String, dynamic> _getChartDataForLLM() {
    final Map<String, dynamic> data = {};

    if (_currentPageData.isEmpty) {
      return {'empty': true};
    }

    data['periods'] = _currentPageData.map((expense) => {
      'period': expense.period,
      'amount': expense.amount,
    }).toList();

    data['total'] = _currentPageData.fold(
        0.0, (sum, expense) => sum + expense.amount);

    data['interval'] = widget.interval.toString().split('.').last;
    data['timeRange'] = widget.timeRange.range.toString().split('.').last;

    return data;
  }
}