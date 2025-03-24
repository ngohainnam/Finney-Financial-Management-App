import 'package:finney/assets/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class AppNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const AppNavbar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: GNav(
          backgroundColor: Colors.white,
          color: AppColors.softGray, // Unselected item color
          activeColor: Colors.white, // Selected item color
          tabBackgroundGradient: AppColors.ombreBlue,
          iconSize: 25,
          padding: const EdgeInsets.all(16),
          gap: 8,
          onTabChange: onTabChange,
          selectedIndex: selectedIndex,
          tabs: const [
            GButton(
              icon: Icons.dashboard,
              text: 'Dashboard',
            ),
            GButton(
              icon: Icons.chat,
              text: 'Chatbot',
            ),
            GButton(
              icon: Icons.bar_chart,
              text: 'Report',
            ),
            GButton(
              icon: Icons.settings,
              text: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}