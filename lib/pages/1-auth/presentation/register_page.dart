import 'package:finney/pages/1-auth/presentation/policy.dart';
import 'package:finney/shared/path/app_images.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:finney/shared/widgets/common/my_button.dart';
import 'package:finney/shared/widgets/common/snack_bar.dart';
import 'package:finney/pages/1-auth/widgets/my_textfield.dart';
import 'package:finney/pages/1-auth/widgets/square_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finney/core/storage/storage_manager.dart';
import 'package:finney/core/storage/cloud/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final nameController = TextEditingController();

  String _passwordHint = '';
  Color _hintColor = Colors.grey;
  bool _obscurePassword = true;
  bool _agreedToPolicy = false;

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
          child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
        );
      },
    );

    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmedController.text.trim();
    final name = nameController.text.trim();

    // 1. Name check
    if (name.isEmpty) {
      Navigator.pop(context);
      AppSnackBar.showError(
        context,
        message: LocaleData.pleaseEnterName.getString(context),
      );
      return;
    }

    // 2. Email check
    if (!isValidGmail(email)) {
      Navigator.pop(context);
      AppSnackBar.showError(
        context,
        message: LocaleData.invalidGmailError.getString(context),
      );
      return;
    }

    // 3. Password match check
    if (password != confirmPassword) {
      Navigator.pop(context);
      AppSnackBar.showError(
        context,
        message: LocaleData.passwordsNotMatchError.getString(context),
      );
      return;
    }

    // 4. Password strength check
    if (!isPasswordStrong(password)) {
      Navigator.pop(context);
      AppSnackBar.showError(
        context,
        message: LocaleData.weakPasswordError.getString(context),
      );
      return;
    }

    // 5. Policy agreement check (last)
    if (!_agreedToPolicy) {
      Navigator.pop(context);
      AppSnackBar.showError(
        context,
        message: 'Please read and agree to the Terms & Privacy Policy.',
      );
      return;
    }

    try {
      UserCredential credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName(name);

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final userModel = UserModel(
          id: user.uid,
          name: name,
          email: email,
        );
        await StorageManager().userCloudService.setCurrentUser(userModel);

        // Ensure onboarding field is set for new users
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'onboarding': null,
        }, SetOptions(merge: true));
      }

      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        Navigator.pop(context);
        String errorMessage = LocaleData.registrationFailed.getString(context);

        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = LocaleData.emailAlreadyInUse.getString(context);
            break;
          case 'invalid-email':
            errorMessage = LocaleData.invalidEmailFormat.getString(context);
            break;
          case 'weak-password':
            errorMessage = LocaleData.weakPassword.getString(context);
            break;
          default:
            errorMessage = '${LocaleData.registrationFailed.getString(context)} ${e.message}';
        }

        AppSnackBar.showError(context, message: errorMessage);
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        AppSnackBar.showError(
          context,
          message: '${LocaleData.error.getString(context)} $e',
        );
      }
    }
  }

  void _showPolicyDialog() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const PolicyPage()),
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

                MyTextField(
                  controller: nameController,
                  hintText: LocaleData.nameHint.getString(context),
                  obscureText: false,
                ),

                MyTextField(
                  controller: emailController,
                  hintText: LocaleData.emailHint.getString(context),
                  obscureText: false,
                ),

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

                if (_passwordHint.isNotEmpty)
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

                MyTextField(
                  controller: confirmedController,
                  hintText: LocaleData.confirmPasswordHint.getString(context),
                  obscureText: true,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: CheckboxListTile(
                    value: _agreedToPolicy,
                    onChanged: (value) {
                      setState(() {
                        _agreedToPolicy = value ?? false;
                      });
                    },
                    activeColor: AppColors.primary,
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    title: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: AppColors.darkBlue,
                          fontSize: 14,
                        ),
                        children: [
                          const TextSpan(text: 'I agree to the '),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: GestureDetector(
                              onTap: _showPolicyDialog,
                              child: Text(
                                'Terms & Privacy Policy',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                MyButton(
                  text: LocaleData.signUpButton.getString(context),
                  onTap: signUserUp,
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
                      LocaleData.alreadyMember.getString(context),
                      style: TextStyle(color: AppColors.darkBlue)),
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
    nameController.dispose();
    super.dispose();
  }
}