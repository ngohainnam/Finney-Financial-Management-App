import 'package:finney/core/storage/local/models/user/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:finney/pages/language_selection.dart';

Future<void> signOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();

  var appSettingsBox = await Hive.openBox('appSettings');
  await appSettingsBox.delete('language');

  var userBox = await Hive.openBox<UserModel>('userBox');
  await userBox.clear();

  if (context.mounted) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LanguageSelectionPage()),
      (route) => false,
    );
  }
}