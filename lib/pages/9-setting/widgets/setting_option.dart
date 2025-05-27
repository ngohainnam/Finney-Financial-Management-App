import 'package:finney/shared/theme/app_color.dart';
import 'package:flutter/material.dart';

/// A reusable widget for settings options
class SettingOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? iconColor;
  final Color? textColor;
  final VoidCallback onTap;
  final bool isLogOut;

  const SettingOption({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor,
    this.textColor,
    required this.onTap,
    this.isLogOut = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isLogOut ? Colors.red : Colors.white,
          border: Border.all(
            color: isLogOut ? Colors.red : AppColors.primary,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment:
              isLogOut ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor ?? AppColors.primary),
            if (!isLogOut) const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    isLogOut ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textColor ?? Colors.black,
                    ),
                  ),
                  if (subtitle != null && !isLogOut)
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor ?? Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}