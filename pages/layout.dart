import 'package:flutter/material.dart';
import 'package:finney/assets/widgets/common/app_navbar.dart';
import 'package:finney/pages/chatbot/chatbot.dart';
import 'package:finney/pages/dashboard/dashboard.dart';
import 'package:finney/pages/learn/learn.dart';
import 'package:finney/pages/setting/setting.dart';


class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    Dashboard(),
    Learn(),
    Setting(),
  ];

  void _handleNavigation(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _handleSearchSubmitted(String question) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Chatbot(initialQuestion: question),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: AppNavbar(
        selectedIndex: _selectedIndex,
        onTabChange: _handleNavigation,
        onSearchSubmitted: _handleSearchSubmitted,
      ),
    );
  }
}
