import 'package:finney/shared/theme/app_color.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon; // <-- New optional icon parameter

  const MyButton({
    super.key,
    required this.onTap,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.icon, // <-- Add to constructor
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.darkBlue,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: icon != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, color: textColor ?? Colors.white),
                    const SizedBox(width: 10),
                    Text(
                      text,
                      style: TextStyle(
                        color: textColor ?? Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                )
              : Text(
                  text,
                  style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}