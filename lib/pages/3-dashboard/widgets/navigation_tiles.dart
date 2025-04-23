import 'package:finney/pages/3-dashboard/saving/add_saving/saving_goal_page.dart';
import 'package:flutter/material.dart';
import 'package:finney/assets/theme/app_color.dart';

class NavigationTiles extends StatelessWidget {
  const NavigationTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavigationTile(
            context,
            'Reports',
            Icons.bar_chart,
            () => Navigator.pushNamed(
              context,
              '/reports',
            ), //the link is just a placeholder (same with the other links)
          ),
          _buildNavigationTile(
            context,
            'Budgets',
            Icons.account_balance_wallet,
            () => Navigator.pushNamed(context, '/budgets'),
          ),
          _buildNavigationTile(
            context,
            'AI Assistant',
            Icons.support_agent_rounded,
            () => Navigator.pushNamed(context, '/ai'),
          ),
          _buildNavigationTile(
            context,
            'Goals',
            Icons.flag,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SavingGoalPage()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: AppColors.primary, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.darkBlue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
