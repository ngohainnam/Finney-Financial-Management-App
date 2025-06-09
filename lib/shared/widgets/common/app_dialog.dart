import 'package:flutter/material.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/shared/localization/locales.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final String message;
  final Color? iconColor;
  final Color? textColor;
  final String? confirmText;

  AppDialog({
    super.key,
    String? title,
    String? message,
    required BuildContext context,
    this.iconColor,
    this.textColor,
    this.confirmText,
  })  : title = title ?? LocaleData.deleteTransaction.getString(context),
        message = message ?? LocaleData.confirmDeleteSingleTransaction.getString(context);

  static Future<bool> show(
    BuildContext context, {
    String? title,
    String? message,
    Color? iconColor,
    Color? textColor,
    String? confirmText,
  }) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AppDialog(
            context: context,
            title: title,
            message: message,
            iconColor: iconColor,
            textColor: textColor,
            confirmText: confirmText,
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final Color effectiveIconColor = iconColor ?? Colors.redAccent;
    final Color effectiveTextColor = textColor ?? AppColors.darkBlue;

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
              color: effectiveIconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.delete_outline,
              color: effectiveIconColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: effectiveTextColor,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: TextStyle(
          color: effectiveTextColor,
          fontSize: 16,
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
                  padding: const EdgeInsets.symmetric(vertical: 14),
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
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: effectiveIconColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  confirmText ?? LocaleData.delete.getString(context),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
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