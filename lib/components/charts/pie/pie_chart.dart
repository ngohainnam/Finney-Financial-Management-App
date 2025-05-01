import 'package:finney/components/charts/pie/pie_category_item.dart';
import 'package:finney/pages/7-insights/chart_query.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:finney/pages/3-dashboard/utils/category.dart';
import 'package:finney/pages/7-insights/insights.dart'; 
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/localization/locales.dart';

class CategoryPieChart extends StatelessWidget {
  final List<dynamic> categoryData;
  final ChartViewType viewType;

  const CategoryPieChart({
    super.key,
    required this.categoryData,
    required this.viewType,
  });

  Color get _themeColor {
    return viewType == ChartViewType.income
        ? Colors.green 
        : Colors.redAccent; 
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    
    // Handle empty data case
    final total = categoryData.isEmpty
        ? 0.0
        : categoryData.fold(0.0, (sum, category) => sum + category['amount']);

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
          // Header with title and total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                viewType == ChartViewType.expenses 
                    ? LocaleData.categoryBreakdown.getString(context)
                    : LocaleData.incomeAnalysis.getString(context),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                 '${LocaleData.total.getString(context)}: ${total.toStringAsFixed(2)}',
                style: TextStyle(
                  color: _themeColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),

          //Chart container
          if (categoryData.isEmpty)
            _buildEmptyState(viewType, context)
          else
            Container(
              height: 220, 
              width: double.infinity,
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: SizedBox(
                  height: 180,
                  width: 180,
                  child: PieChart(
                    PieChartData(
                      sections: _createPieChartSections(categoryData),
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      startDegreeOffset: -90,
                    ),
                  ),
                ),
              ),
            ),
          
          const SizedBox(height: 30),
        
          // Category legends below chart
          ...categoryData.isEmpty 
            ? []
            : _buildCategoryList(categoryData, total, currencyFormat),
          
          ChartQuery(
            chartData: _getChartDataForLLM(),
            chartType: 'pie chart',
            viewType: viewType == ChartViewType.expenses ? 'expenses' : 'income',
          ),
        ],
        
      ),
    );
  }

  Widget _buildEmptyState(ChartViewType viewType, context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            Icon(
              viewType == ChartViewType.expenses 
                  ? Icons.remove_shopping_cart 
                  : Icons.account_balance_wallet,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              viewType == ChartViewType.expenses
                  ? LocaleData.noExpenseData.getString(context)
                  : LocaleData.noIncomeData.getString(context),
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCategoryList(
      List<dynamic> categories, double total, NumberFormat formatter) {
    // Sort categories by amount (highest first)
    final sortedCategories = List<dynamic>.from(categories)
      ..sort((a, b) => b['amount'].compareTo(a['amount']));
      
    return sortedCategories.map((category) {
      final percentage = total > 0 ? (category['amount'] / total * 100) : 0;
      
      return CategoryExpenseItem(
        color: category['color'],
        name: category['name'],
        amount: category['amount'],
        percentage: percentage,
        formatter: formatter,
        icon: CategoryUtils.getIconForCategory(category['name']),
      );
    }).toList();
  }

  List<PieChartSectionData> _createPieChartSections(List<dynamic> data) {
    if (data.isEmpty) {
      return [
        PieChartSectionData(
          color: Colors.grey.shade300,
          value: 100,
          title: '',
          radius: 80,
          showTitle: false,
        )
      ];
    }

    return data.map((category) {
      return PieChartSectionData(
        color: category['color'],
        value: category['amount'],
        title: '',
        radius: 80,
        showTitle: false,
      );
    }).toList();
  }

  Map<String, dynamic> _getChartDataForLLM() {
    final Map<String, dynamic> data = {};
    
    if (categoryData.isEmpty) {
      return {'empty': true};
    }
    
    // Create a simplified version of the chart data for the LLM
    data['categories'] = categoryData.map((category) => {
      'name': category['name'],
      'amount': category['amount'],
    }).toList();
    
    data['total'] = categoryData.fold(
      0.0, (sum, category) => sum + category['amount']);
      
    return data;
  }
}