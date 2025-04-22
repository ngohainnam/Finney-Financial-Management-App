import 'package:finney/pages/3-dashboard/models/transaction_model.dart';
import 'package:finney/pages/3-dashboard/transaction/add_transaction/add_expense_screen.dart';
import 'package:finney/pages/3-dashboard/transaction/add_transaction/add_income_screen.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;
  final Function(TransactionModel)? onDelete;
  final Function(TransactionModel)? onUpdate;
  final bool isDeleteMode;
  final bool isSelected;
  final Function(TransactionModel)? onSelected;

  const TransactionItem({
    super.key,
    required this.transaction,
    this.onDelete,
    this.onUpdate,
    this.isDeleteMode = false,
    this.isSelected = false,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.amount > 0;

    return InkWell(
      onTap: isDeleteMode
          ? () => onSelected?.call(transaction)
          : () => _showEditScreen(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 26) : null,
        ),
        child: Row(
          children: [
            if (isDeleteMode)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: IconButton(
                  onPressed: () => onSelected?.call(transaction),
                  icon: Icon(
                    isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: isSelected ? AppColors.primary : AppColors.gray,
                  ),
                ),
              ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isIncome ? AppColors.categoryFood.withValues(alpha: 51) : AppColors.categoryHealth.withValues(alpha: 51),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                transaction.icon,
                color: isIncome ? AppColors.categoryFood : AppColors.categoryHealth,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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
                Row(
                  children: [
                    Text(
                      isIncome
                          ? '+${NumberFormat.currency(symbol: '\$').format(transaction.amount)}'
                          : NumberFormat.currency(symbol: '\$').format(transaction.amount),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isIncome ? AppColors.categoryFood : AppColors.categoryHealth,
                      ),
                    ),
                    if (!isDeleteMode)
                      IconButton(
                        onPressed: () => _showEditScreen(context),
                        icon: const Icon(Icons.edit, color: AppColors.gray),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('h:mm a').format(transaction.date),
                  style: TextStyle(color: AppColors.gray, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showEditScreen(BuildContext context) {
    final transactionModel = TransactionModel(
      id: transaction.id,
      name: transaction.name,
      category: transaction.category,
      amount: transaction.amount,
      date: transaction.date,
      description: transaction.description,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => transaction.amount > 0
            ? AddIncomeScreen(
          existingTransaction: transactionModel,
          onTransactionAdded: (updatedTransaction) {
            onUpdate?.call(
              transaction.copyWith(
                name: updatedTransaction.name,
                category: updatedTransaction.category,
                amount: updatedTransaction.amount,
                date: updatedTransaction.date,
                description: updatedTransaction.description,
              ),
            );
          },
        )
            : AddExpenseScreen(
          existingTransaction: transactionModel,
          onTransactionAdded: (updatedTransaction) {
            onUpdate?.call(
              transaction.copyWith(
                name: updatedTransaction.name,
                category: updatedTransaction.category,
                amount: updatedTransaction.amount,
                date: updatedTransaction.date,
                description: updatedTransaction.description,
              ),
            );
          },
        ),
      ),
    );
  }
}