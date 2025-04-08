import 'package:finney/pages/3-dashboard/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class CategoryPieChart extends StatelessWidget {
  final List<CategoryExpense> categoryExpenses;

  const CategoryPieChart({
    super.key,
    required this.categoryExpenses,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');

    // Handle empty data case
    final total = categoryExpenses.isEmpty
        ? 0.0
        : categoryExpenses.fold(0.0, (sum, category) => sum + category.amount);

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
                'Spending by Category',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Total: ${currencyFormat.format(total)}',
                style: const TextStyle(
                  color: Color(0xff015BD6),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (categoryExpenses.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40.0),
                child: Text(
                  'No category spending data yet',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            SizedBox(
              height: 250, // Increased height
              child: Row(
                children: [
                  Expanded(
                    flex: 6, // Increased flex for the pie chart
                    child: PieChart(
                      PieChartData(
                        sections: _createPieChartSections(total),
                        sectionsSpace: 3, // Reduced space between sections
                        centerSpaceRadius: 30, // Increased center space
                        startDegreeOffset: -90,
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {
                            // Optional interactive feedback when touching sections
                          },
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 4, // Reduced flex for the legend
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: categoryExpenses.map((category) {
                        return _buildCategoryLegend(
                          category.name,
                          category.amount,
                          category.color,
                          currencyFormat,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _createPieChartSections(double total) {
    if (categoryExpenses.isEmpty || total <= 0) {
      // Return a single empty section if there's no data
      return [
        PieChartSectionData(
          color: Colors.grey.shade300,
          value: 100,
          title: '0%',
          radius: 80,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        )
      ];
    }

    return categoryExpenses.map((category) {
      final percentage = (category.amount / total * 100);
      return PieChartSectionData(
        color: category.color,
        value: category.amount,
        title: '${percentage.toStringAsFixed(0)}%',
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildCategoryLegend(
      String category, double amount, Color color, NumberFormat formatter) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              category,
              style: const TextStyle(
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            formatter.format(amount),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}