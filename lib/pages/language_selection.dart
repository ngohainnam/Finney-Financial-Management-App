import 'package:finney/assets/path/app_images.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/assets/widgets/common/my_button.dart';
import 'package:finney/pages/auth/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LanguageSelectionPage extends StatelessWidget {
  const LanguageSelectionPage({super.key});

  void _setLanguage(BuildContext context, String languageCode) async {
    // Update locale using FlutterLocalization
    final localization = FlutterLocalization.instance;
    localization.translate(languageCode);

    // Save language preference to Hive
    var box = await Hive.openBox('appSettings');
    await box.put('language', languageCode);

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
                backgroundColor: AppColors.primary,
                textColor: AppColors.lightBackground,
              ),
              const SizedBox(height: 20),
              MyButton(
                text: 'বাংলা',
                onTap: () => _setLanguage(context, 'bn'),
                backgroundColor: AppColors.primary,
                textColor: AppColors.lightBackground,
              ),
            ],
          ),
        ),
      ),
    );
  }
}