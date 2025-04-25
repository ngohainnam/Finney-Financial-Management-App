import 'package:finney/assets/path/app_images.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/assets/widgets/common/error_message.dart';
import 'package:finney/assets/widgets/common/my_button.dart';
import 'package:finney/assets/widgets/common/my_textfield.dart';
import 'package:finney/assets/widgets/common/square_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './google_sign_in.dart';

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

    if (!isValidGmail(email)) {
      Navigator.pop(context);
      showErrorMessage(context, "Please enter a valid Gmail address.");
      return;
    }

    if (password != confirmPassword) {
      Navigator.pop(context);
      showErrorMessage(context, 'Passwords do not match.');
      return;
    }

    if (!isPasswordStrong(password)) {
      Navigator.pop(context);
      showErrorMessage(
        context,
        'Password must be at least 12 characters long and include uppercase, lowercase, number, and symbol.',
      );
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: password,
      );

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        var box = await Hive.openBox('userBox');
        await box.put('uid', user.uid);
        await box.put('email', user.email);

        var storedUid = box.get('uid');
        var storedEmail = box.get('email');

        if (storedUid == null || storedEmail == null) {
          showErrorMessage(context, 'Failed to store user in Hive.');
        }
      }

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) Navigator.pop(context);
      showErrorMessage(context, 'Error: $e');
    }
  }

  void showErrorMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => ErrorDialog(message: message),
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
                      'Create your Account',
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
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: _obscurePassword,
                  onChanged: (value) {
                    final valid = isPasswordStrong(value);
                    setState(() {
                      _passwordHint = valid
                          ? '✅ Strong password'
                          : '❌ Use 12+ chars w/ upper, lower, number & symbol';
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
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),

                const SizedBox(height: 25),

                MyButton(
                  text: 'Sign Up',
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
                          'Or continue with',
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
                    Text('Already a member?', style: TextStyle(color: AppColors.blurGray)),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Log in now',
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
}