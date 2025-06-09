import 'package:finney/pages/1-auth/login_or_register_page.dart';
import 'package:finney/pages/1-auth/presentation/pin_creation.dart';
import 'package:finney/pages/3-dashboard/dashboard.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2));
          }
          
          if (snapshot.hasData) {
            return FutureBuilder<String?>(
              future: FlutterSecureStorage().read(key: 'pin_${snapshot.data!.uid}'),
              builder: (context, pinSnapshot) {
                if (pinSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2));
                }
                if (pinSnapshot.data == null || pinSnapshot.data!.isEmpty) {
                  return const PinCreationPage();
                }
                return const Dashboard();
              },
            );
          }
          
          // If not logged in, show login or register page
          return const LoginOrRegisterPage();
        },
      ),
    );
  }
}