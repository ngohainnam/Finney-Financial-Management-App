import 'package:finney/pages/3-dashboard/models/transaction_model.dart';
import 'package:finney/pages/3-dashboard/widgets/delete_transaction_dialog.dart';
import 'package:finney/pages/3-dashboard/transaction/add_transaction/add_expense_screen.dart';
import 'package:finney/pages/3-dashboard/transaction/add_transaction/add_income_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;
  final Function(TransactionModel)? onDelete;
  final Function(TransactionModel)? onUpdate;

  const TransactionItem({
    super.key,
    required this.transaction,
    this.onDelete,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final dateFormat = DateFormat('h:mm a');
    final isIncome = transaction.amount > 0;

    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) async {
              final shouldDelete = await DeleteTransactionDialog.show(context);
              if (shouldDelete) {
                onDelete?.call(transaction);
              }
            },
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            label: 'Delete',
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showEditScreen(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: transaction.iconColor.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  transaction.icon,
                  color: transaction.iconColor,
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
                  Text(
                    isIncome
                        ? '+${currencyFormat.format(transaction.amount)}'
                        : currencyFormat.format(transaction.amount),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isIncome ? Colors.green : Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateFormat.format(transaction.date),
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
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
        builder:
            (context) =>
                transaction.amount > 0
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
