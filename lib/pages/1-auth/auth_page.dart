import 'package:finney/pages/1-auth/login_or_register_page.dart';
import 'package:finney/pages/layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/user_model.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            var box = Hive.box<UserModel>('userBox');
            UserModel? storedUser = box.get('user');

            if (storedUser == null) {
              User? user = snapshot.data;
              box.put(
                'user',
                UserModel(
                  uid: user?.uid ?? '',
                  email: user?.email ?? '',
                  name: '',
                ),
              );
            }
            return MainLayout();
          }

          return LoginOrRegisterPage();
        },
      ),
    );
  }
}
