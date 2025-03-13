import 'package:finney/assets/path/app_images.dart';
import 'package:finney/pages/2-chatbot/chatbot.dart';
import 'package:finney/pages/3-dashboard/dashboard.dart';
import 'package:finney/pages/4-report/report.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          children: [
            DrawerHeader(
              child: Image.asset(AppImages.appLogo),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text(
                'Dashboard',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Dashboard()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.chat),
              title: const Text(
                'AI Assistant',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Chatbot()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text(
                'Report',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Visualize()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Sign Out',
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
              onTap: () {
                signUserOut();
              }
            ),
          ],
        ),
      ),
    );
  }
}
