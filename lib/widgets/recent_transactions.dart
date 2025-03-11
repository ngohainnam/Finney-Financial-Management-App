import 'package:flutter/material.dart';
import 'package:visualize_infinance/models/expense_model.dart';
import 'package:visualize_infinance/utils/constants.dart';
import 'package:visualize_infinance/utils/formatters.dart';


class RecentTransactions extends StatelessWidget {
  final List<Transaction> transactions;
  final Function() onSeeAllPressed;

  const RecentTransactions({
    Key? key,
    required this.transactions,
    required this.onSeeAllPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardBackground = isDarkMode
        ? AppColors.cardDarkBackground
        : AppColors.cardLightBackground;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Transactions',
              style: AppTextStyles.heading2,
            ),
            TextButton(
              onPressed: onSeeAllPressed,
              child: Text(
                'See All',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.paddingSmall),
        ...transactions.map((transaction) {
          final bool isIncome = transaction.amount > 0;
          final String formattedAmount = isIncome
              ? CurrencyFormatter.formatWithSign(transaction.amount)
              : CurrencyFormatter.format(transaction.amount);
          final String formattedDate = DateFormatter.formatTransactionDate(transaction.date);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(AppDimensions.paddingMedium),
            decoration: BoxDecoration(
              color: cardBackground,
              borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: transaction.iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    transaction.icon,
                    color: transaction.iconColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.name,
                        style: AppTextStyles.bodyBold,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        transaction.category,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formattedAmount,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isIncome ? Colors.green : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}