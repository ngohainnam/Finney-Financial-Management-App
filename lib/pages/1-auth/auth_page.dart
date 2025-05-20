import 'package:finney/pages/1-auth/login_or_register_page.dart';
import 'package:finney/pages/3-dashboard/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          // If the user is logged in, show Dashboard
          if (snapshot.hasData) {
            return const Dashboard();
          }
          
          // If not logged in, show login or register page
          return const LoginOrRegisterPage();
        },
      ),
    );
  }
}