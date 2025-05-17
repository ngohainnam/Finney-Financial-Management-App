import 'package:finney/assets/path/app_images.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/assets/widgets/common/error_message.dart';
import 'package:finney/assets/widgets/common/my_button.dart';
import 'package:finney/assets/widgets/common/my_textfield.dart';
import 'package:finney/assets/widgets/common/square_tile.dart';
import '../models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'google_sign_in.dart';
import 'forget_password.dart';
import 'package:finney/localization/locales.dart';
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

  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {

    var box = Hive.box<UserModel>('userBox'); 
    var storedUser = box.get('user');
    
    if (storedUser != null) {
      Navigator.pop(context);  
    } else {
      showErrorMessage(context,'User details not found in Hive');
      Navigator.pop(context); 
      showErrorMessage(context, 'User details not found in local storage.');
    }
  } else {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (mounted) {
        Navigator.pop(context);
      }

      user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        var userModel = UserModel(
          uid: user.uid,
          email: user.email ?? '', 
          name: user.displayName ?? 'Unknown',
        );

        // Open Hive box
        var box = await Hive.openBox<UserModel>('userBox');  
        await box.put('user', userModel);  
      }

    } on FirebaseAuthException {
      if (mounted) {
        Navigator.pop(context); 
      }
      showErrorMessage(context, 'Incorrect email/password.\n\nPlease check again');
    }
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