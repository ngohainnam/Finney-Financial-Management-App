import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/components/charts/chart_service.dart';
import 'package:finney/components/time_selector.dart';
import 'package:finney/pages/7-insights/chart_query.dart';
import 'package:finney/pages/7-insights/insights.dart'; 
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class UnifiedBarChart extends StatefulWidget {
  final String title;
  final List<PeriodExpense> periodExpenses;
  final ChartInterval interval;
  final TimeRangeData timeRange;
  final ChartViewType viewType; // Add view type parameter

  const UnifiedBarChart({
    super.key,
    required this.title,
    required this.periodExpenses,
    required this.interval,
    required this.timeRange,
    required this.viewType, // Make this required
  });

  @override
  State<UnifiedBarChart> createState() => _UnifiedBarChartState();
}

class _UnifiedBarChartState extends State<UnifiedBarChart> {
  final int _itemsPerPage = 12;
  int _currentPage = 0;
  
  // Get bar color based on view type
  Color get _barColor {
    return widget.viewType == ChartViewType.income
        ? Colors.green  
        : Colors.redAccent;  
  }
  
  @override
  void didUpdateWidget(UnifiedBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.periodExpenses != oldWidget.periodExpenses) {
      _currentPage = 0;
    }
  }

  int get _totalPages {
    return max(1, (widget.periodExpenses.length / _itemsPerPage).ceil());
  }

  List<PeriodExpense> get _currentPageData {
    if (widget.periodExpenses.isEmpty) return [];
    
    final startIndex = _currentPage * _itemsPerPage;
    final endIndex = min(startIndex + _itemsPerPage, widget.periodExpenses.length);
    
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

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final totalAmount = widget.periodExpenses.isEmpty
        ? 0.0
        : widget.periodExpenses.fold(0.0, (sum, expense) => sum + expense.amount);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
          
          if (widget.periodExpenses.isEmpty)
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
          'Total: ${currencyFormat.format(totalAmount)}',
          style: TextStyle(
            color: _barColor, // Use dynamic color based on type
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
              ? 'No income data for this period yet'
              : 'No expense data for this period yet',
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
              titlesData: _buildTitlesData(),
              gridData: _buildGridData(),
              borderData: FlBorderData(show: false),
              barGroups: _buildBarGroups(),
              barTouchData: _buildBarTouchData(currencyFormat),
            ),
          ),
        ),
        
        if (_totalPages > 1)
          _buildPagination(),
      ],
    );
  }

  FlTitlesData _buildTitlesData() {
    
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
      // Left axis titles (currency values)
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            if (value == 0) return const SizedBox();
            return SideTitleWidget(
              axisSide: meta.axisSide,
              space: 8,
              child: Text(
                '\$${value.toInt()}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            );
          },
          interval: _calculateYAxisInterval(_currentPageData),
          reservedSize: 40,
        ),
      ),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  FlGridData _buildGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      horizontalInterval: _calculateYAxisInterval(_currentPageData),
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.grey.withValues(alpha: 0.2),
          strokeWidth: 1,
          dashArray: [5, 5],
        );
      },
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return _currentPageData.asMap().entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            toY: entry.value.amount,
            color: _barColor, // Use dynamic color based on type
            width: _getBarWidth(),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    }).toList();
  }

  BarTouchData _buildBarTouchData(NumberFormat currencyFormat) {
    return BarTouchData(
      enabled: true,
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: AppColors.blurGray,
        getTooltipItem: (group, groupIndex, rod, rodIndex) {
          final period = _currentPageData[groupIndex].period;
          return BarTooltipItem(
            '${currencyFormat.format(rod.toY)}\n$period',
            const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
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
              color: _currentPage > 0 ? _barColor : Colors.grey.shade300, // Use dynamic color
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
              color: _currentPage < _totalPages - 1 ? _barColor : Colors.grey.shade300, // Use dynamic color
              size: 18,
            ),
            onPressed: _currentPage < _totalPages - 1 ? _nextPage : null,
          ),
        ],
      ),
    );
  }

  double _getBarWidth() {
    final itemCount = _currentPageData.length;
    if (itemCount <= 4) return 30;
    if (itemCount <= 8) return 20;
    return 12;
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
  
  int min(int a, int b) => a < b ? a : b;
  int max(int a, int b) => a > b ? a : b;


  Map<String, dynamic> _getChartDataForLLM() {
  final Map<String, dynamic> data = {};
  
  if (widget.periodExpenses.isEmpty) {
    return {'empty': true};
  }
  
  data['periods'] = widget.periodExpenses.map((expense) => {
    'period': expense.period,
    'amount': expense.amount,
  }).toList();
  
  data['total'] = widget.periodExpenses.fold(
    0.0, (sum, expense) => sum + expense.amount);
    
  data['interval'] = widget.interval.toString().split('.').last;
  data['timeRange'] = widget.timeRange.range.toString().split('.').last;
  
  return data;
}
}