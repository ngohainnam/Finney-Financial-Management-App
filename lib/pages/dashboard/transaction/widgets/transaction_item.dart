import 'package:finney/core/storage/local/models/transaction/transaction_model.dart';
import 'package:finney/pages/dashboard/transaction/add_transaction/add_expense_screen.dart';
import 'package:finney/pages/dashboard/transaction/add_transaction/add_income_screen.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/pages/dashboard/utils/category.dart';
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
  final categoryColor = CategoryUtils.getColorForCategory(transaction.category);
  final deleteBackground = Colors.redAccent.withValues(alpha: 0.1); 

  return InkWell(
    onTap: isDeleteMode
        ? () => onSelected?.call(transaction)
        : () => _showEditScreen(context),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDeleteMode && isSelected ? deleteBackground : null,
      ),
      child: Row(
        children: [
          if (isDeleteMode)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconButton(
                onPressed: () => onSelected?.call(transaction),
                icon: Icon(
                  isSelected ? Icons.remove_circle : Icons.radio_button_unchecked,
                  color: isSelected ? Colors.redAccent : AppColors.gray,
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              transaction.icon,
              color: categoryColor,
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
                  CategoryUtils.getLocalizedCategoryName(transaction.category, context),
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
                    transaction.amount > 0
                        ? '+${transaction.amount.toStringAsFixed(2)}'
                        : transaction.amount.toStringAsFixed(2),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: transaction.amount > 0 ? Colors.green : Colors.redAccent,
                    ),
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