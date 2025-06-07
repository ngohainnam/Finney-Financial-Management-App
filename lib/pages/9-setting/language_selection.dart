import 'package:finney/shared/path/app_images.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:finney/pages/1-auth/auth_page.dart';
import 'package:finney/shared/widgets/common/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  void _setLanguage(BuildContext context, String languageCode) async {
    // Update locale using FlutterLocalization
    final localization = FlutterLocalization.instance;
    localization.translate(languageCode);

    // Save language preference to SharedPreferences instead of Hive
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', languageCode);

    // Navigate to AuthPage
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.appLogo,
                height: 100,
              ),
              const SizedBox(height: 50),
              MyButton(
                text: 'English',
                onTap: () => _setLanguage(context, 'en'),
                backgroundColor: AppColors.darkBlue,
                textColor: AppColors.lightBackground,
              ),
              const SizedBox(height: 20),
              MyButton(
                text: 'বাংলা',
                onTap: () => _setLanguage(context, 'bn'),
                backgroundColor: AppColors.darkBlue,
                textColor: AppColors.lightBackground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}