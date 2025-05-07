import 'package:flutter/material.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/localization/locales.dart';
import 'package:finney/components/time_selector.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final double income;
  final double expenses;
  final TimeRangeData timeRange;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.income,
    required this.expenses,
    required this.timeRange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.ombreBlue,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${LocaleData.balance.getString(context)} (${timeRange.getLocalizedLabel(context)})',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '৳ ${balance.toStringAsFixed(2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildIncomeExpenseIndicator(
                Icons.add_circle_outline,
                LocaleData.income.getString(context),
                '৳ ${income.toStringAsFixed(2)}',
                Colors.greenAccent,
              ),
              const SizedBox(width: 40),
              _buildIncomeExpenseIndicator(
                Icons.remove_circle_outline,
                LocaleData.expenses.getString(context),
                '৳ ${expenses.toStringAsFixed(2)}',
                Colors.redAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIncomeExpenseIndicator(
      IconData icon,
      String label,
      String amount,
      Color iconColor,
      ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 30,
          ),
        ),

        const SizedBox(width: 10),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              amount,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}