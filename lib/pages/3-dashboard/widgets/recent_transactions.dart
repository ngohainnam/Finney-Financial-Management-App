import 'package:flutter/material.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/pages/3-dashboard/models/transaction_data.dart';
import 'package:finney/pages/3-dashboard/widgets/transaction_item.dart';

class RecentTransactions extends StatelessWidget {
  final List<Transaction> transactions;
  final VoidCallback onSeeAllPressed;

  const RecentTransactions({
    super.key,
    required this.transactions,
    required this.onSeeAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate alpha value (5% opacity = 13 in alpha value, 255 * 0.05)
    final int alpha = (255 * 0.05).round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(alpha),
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
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: onSeeAllPressed,
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          transactions.isEmpty
              ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: Text(
                'No transactions yet',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
              : Column(
            children: transactions.map((transaction) =>
                TransactionItem(transaction: transaction)
            ).toList(),
          ),
        ],
      ),
    );
  }
}