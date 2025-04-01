import 'package:finney/assets/path/app_images.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/assets/widgets/common/error_message.dart';
import 'package:finney/assets/widgets/common/my_button.dart';
import 'package:finney/assets/widgets/common/my_textfield.dart';
import 'package:finney/assets/widgets/common/square_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../models/user_model.dart';

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

  // Check if the user is already signed in
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    // If the user is already signed in, log their details and navigate accordingly
    
    // You can retrieve the stored user details from Hive
    var box = await Hive.openBox<UserModel>('userBox');  // Open the box for UserModel
    var storedUser = box.get('user');  // Assuming you store the full user object
    
    if (storedUser != null) {
      Navigator.pop(context);  // Close loading circle
    } else {
      showErrorMessage(context,'User details not found in Hive');
      Navigator.pop(context);  // Close loading circle
      showErrorMessage(context, 'User details not found in local storage.');
    }
  } else {
    // If the user is not signed in, proceed with the sign-in process
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (mounted) {
        Navigator.pop(context); // Pop the loading circle
      }

      // Get the signed-in user's details
      user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Create UserModel instance
        var userModel = UserModel(
          uid: user.uid,
          email: user.email ?? '',  // Handle the case where email is null
          name: user.displayName ?? 'Unknown',  // Handle null display name
        );

        // Open Hive box
        var box = await Hive.openBox<UserModel>('userBox');  // Open or create a Hive box
        await box.put('user', userModel);  // Save UserModel object using 'user' as the key
      }

    } on FirebaseAuthException {
      if (mounted) {
        Navigator.pop(context); // Pop the loading circle
      }
      // Handle Firebase error
      showErrorMessage(context, 'Incorrect email/password.\n\nPlease check again');
    }
  }
}

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; 

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;
      
      if (user != null) {
        var box = await Hive.openBox<UserModel>('userBox');
        var userModel = UserModel(uid: user.uid, email: user.email ?? '', name: user.displayName ?? 'Unknown');
        await box.put('user', userModel);
      }
    } catch (error) {
      showErrorMessage(context, 'Google Sign-In failed.');
    }
  }

  //Display error message for authentication
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
            
                //login text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Align(
                    alignment: Alignment.centerLeft, 
                    child: Text(
                      'Login to your Account',
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
            
                //forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            
                const SizedBox(height: 25),
            
                //sign in button
                MyButton(
                  text: 'Sign In',
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
                  children: [
                    GestureDetector(
                      onTap: signInWithGoogle, // Calls the Google Sign-In function
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
                      'Not a member?',
                      style: TextStyle(color: AppColors.blurGray),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        'Register now',
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
