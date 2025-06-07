import 'package:finney/pages/2-chatbot/services/llm_transactionparser.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:finney/core/storage/cloud/models/transaction_model.dart';
import 'package:finney/shared/category.dart';
import 'package:flutter/material.dart';
import 'package:finney/shared/localization/locales.dart';
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
    final isBengali = Localizations.localeOf(context).languageCode == 'bn';

    String formattedAmount;
    if (isBengali) {
      formattedAmount = '৳${TransactionParser.englishToBengaliNumber(
        transaction.amount.abs().toStringAsFixed(2),
        context,
      )}';
    } else {
      formattedAmount = '৳${transaction.amount.abs().toStringAsFixed(2)}';
    }

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
              style: const TextStyle(
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
                          transaction.category,
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
                            formattedAmount,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isIncome ? Colors.green : Colors.redAccent,
                            ),
                          ),
                        ],
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
                      side: const BorderSide(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  child: Text(
                    LocaleData.transactionPreviewCancel.getString(context),
                    style: const TextStyle(
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
                  child: Text(LocaleData.transactionPreviewConfirm.getString(context)),
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