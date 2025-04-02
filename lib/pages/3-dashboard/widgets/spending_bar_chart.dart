import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/pages/3-dashboard/services/transaction_services.dart';
import 'package:intl/intl.dart';

class SpendingBarChart extends StatelessWidget {
  final List<WeeklyExpenseData> weeklyExpenses;

  const SpendingBarChart({
    super.key,
    required this.weeklyExpenses,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    // Calculate total, handling empty data case
    final totalSpending = weeklyExpenses.isEmpty
        ? 0.0
        : weeklyExpenses.fold(0.0, (sum, expense) => sum + expense.amount);

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
                'Weekly Spending',
                style: TextStyle(
                  fontSize: 18,
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
          if (weeklyExpenses.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: Text(
                  'No expense data for this week yet',
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
    // Ensure we have valid data
    if (weeklyExpenses.isEmpty) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text("No data to display"),
        ),
      );
    }

    // Get maximum value for chart scaling
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
                  if (index >= 0 && index < weeklyExpenses.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        weeklyExpenses[index].day,
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
                color: Colors.grey.withAlpha(51),
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

  // Create all bar groups for the chart
  List<BarChartGroupData> _createBarGroups() {
    return List.generate(
      weeklyExpenses.length,
          (index) => _createBarGroup(index, weeklyExpenses[index].amount),
    );
  }

  double _calculateMaxY() {
    if (weeklyExpenses.isEmpty) return 100;

    final maxAmount = weeklyExpenses
        .map((expense) => expense.amount)
        .reduce((a, b) => a > b ? a : b);

    // If max amount is 0, return a default value
    if (maxAmount == 0) return 100;

    // Round up to the nearest 25
    return ((maxAmount / 25).ceil() * 25).toDouble();
  }

  double _calculateInterval() {
    final maxY = _calculateMaxY();
    if (maxY <= 100) return 25;
    if (maxY <= 200) return 50;
    if (maxY <= 500) return 100;
    return 250;
  }

  BarChartGroupData _createBarGroup(int x, double value) {
    final Color primaryColor = AppColors.primary;
    primaryColor.withValues(alpha: 0.7);

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