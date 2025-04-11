import 'package:flutter/material.dart';
import 'package:finney/assets/widgets/common/app_navbar.dart';
import 'package:finney/pages/2-chatbot/chatbot.dart';
import 'package:finney/pages/3-dashboard/dashboard.dart';
import 'package:finney/pages/4-report/report.dart';
import 'package:finney/pages/5-learn/learn.dart';
import 'package:finney/pages/6-setting/setting.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    Dashboard(),
    Chatbot(),
    Report(),
	Learn(),
    Setting(),
  ];

  void _handleNavigation(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: AppNavbar(
        selectedIndex: _selectedIndex,
        onTabChange: _handleNavigation,
      ),
    );
  }
}