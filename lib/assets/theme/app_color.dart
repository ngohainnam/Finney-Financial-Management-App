import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xff015BD6);
  static const lightBackground = Colors.white;
  static const darkBackground = Colors.black;
  static const softBlue = Color.fromARGB(255, 195, 216, 246);
  static const darkBlue = Color(0xff0A2342);
  static const blurGray = Color.fromARGB(255, 131, 146, 172);
  static const softGray = Color.fromARGB(255, 225, 228, 234);
  static const userChatColor = Color.fromARGB(255, 85, 147, 234);
  static var ombreBlue = LinearGradient(
    colors: [
      Colors.blue.shade500,
      Colors.blue.shade300,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
