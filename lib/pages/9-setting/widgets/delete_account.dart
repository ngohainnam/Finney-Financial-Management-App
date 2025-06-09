import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:finney/shared/widgets/common/snack_bar.dart';
import 'package:finney/pages/9-setting/language_selection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finney/shared/widgets/common/app_dialog.dart';

Future<void> deleteAccount(BuildContext context) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  // Use your custom dialog for confirmation
  final confirmed = await AppDialog.show(
    context,
    title: LocaleData.deleteAccount.getString(context),
    message: LocaleData.deleteAccountConfirm.getString(context),
  );

  if (confirmed != true) return;

  try {
    // Delete user data from Firestore
    await FirebaseFirestore.instance.collection('users').doc(user.uid).delete();

    // Delete user authentication
    await user.delete();

    // Clear local preferences except language
    final prefs = await SharedPreferences.getInstance();
    final language = prefs.getString('language');
    await prefs.clear();
    if (language != null) {
      await prefs.setString('language', language);
    }

    AppSnackBar.showSuccess(
      context,
      message: LocaleData.accountDeleted.getString(context),
    );
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LanguageSelectionPage()),
      (route) => false,
    );
  } catch (e) {
    debugPrint('Delete account error: $e');
    AppSnackBar.showError(
      context,
      message: LocaleData.deleteAccountError.getString(context),
    );
  }
}