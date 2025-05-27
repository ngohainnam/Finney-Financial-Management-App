import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:finney/shared/widgets/common/snack_bar.dart';
import 'package:finney/pages/9-setting/language_selection.dart';

Future<void> signOut(BuildContext context) async {
  try {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    final language = prefs.getString('language');
    await prefs.clear();
    if (language != null) {
      await prefs.setString('language', language);
    }
    debugPrint('Sign-out complete, PIN preserved for user: $userId');
    AppSnackBar.showSuccess(
      context,
      message: LocaleData.logOut.getString(context),
    );
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LanguageSelectionPage()),
      (route) => false,
    );
  } catch (e) {
    debugPrint('Sign-out error: $e');
    AppSnackBar.showError(
      context,
      message: LocaleData.queryError.getString(context),
    );
  }
}