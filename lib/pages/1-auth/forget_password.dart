import 'package:finney/assets/path/app_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/assets/widgets/error_message.dart';
import 'package:finney/assets/widgets/my_button.dart';
import 'package:finney/assets/widgets/my_textfield.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ForgotPasswordPageState createState() => ForgotPasswordPageState();
}

class ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  void sendPasswordResetEmail() async {
    // Show a loading indicator
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
      // Trigger Firebase's password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);

      // Close the loading indicator
      Navigator.pop(context);

      // Show a success message
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Password Reset'),
            content: Text('A password reset link has been sent to your email.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Close the loading indicator
      Navigator.pop(context);

      // Show error message if the email fails to send
      showErrorMessage(context, 'Error: ${e.toString()}');
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
                      'Forgot Password',
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
                  hintText: 'Enter your email',
                  obscureText: false,
                ),
                const SizedBox(height: 25),
                MyButton(
                  text: 'Send Reset Link',
                  onTap: sendPasswordResetEmail,
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Navigate back to login page
                  },
                  child: Text(
                    'Back to login',
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
}
