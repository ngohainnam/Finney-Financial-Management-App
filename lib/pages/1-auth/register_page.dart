import 'package:finney/assets/path/app_images.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/assets/widgets/common/error_message.dart';
import 'package:finney/assets/widgets/common/my_button.dart';
import 'package:finney/assets/widgets/common/my_textfield.dart';
import 'package:finney/assets/widgets/common/square_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmedController = TextEditingController();

  //sign user up method
void signUserUp() async {
  //Show loading circle
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

  //Sign up process with Firebase
  // Sign up process with Firebase
  if (passwordController.text == confirmedController.text) {
    try {
      // Create user with Firebase
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // If user is successfully created, save to Hive
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Open Hive box
        var box = await Hive.openBox('userBox'); // Open or create a Hive box
        // Save user's UID and email to Hive
        await box.put('uid', user.uid);
        await box.put('email', user.email);

        // Fetch the stored user data from Hive
        var storedUid = box.get('uid');
        var storedEmail = box.get('email');
        
        if (storedUid != null && storedEmail != null) {
      
        } else {
          showErrorMessage(context,'Failed to store user in Hive.');
        }
      }

      if (mounted) {
        Navigator.pop(context); // Pop the loading circle
      }

    } catch (e) {
      // Handle error
      if (mounted) {
        Navigator.pop(context); // Pop the loading circle
      }
      showErrorMessage(context, 'Error: $e');
    }
  } else {
    Navigator.pop(context); // Pop the loading circle
    // Show if the password and confirm password are not the same
    showErrorMessage(context, 'Passwords do not match.');
  }
}

  // Display error message for authentication
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
                const SizedBox(height: 25),
            
                //logo
                Image.asset(AppImages.appLogo),
            
                const SizedBox(height: 25),
            
                //login text
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
            
                //email textfield
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
            
                const SizedBox(height: 10),
            
                //password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
            
                const SizedBox(height: 10),

                //confirm password textfield
                MyTextField(
                  controller: confirmedController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
            
                const SizedBox(height: 25),
            
                //sign in button
                MyButton(
                  text: 'Sign Up',
                  onTap: signUserUp,
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
                          'Or continue with',
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
                  children: const [
                    SquareTile(imagePath: AppImages.googleIcon),
                  ],
                ),
            
                const SizedBox(height: 50),
            
                //not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a member?',
                      style: TextStyle(color: AppColors.blurGray),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Log in now',
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
