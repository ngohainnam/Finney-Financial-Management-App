import 'package:finney/assets/path/app_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/assets/widgets/common/error_message.dart';
import 'package:finney/assets/widgets/common/my_button.dart';
import 'package:finney/assets/widgets/common/my_textfield.dart';
import 'package:finney/localization/locales.dart';
import 'package:flutter_localization/flutter_localization.dart';


class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  void sendPasswordResetEmail() async {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        );
      },
    );

    try {
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
    } catch (e) {
      Navigator.pop(context);
      showErrorMessage(context, LocaleData.passwordResetError.getString(context));
    }
  }

  void showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return ErrorDialog(message: message);
      },
    );
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
            
                //logo
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
                    Navigator.pop(context); // Navigate back to login page
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

