import 'package:finney/shared/theme/app_color.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Function(String)? onChanged;
  final Widget? suffixIcon;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.onChanged,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        onChanged: onChanged, 
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.softGray),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.darkBlue),
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.blurGray),
          suffixIcon: suffixIcon, 
        ),
      ),
    );
  }
}