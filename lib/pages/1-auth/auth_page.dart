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
          //if the user is logged in
          if (snapshot.hasData) {
            return Dashboard();
          }
          //if the user is not logged in
          else {
            return LoginOrRegisterPage();
          }
        }
      )
    );
  }
}