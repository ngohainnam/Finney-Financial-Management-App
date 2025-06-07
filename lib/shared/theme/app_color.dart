import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xff015BD6);
  static const lightBackground = Colors.white;
  static const darkBackground = Colors.black;
  static const softBlue = Color.fromARGB(255, 195, 216, 246);
  static const darkBlue = Color(0xff0A2342);
  static const blurGray = Color.fromARGB(255, 131, 146, 172);
  static const gray = Color.fromARGB(255, 184, 196, 216);
  static const softGray = Color.fromARGB(255, 250, 251, 253);
  static const userChatColor = Color.fromARGB(255, 85, 147, 234);
  static var ombreBlue = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
     AppColors.primary,
     AppColors.darkBlue,
   ],
  );

  //for categories
  static const Color categoryShopping = Color(0xFFFF9800);
  static const Color categoryFood = Color(0xFF2196F3);
  static const Color categoryEntertainment = Color(0xFFE91E63);
  static const Color categoryTransport = Color(0xFF4CAF50);
  static const Color categoryHealth = Color(0xFFF44336);
  static const Color categoryUtilities = Color(0xFF9C27B0);
  static const Color categoryDefault = Color(0xFF9E9E9E); 
  static const Color categorySalary = Color.fromARGB(255, 6, 149, 11);
  static const Color categoryInvestment = Color(0xFF2196F3);
  static const Color categoryBusiness = Color(0xFFFF9800);
  static const Color categoryGift = Color(0xFFE91E63);
  static const Color categorySavings = Colors.blue;

  static const Color budgetEdu = Color(0xFFDCEDC8);
}
