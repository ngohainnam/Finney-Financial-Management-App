import 'package:finney/pages/2-chatbot/chatbot.dart';
import 'package:finney/pages/3-dashboard/budget_reminder_page.dart';
import 'package:finney/pages/3-dashboard/saving/add_saving/saving_goal_page.dart';
import 'package:finney/pages/7-insights/insights.dart';
import 'package:flutter/material.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/localization/locales.dart';


class NavigationTiles extends StatelessWidget {
  const NavigationTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 12),
          child: Text(
            LocaleData.aiPoweredFeatures.getString(context),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBlue,
            ),
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _buildNavigationTile(
                  context,
                  'Insights',
                  Icons.bar_chart,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Insights()),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildNavigationTile(
                  context,
                  'AI Assistant',
                  Icons.support_agent_rounded,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const Chatbot()),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 24, bottom: 12),
          child: Text(
            LocaleData.moneyTools.getString(context),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBlue,
            ),
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _buildNavigationTile(
                  context,
                  'Goals',
                  Icons.flag,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SavingGoalPage()),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildNavigationTile(
                  context,
                  'Reminders',
                  Icons.pie_chart,
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BudgetReminderPage()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getLocalizedTitle(BuildContext context, String title) {
    switch (title) {
      case 'Insights':
        return LocaleData.insights.getString(context);
      case 'AI Assistant':
        return LocaleData.aiAssistant.getString(context);
      case 'Goals':
        return LocaleData.goals.getString(context);
      default:
        return title;
    }
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
            _getLocalizedTitle(context, title),
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