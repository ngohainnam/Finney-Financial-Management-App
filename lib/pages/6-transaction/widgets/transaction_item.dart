import 'package:finney/core/storage/cloud/models/transaction_model.dart';
import 'package:finney/pages/6-transaction/add_transaction/add_expense_screen.dart';
import 'package:finney/pages/6-transaction/add_transaction/add_income_screen.dart';
import 'package:finney/shared/localization/localized_number_formatter.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:finney/shared/category.dart';
import 'package:flutter/material.dart';
import 'package:finney/shared/widgets/common/settings_notifier.dart';

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

    return ValueListenableBuilder<String>(
      valueListenable: SettingsNotifier().textSizeNotifier,
      builder: (context, textSize, child) {
        double textScaleFactor;
        switch (textSize) {
          case 'Small':
            textScaleFactor = 0.8;
            break;
          case 'Large':
            textScaleFactor = 1.2;
            break;
          default:
            textScaleFactor = 1.0;
        }

        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScaleFactor),
          ),
          child: InkWell(
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
                      color: categoryColor.withValues(alpha: (0.1 )),
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
                          CategoryUtils.getLocalizedCategoryName(transaction.category, context),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          (transaction.description ?? '').length > 30
                              ? '${transaction.description!.substring(0, 30)}...'
                              : (transaction.description ?? ''),
                          style: TextStyle(
                            color: AppColors.darkBlue.withValues(alpha: (0.7)),
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
                                ? '+${LocalizedNumberFormatter.formatDouble(transaction.amount, context)}'
                                : LocalizedNumberFormatter.formatDouble(transaction.amount, context),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: transaction.amount > 0 ? Colors.green : Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEditScreen(BuildContext context) {
    final transactionModel = TransactionModel(
      id: transaction.id,
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
