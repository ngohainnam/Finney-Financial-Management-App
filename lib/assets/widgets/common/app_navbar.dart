import 'package:finney/assets/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class AppNavbar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;
  final Function(String)? onSearchSubmitted;
  final TextEditingController _searchController = TextEditingController();

  AppNavbar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
    this.onSearchSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 5,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search Text Field (keep)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Ask me financial question...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.blurGray.withAlpha(50),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send_rounded, color: AppColors.darkBlue),
                    onPressed: () {
                      if (_searchController.text.isNotEmpty && onSearchSubmitted != null) {
                        onSearchSubmitted!(_searchController.text);
                        _searchController.clear();
                      }
                    },
                  ),
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (value) {
                  if (value.isNotEmpty && onSearchSubmitted != null) {
                    onSearchSubmitted!(value);
                    _searchController.clear();
                  }
                },
              ),
            ),

            // Navigation Bar (your correct tabs)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              child: GNav(
                backgroundColor: Colors.transparent,
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
          ],
        ),
      ),
    );
  }
}
