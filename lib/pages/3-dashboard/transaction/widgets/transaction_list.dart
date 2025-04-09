import 'package:finney/pages/3-dashboard/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/pages/3-dashboard/transaction/widgets/transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<TransactionModel> transactions;
  final Function(TransactionModel)? onDeleteTransaction;
  final bool showAll;

  const TransactionList({
    super.key,
    required this.transactions,
    this.onDeleteTransaction,
    this.showAll = false,
  });

  Map<String, List<TransactionModel>> _groupTransactionsByDate() {
    final groupedTransactions = <String, List<TransactionModel>>{};
    
    final transactionList = showAll 
        ? transactions 
        : transactions.take(5).toList();
    
    for (var transaction in transactionList) {
      final date = DateFormat('yyyy-MM-dd').format(transaction.date);
      if (!groupedTransactions.containsKey(date)) {
        groupedTransactions[date] = [];
      }
      groupedTransactions[date]!.add(transaction);
    }
    
    final sortedDates = groupedTransactions.keys.toList()
      ..sort((a, b) => b.compareTo(a));
    
    return Map.fromEntries(
      sortedDates.map((date) => MapEntry(date, groupedTransactions[date]!))
    );
  }

  String _formatDate(String date) {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    
    final transactionDate = DateTime.parse(date);
    
    if (DateFormat('yyyy-MM-dd').format(today) == date) {
      return 'Today';
    } else if (DateFormat('yyyy-MM-dd').format(yesterday) == date) {
      return 'Yesterday';
    }
    return DateFormat('EEEE, MMMM d').format(transactionDate);
  }

  @override
  Widget build(BuildContext context) {
    final groupedTransactions = _groupTransactionsByDate();

    if (transactions.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            'No transactions yet',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      children: groupedTransactions.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                _formatDate(entry.key),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkBlue,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: AppColors.softGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: entry.value.map((transaction) {
                  return TransactionItem(
                    transaction: transaction,
                    onDelete: onDeleteTransaction,
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }
}