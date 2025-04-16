import 'package:finney/pages/3-dashboard/models/transaction_model.dart';
import 'package:finney/pages/3-dashboard/transaction/view_transaction/all_transactions.dart';
import 'package:finney/pages/3-dashboard/transaction/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:finney/assets/theme/app_color.dart';

class RecentTransactions extends StatelessWidget {
  final List<TransactionModel> transactions;
  final Function(TransactionModel)? onDeleteTransaction;

  const RecentTransactions({
    super.key,
    required this.transactions,
    this.onDeleteTransaction,
  });

  @override
  Widget build(BuildContext context) {
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
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllTransactionsScreen(
                        transactions: transactions,
                        onDeleteTransaction: onDeleteTransaction,
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: AppColors.primary.withValues(alpha: 0.5),
                    ),
                  ),
                ),
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TransactionList(
            transactions: transactions,
            onDeleteTransaction: onDeleteTransaction,
            showAll: false,
          ),
        ],
      ),
    );
  }
}