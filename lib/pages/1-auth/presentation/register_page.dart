import 'package:finney/shared/path/app_images.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:finney/shared/widgets/common/snack_bar.dart';
import 'package:finney/pages/1-auth/widgets/my_button.dart';
import 'package:finney/pages/1-auth/widgets/my_textfield.dart';
import 'package:finney/pages/1-auth/widgets/square_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finney/core/storage/storage_manager.dart';
import 'package:finney/core/storage/cloud/models/user_model.dart';
import 'google_sign_in.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:flutter_localization/flutter_localization.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmedController = TextEditingController();
  final nameController = TextEditingController(); // Added name field controller

  String _passwordHint = '';
  Color _hintColor = Colors.grey;
  bool _obscurePassword = true;

  bool isValidGmail(String email) {
    final gmailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
    return gmailRegex.hasMatch(email);
  }

  bool isPasswordStrong(String password) {
    final lengthValid = password.length >= 12;
    final upperCaseValid = password.contains(RegExp(r'[A-Z]'));
    final lowerCaseValid = password.contains(RegExp(r'[a-z]'));
    final numberValid = password.contains(RegExp(r'[0-9]'));
    final symbolValid = password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));

    return lengthValid && upperCaseValid && lowerCaseValid && numberValid && symbolValid;
  }

  void signUserUp() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmedController.text.trim();
    final name = nameController.text.trim(); // Get name value

    // Validate name field
    if (name.isEmpty) {
      Navigator.pop(context);
      AppSnackBar.showError(
        context, 
        message: 'Please enter your name'
      );
      return;
    }

    if (!isValidGmail(email)) {
      Navigator.pop(context);
      AppSnackBar.showError(
        context, 
        message: LocaleData.invalidGmailError.getString(context)
      );
      return;
    }

    if (password != confirmPassword) {
      Navigator.pop(context);
      AppSnackBar.showError(
        context, 
        message: LocaleData.passwordsNotMatchError.getString(context)
      );
      return;
    }

    if (!isPasswordStrong(password)) {
      Navigator.pop(context);
      AppSnackBar.showError(
        context,
        message: LocaleData.weakPasswordError.getString(context)
      );
      return;
    }

    try {
      // Create user with email and password
      UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update the display name
      await credential.user?.updateDisplayName(name);

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Create UserModel
        final userModel = UserModel(
          id: user.uid,
          name: name,
          email: email,
        );

        // Save user to Firestore
        await StorageManager().userCloudService.setCurrentUser(userModel);
      }

      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        Navigator.pop(context);
        String errorMessage = 'Registration failed';
        
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'This email is already in use.';
            break;
          case 'invalid-email':
            errorMessage = 'Invalid email format.';
            break;
          case 'weak-password':
            errorMessage = 'The password is too weak.';
            break;
          default:
            errorMessage = 'Registration error: ${e.message}';
        }
        
        AppSnackBar.showError(context, message: errorMessage);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        AppSnackBar.showError(
          context, 
          message: 'Error: $e'
        );
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
                const SizedBox(height: 25),
                Image.asset(AppImages.appLogo),
                const SizedBox(height: 25),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      LocaleData.registerTitle.getString(context),
                      style: TextStyle(
                        color: AppColors.darkBlue,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Name field
                MyTextField(
                  controller: nameController,
                  hintText: 'Full Name',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  controller: emailController,
                  hintText: LocaleData.emailHint.getString(context),
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  controller: passwordController,
                  hintText: LocaleData.passwordHint.getString(context),
                  obscureText: _obscurePassword,
                  onChanged: (value) {
                    final valid = isPasswordStrong(value);
                    setState(() {
                      _passwordHint = valid
                          ? LocaleData.passwordStrong.getString(context)
                          : LocaleData.passwordWeak.getString(context);
                      _hintColor = valid ? Colors.green : Colors.red;
                    });
                  },
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _passwordHint,
                      style: TextStyle(color: _hintColor, fontSize: 12),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                MyTextField(
                  controller: confirmedController,
                  hintText: LocaleData.confirmPasswordHint.getString(context),
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                MyButton(
                  text: LocaleData.signUpButton.getString(context),
                  onTap: signUserUp,
                ),

                const SizedBox(height: 50),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(thickness: 0.5, color: AppColors.blurGray),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          LocaleData.continueWith.getString(context),
                          style: TextStyle(color: AppColors.blurGray),
                        ),
                      ),
                      Expanded(
                        child: Divider(thickness: 0.5, color: AppColors.blurGray),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => GoogleSignInService.signInWithGoogle(context),
                      child: SquareTile(imagePath: AppImages.googleIcon),
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      LocaleData.alreadyMember.getString(context),
                      style: TextStyle(color: AppColors.blurGray)),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        LocaleData.loginNow.getString(context),
                        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
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
  
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmedController.dispose();
    nameController.dispose(); // Dispose name controller
    super.dispose();
  }
}