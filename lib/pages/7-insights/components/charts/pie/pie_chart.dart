import 'package:finney/pages/7-insights/components/charts/pie/pie_category_item.dart';
import 'package:finney/pages/7-insights/chart_query.dart';
import 'package:finney/shared/localization/localized_number_formatter.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:finney/shared/category.dart';
import 'package:finney/pages/7-insights/insights.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/shared/localization/locales.dart';

class CategoryPieChart extends StatefulWidget {
  final List<dynamic> categoryData;
  final ChartViewType viewType;

  const CategoryPieChart({
    super.key,
    required this.categoryData,
    required this.viewType,
  });

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> with SingleTickerProviderStateMixin {
  String? _selectedCategoryInfo;
  int? _selectedSectionIndex;
  late AnimationController _animationController;
  late Animation<double> _animation;

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
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color get _themeColor {
    return widget.viewType == ChartViewType.income
        ? Colors.green
        : Colors.redAccent;
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '৳');

    // Handle empty data case
    final total = widget.categoryData.isEmpty
        ? 0.0
        : widget.categoryData.fold(0.0, (sum, category) => sum + category['amount']);

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
                widget.viewType == ChartViewType.expenses
                    ? LocaleData.categoryBreakdown.getString(context)
                    : LocaleData.incomeAnalysis.getString(context),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${LocaleData.total.getString(context)}: ৳${LocalizedNumberFormatter.formatDouble(total, context)}',
                style: TextStyle(
                  color: _themeColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          //Chart container
          if (widget.categoryData.isEmpty)
            _buildEmptyState(widget.viewType, context)
          else
            Column(
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  padding: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: SizedBox(
                      height: 120,
                      width: 120,
                      child: PieChart(
                        PieChartData(
                          sections: _createPieChartSections(widget.categoryData, currencyFormat),
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          startDegreeOffset: -90,
                          pieTouchData: PieTouchData(
                            touchCallback: (FlTouchEvent event, pieTouchResponse) {
                              // If it's not a tap event, ignore it
                              if (event is! FlTapUpEvent) {
                                return;
                              }

                              // If clicking outside or no section is touched, clear selection
                              if (pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null ||
                                  pieTouchResponse.touchedSection!.touchedSectionIndex < 0 ||
                                  pieTouchResponse.touchedSection!.touchedSectionIndex >= widget.categoryData.length) {
                                setState(() {
                                  _selectedSectionIndex = null;
                                  _selectedCategoryInfo = null;
                                });
                                return;
                              }

                              final index = pieTouchResponse.touchedSection!.touchedSectionIndex;

                              // If clicking the same section, deselect it
                              if (_selectedSectionIndex == index) {
                                setState(() {
                                  _selectedSectionIndex = null;
                                  _selectedCategoryInfo = null;
                                });
                                return;
                              }

                              // Select the new section
                              final category = widget.categoryData[index];
                              final amount = '৳${LocalizedNumberFormatter.formatDouble(category['amount'], context)}';
                              final categoryName = CategoryUtils.getLocalizedCategoryName(
                                category['name'] ?? category['category'],
                                context,
                              );
                              final percentage = (category['amount'] / total * 100).toStringAsFixed(1);
                              final localizedPercent = LocalizedNumberFormatter.formatNumber(percentage, context);

                              setState(() {
                                _selectedSectionIndex = index;
                                if (widget.viewType == ChartViewType.expenses) {
                                  _selectedCategoryInfo =
                                    '${LocaleData.youSpent.getString(context)} $amount ($localizedPercent%) ${LocaleData.inWord.getString(context)} $categoryName';
                                } else {
                                  _selectedCategoryInfo =
                                    '${LocaleData.youEarned.getString(context)} $amount ($localizedPercent%) ${LocaleData.inWord.getString(context)} $categoryName';
                                }
                              });

                              // Reset animation
                              _animationController.reset();
                              _animationController.forward();
                            },
                            enabled: true,
                            mouseCursorResolver: (FlTouchEvent touchEvent, PieTouchResponse? pieTouchResponse) {
                              return SystemMouseCursors.click;
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _buildSummaryText(currencyFormat),
              ],
            ),

          const SizedBox(height: 30),

          // Category legends below chart
          ...widget.categoryData.isEmpty
              ? []
              : _buildCategoryList(widget.categoryData, total, currencyFormat),

          ChartQuery(
            chartData: _getChartDataForLLM(),
            chartType: 'pie chart',
            viewType: widget.viewType == ChartViewType.expenses ? 'expenses' : 'income',
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ChartViewType viewType, BuildContext context) {
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
      final categoryName = CategoryUtils.getLocalizedCategoryName(
        category['name'] ?? category['category'],
        context,
      );
      return CategoryExpenseItem(
        color: category['color'],
        name: categoryName,
        amount: category['amount'],
        percentage: percentage,
        formatter: formatter,
        icon: CategoryUtils.getIconForCategory(category['name']),
      );
    }).toList();
  }

  List<PieChartSectionData> _createPieChartSections(List<dynamic> data, NumberFormat currencyFormat) {
    if (data.isEmpty) {
      return [
        PieChartSectionData(
          color: Colors.grey.shade300,
          value: 100,
          title: '',
          radius: 50,
          showTitle: false,
        )
      ];
    }

    return data.asMap().entries.map((entry) {
      final isSelected = entry.key == _selectedSectionIndex;
      final baseColor = entry.value['color'] as Color;
      final color = isSelected
          ? baseColor.withValues(alpha: (_animation.value * 0.3 + 0.7).clamp(0.0, 1.0))
          : baseColor;

      return PieChartSectionData(
        color: color,
        value: entry.value['amount'],
        title: '',
        radius: isSelected ? 55 : 50,
        titleStyle: const TextStyle(
          fontSize: 0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        borderSide: isSelected
            ? const BorderSide(color: Colors.white, width: 2)
            : BorderSide.none,
      );
    }).toList();
  }

  Map<String, dynamic> _getChartDataForLLM() {
    final Map<String, dynamic> data = {};

    if (widget.categoryData.isEmpty) {
      return {'empty': true};
    }

    // Create a simplified version of the chart data for the LLM
    data['categories'] = widget.categoryData.map((category) => {
      'name': category['name'],
      'amount': category['amount'],
    }).toList();

    data['total'] = widget.categoryData.fold(
        0.0, (sum, category) => sum + category['amount']);

    return data;
  }

  Widget _buildSummaryText(NumberFormat currencyFormat) {
    if (widget.categoryData.isEmpty) return const SizedBox.shrink();

    if (_selectedCategoryInfo != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          _selectedCategoryInfo!,
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
}