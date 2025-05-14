import 'package:flutter/material.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/localization/locales.dart';

class DeleteTransactionDialog extends StatelessWidget {
  final String title;
  final String message;
  
  DeleteTransactionDialog({
  super.key,
  String? title,
  String? message,
  required BuildContext context,
  }) : title = title ?? LocaleData.deleteTransaction.getString(context),
      message = message ?? LocaleData.confirmDeleteSingleTransaction.getString(context);

  static Future<bool> show(
    BuildContext context, {
    String? title,
    String? message,
  }) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => DeleteTransactionDialog(
        context: context,
        title: title,
        message: message,
      ),
    ) ?? false;
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.delete_outline,
              color: Colors.redAccent,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(
          color: AppColors.blurGray,
          fontSize: 14,
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      actions: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.pop(context, false),
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
                  LocaleData.cancel.getString(context),
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  LocaleData.delete.getString(context),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}