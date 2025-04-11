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
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
          child: GNav(
            backgroundColor: Colors.transparent, // Changed to transparent
            color: AppColors.gray,
            activeColor: Colors.white,
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
                text: 'AI Chat',
              ),
              GButton(
                icon: Icons.bar_chart,
                text: 'Reports',
              ),
			  GButton(
				icon: Icons.menu_book, 
				text: 'Learn',
			  ),
              GButton(
                icon: Icons.settings,
                text: 'Settings',
              ),
            ],
          ),
        ),
      ),
    );
  }
}