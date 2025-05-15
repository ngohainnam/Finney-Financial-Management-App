import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/core/storage/local/models/transaction/transaction_model.dart';
import 'package:finney/pages/dashboard/utils/category.dart'; // Import CategoryUtils
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finney/assets/localization/locales.dart';
import 'package:flutter_localization/flutter_localization.dart';

class TransactionPreviewPopup extends StatelessWidget {
  final TransactionModel transaction;
  final Function(TransactionModel) onConfirm;
  final VoidCallback onCancel;

  const TransactionPreviewPopup({
    super.key,
    required this.transaction,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.amount > 0;
    final categoryColor = CategoryUtils.getColorForCategory(transaction.category);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleData.transactionPreviewTitle.getString(context),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            //transaction item design - matched with transaction_item.dart
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
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
                              color: isIncome ? Colors.green : Colors.redAccent,
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

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: onCancel,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      child: Text(
                        LocaleData.transactionPreviewCancel.getString(context),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                const SizedBox(width: 16),

                ElevatedButton(
                  onPressed: () => onConfirm(transaction),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text( LocaleData.transactionPreviewConfirm.getString(context),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Show the popup
  static Future<bool?> show({
    required BuildContext context,
    required TransactionModel transaction,
    required Function(TransactionModel) onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return TransactionPreviewPopup(
          transaction: transaction,
          onConfirm: (transaction) {
            Navigator.of(context).pop(true);
            //execute onConfirm with the transaction
            onConfirm(transaction);
          },
          onCancel: () {
            Navigator.of(context).pop(false);
          },
        );
      },
    );
  }
}