import 'package:finney/core/storage/cloud/models/user_model.dart';
import 'package:finney/core/storage/storage_manager.dart';
import 'package:finney/pages/1-auth/presentation/google_sign_in.dart';
import 'package:finney/pages/1-auth/presentation/pin_creation.dart';
import 'package:finney/pages/1-auth/widgets/my_textfield.dart';
import 'package:finney/pages/1-auth/widgets/square_tile.dart';
import 'package:finney/pages/3-dashboard/dashboard.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:finney/shared/path/app_images.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:finney/shared/widgets/common/my_button.dart';
import 'package:finney/shared/widgets/common/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'forget_password.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    showDialog(
      context: context,
      builder: (_) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userModel = UserModel(
          id: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? 'Unknown',
        );

        await StorageManager().userCloudService.setCurrentUser(userModel);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', user.email ?? '');
        await prefs.setString('userId', user.uid);
        await prefs.setString('name', user.displayName ?? 'Unknown');

        final storage = FlutterSecureStorage();
        final pin = await storage.read(key: 'pin_${user.uid}');

        // Remove the dialog before navigation
        if (mounted) Navigator.pop(context);

        // Navigate to PIN creation or Dashboard
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => pin == null || pin.isEmpty
                  ? const PinCreationPage()
                  : const Dashboard(),
            ),
          );
        }
      } else {
        if (mounted) Navigator.pop(context);
        if (mounted) {
          AppSnackBar.showError(context, message: 'Failed to retrieve user data.');
        }
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      if (mounted) {
        AppSnackBar.showError(context, message: 'Incorrect email/password.');
      }
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
                      LocaleData.loginTitle.getString(context),
                      style: const TextStyle(
                        color: AppColors.darkBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                MyTextField(
                  controller: emailController,
                  hintText: LocaleData.emailHint.getString(context),
                  obscureText: false,
                ),
                MyTextField(
                  controller: passwordController,
                  hintText: LocaleData.passwordHint.getString(context),
                  obscureText: true,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ForgotPasswordPage()),
                        ),
                        child: Text(
                          LocaleData.forgotPassword.getString(context),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                MyButton(
                  text: LocaleData.loginNow.getString(context),
                  onTap: signUserIn,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => GoogleSignInService.signInWithGoogle(context),
                      child: SquareTile(imagePath: AppImages.googleIcon),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      LocaleData.notMember.getString(context),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        LocaleData.registerNow.getString(context),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}