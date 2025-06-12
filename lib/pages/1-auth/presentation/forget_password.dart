import 'package:finney/shared/path/app_images.dart';
import 'package:finney/shared/widgets/common/my_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:finney/shared/widgets/common/snack_bar.dart';
import 'package:finney/pages/1-auth/widgets/my_textfield.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  Future<bool> checkEmailExists(String email) async {
    var querySnapshot = await FirebaseFirestore.instance.collection('users')
        .where('email', isEqualTo: email)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  void sendPasswordResetEmail() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
        );
      },
    );

    try {
      bool emailExists = await checkEmailExists(emailController.text.trim());

      if (emailExists) {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(
                LocaleData.forgotPasswordTitle.getString(context),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              content: Text(
                LocaleData.passwordResetSuccess.getString(context),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    LocaleData.dialogOk.getString(context),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ],
            );
          },
        );
      } else {
        Navigator.pop(context);
        AppSnackBar.showError(
          context, 
          message: LocaleData.emailNotRegistered.getString(context),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      AppSnackBar.showError(
        context, 
        message: LocaleData.passwordResetError.getString(context),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Image.asset(AppImages.appLogo),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      LocaleData.forgotPasswordTitle.getString(context),
                      style: TextStyle(
                        color: AppColors.darkBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: emailController,
                  hintText: LocaleData.emailHint.getString(context),
                  obscureText: false,
                ),
                const SizedBox(height: 25),
                MyButton(
                  text: LocaleData.sendResetLink.getString(context),
                  onTap: sendPasswordResetEmail,
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    LocaleData.backToLogin.getString(context),
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}