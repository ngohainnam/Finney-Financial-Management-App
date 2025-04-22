import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/pages/3-dashboard/models/transaction_model.dart';
import 'package:intl/intl.dart';

class MonthlyExpenseChart extends StatelessWidget {
  final List<MonthlyExpense> monthlyExpenses;

  const MonthlyExpenseChart({
    super.key,
    required this.monthlyExpenses,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final totalSpending = monthlyExpenses.isEmpty
        ? 0.0
        : monthlyExpenses.fold(0.0, (sum, expense) => sum + expense.amount);

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Monthly Expenses',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Total: ${currencyFormat.format(totalSpending)}',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (monthlyExpenses.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: Text(
                  'No expense data for this month yet',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            _buildBarChart(),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    if (monthlyExpenses.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text("No data to display"),
        ),
      );
    }

    final maxValue = _calculateMaxY();

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxValue,
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < monthlyExpenses.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        monthlyExpenses[index].month,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
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
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Text(
                      '\$${value.toInt()}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  );
                },
                interval: _calculateInterval(),
                reservedSize: 40,
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: _calculateInterval(),
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withValues(alpha: 0.2),
                strokeWidth: 1,
                dashArray: [5, 5],
              );
            },
          ),
          borderData: FlBorderData(show: false),
          barGroups: _createBarGroups(),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              tooltipBgColor: Colors.blueGrey,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '\$${rod.toY.toStringAsFixed(2)}',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _createBarGroups() {
    return List.generate(
      monthlyExpenses.length,
          (index) => _createBarGroup(index, monthlyExpenses[index].amount),
    );
  }

  double _calculateMaxY() {
    if (monthlyExpenses.isEmpty) return 100;

    final maxAmount = monthlyExpenses
        .map((expense) => expense.amount)
        .reduce((a, b) => a > b ? a : b);

    if (maxAmount == 0) return 100;
    return ((maxAmount / 100).ceil() * 100).toDouble();
  }

  double _calculateInterval() {
    final maxY = _calculateMaxY();
    if (maxY <= 500) return 100;
    if (maxY <= 1000) return 200;
    if (maxY <= 5000) return 500;
    return 1000;
  }

  BarChartGroupData _createBarGroup(int x, double value) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.7),
              AppColors.primary,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          width: 20,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      ],
    );
  }
} 