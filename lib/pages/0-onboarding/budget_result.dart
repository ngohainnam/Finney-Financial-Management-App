import 'package:finney/shared/localization/locales.dart';
import 'package:finney/shared/localization/localized_number_formatter.dart';
import 'package:finney/shared/widgets/common/my_button.dart';
import 'package:flutter/material.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:finney/pages/3-dashboard/dashboard.dart';
import 'package:finney/shared/category.dart';
import 'package:flutter_localization/flutter_localization.dart';

class BudgetResultPage extends StatelessWidget {
  final Map<String, double> budgetLimits;

  const BudgetResultPage({
    super.key,
    required this.budgetLimits,
  });

  @override
  Widget build(BuildContext context) {
    final categoryOrder = CategoryUtils.expenseCategories;
    double totalLimit = budgetLimits.values.fold(0.0, (a, b) => a + b);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        title: Text(
          LocaleData.budgetSuggestion.getString(context),
          style: const TextStyle(
            color: AppColors.darkBlue,
            fontWeight: FontWeight.bold,
            fontSize: 28,
            letterSpacing: 1.2,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            LocaleData.yourMonthlyBudgetLimits.getString(context),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleData.totalBudgetLimit.getString(context),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "৳${LocalizedNumberFormatter.formatNumber(totalLimit.toInt().toString(), context)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...categoryOrder.map((category) {
            final limit = budgetLimits[category] ?? 0.0;
            return Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 70,
                      decoration: BoxDecoration(
                        color: CategoryUtils.getColorForCategory(category),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              CategoryUtils.getIconForCategory(category),
                              color: CategoryUtils.getColorForCategory(category),
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                CategoryUtils.getLocalizedCategoryName(category, context),
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            Text(
                              "৳${LocalizedNumberFormatter.formatNumber(limit.toInt().toString(), context)}",
                              style: const TextStyle(
                                fontSize: 15,
                                color: AppColors.darkBlue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 30),
          MyButton(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const Dashboard()),
              );
            },
            text: LocaleData.finish.getString(context),
            backgroundColor: AppColors.darkBlue,
          ),
        ],
      ),
    );
  }
}