import 'package:flutter/material.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:finney/pages/7-insights/components/time_selector.dart';
import 'package:finney/shared/localization/localized_number_formatter.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        gradient: AppColors.ombreBlue,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Row: Balance label and time range
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LocaleData.balance.getString(context),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  timeRange.getLocalizedLabel(context),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Main Balance
          Center(
            child: Text(
              '৳ ${LocalizedNumberFormatter.formatDouble(balance, context)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 18),
          // Income (one line)
          Row(
            children: [
              Icon(Icons.arrow_downward_rounded, color: Colors.greenAccent, size: 20),
              const SizedBox(width: 6),
              Text(
                '${LocaleData.income.getString(context)}: ',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(
                child: Text(
                  '৳ ${LocalizedNumberFormatter.formatDouble(income, context)}',
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Expense (one line)
          Row(
            children: [
              Icon(Icons.arrow_upward_rounded, color: Colors.redAccent, size: 20),
              const SizedBox(width: 6),
              Text(
                '${LocaleData.expenses.getString(context)}: ',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Expanded(
                child: Text(
                  '৳ ${LocalizedNumberFormatter.formatDouble(expenses, context)}',
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}