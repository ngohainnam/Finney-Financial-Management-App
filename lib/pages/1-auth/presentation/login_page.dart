import 'package:finney/shared/path/app_images.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:finney/shared/widgets/common/snack_bar.dart';
import 'package:finney/pages/1-auth/widgets/my_button.dart';
import 'package:finney/pages/1-auth/widgets/my_textfield.dart';
import 'package:finney/pages/1-auth/widgets/square_tile.dart';
import 'package:finney/core/storage/storage_manager.dart';
import '../../../core/storage/cloud/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'google_sign_in.dart';
import 'forget_password.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:flutter_localization/flutter_localization.dart';

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
  // Show loading indicator
  showDialog(
    context: context,
    builder: (context) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      );
    },
  );

  try {
    // Sign in with Firebase Auth
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    // Get current user after sign in
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Create user model
      final userModel = UserModel(
        id: user.uid,
        email: user.email ?? '', 
        name: user.displayName ?? 'Unknown',
      );

      // Save to Firestore using Storage Manager
      await StorageManager().userCloudService.setCurrentUser(userModel);
    }

    // Dismiss loading dialog if mounted
    if (mounted) {
      Navigator.pop(context);
    }
  } on FirebaseAuthException catch (e) {
    // Dismiss loading dialog if mounted
    if (mounted) {
      Navigator.pop(context);
    }
    
    // Show appropriate error message
    String errorMessage = 'Incorrect email/password.\n\nPlease check again';
    if (e.code == 'user-not-found') {
      errorMessage = 'No user found with this email.';
    } else if (e.code == 'wrong-password') {
      errorMessage = 'Wrong password provided.';
    } else if (e.code == 'invalid-email') {
      errorMessage = 'The email address is not valid.';
    } else if (e.code == 'user-disabled') {
      errorMessage = 'This user account has been disabled.';
    }
    
    AppSnackBar.showError(context, message: errorMessage);
  } catch (e) {
    // Handle other errors
    if (mounted) {
      Navigator.pop(context);
    }
    AppSnackBar.showError(context, message: 'An error occurred during sign in.');
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
                      style: TextStyle(
                        color: AppColors.darkBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.w500, 
                      ),
                    ),
                  ),
                ),
            
                const SizedBox(height: 25),
            
                //email textfield
                MyTextField(
                  controller: emailController,
                  hintText: LocaleData.emailHint.getString(context),
                  obscureText: false,
                ),
            
                const SizedBox(height: 10),
            
                //password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: LocaleData.passwordHint.getString(context),
                  obscureText: true,
                ),
            
                const SizedBox(height: 10),
            
                //forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                        );
                      },
                      child: Text(
                        LocaleData.forgotPassword.getString(context),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
            
                const SizedBox(height: 25),
            
                //sign in button
                MyButton(
                  text: LocaleData.signInButton.getString(context),
                  onTap: signUserIn,
                ),
            
                const SizedBox(height: 50),
            
                //or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: AppColors.blurGray,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          LocaleData.continueWith.getString(context),
                          style: TextStyle(
                            color: AppColors.blurGray,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: AppColors.blurGray,
                        ),
                      ),
                    ],
                  ),
                ),
            
                const SizedBox(height: 50),
            
                //google sign in button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        GoogleSignInService.signInWithGoogle(context);
                    },
                      child: SquareTile(imagePath: AppImages.googleIcon),
                    ),
                  ],
                  
                ),
            
                const SizedBox(height: 50),
            
                //not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      LocaleData.notMember.getString(context),
                      style: TextStyle(color: AppColors.blurGray),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        LocaleData.registerNow.getString(context),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}