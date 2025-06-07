import 'package:finney/shared/localization/locales.dart';
import 'package:finney/pages/2-chatbot/chatbot.dart';
import 'package:finney/pages/4-saving/saving_goal_page.dart';
import 'package:finney/pages/7-insights/insights.dart';
import 'package:finney/pages/5-learn/learn.dart';
//import 'package:finney/pages/8-report/report.dart';
import 'package:finney/pages/9-setting/setting.dart';
import 'package:finney/pages/10-reminders/budget_reminder_page.dart';
import 'package:flutter/material.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:flutter_localization/flutter_localization.dart';

class NavigationTiles extends StatelessWidget {
  const NavigationTiles({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Simple "Features" heading
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 16),
          child: Text(
            LocaleData.features.getString(context),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBlue,
            ),
          ),
        ),
        
        // 3x3 grid of feature tiles
        _buildFeatureGrid(context),
        
        const SizedBox(height: 24),
        
        // Academy banner
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _buildAcademyBanner(context),
        ),
      ],
    );
  }

  Widget _buildFeatureGrid(BuildContext context) {
    // Define our navigation items with custom colors
    final features = [
      _FeatureItem(
        title: 'Insights',
        icon: Icons.bar_chart,
        color: Colors.blue,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const Insights()),
        ),
      ),
      _FeatureItem(
        title: 'AI Assistant',
        icon: Icons.question_answer,
        color: Colors.indigo,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const Chatbot()),
        ),
      ),

/* Review part for now: Joy's section
      _FeatureItem(
        title: 'Prediction',
        icon: Icons.insights_rounded,
        color: Colors.orange,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const Report()),
        ),
      ),
*/
      _FeatureItem(
        title: 'Goals',
        icon: Icons.flag,
        color: Colors.green,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SavingGoalPage()),
        ),
      ),
      _FeatureItem(
        title: 'Reminder',
        icon: Icons.alarm,
        color: Colors.red,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const BudgetReminderPage()),
        ),
      ),
      _FeatureItem(
        title: 'Settings',
        icon: Icons.settings,
        color: Colors.blueGrey,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const Setting()),
        ),
      ),
    ];

    // Build a grid with 3 items per row
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      mainAxisSpacing: 16,
      crossAxisSpacing: 12,
      childAspectRatio: 0.9,
      children: features.map((feature) => _buildNavigationTile(
        context,
        feature.title,
        feature.icon,
        feature.color,
        feature.onTap,
      )).toList(),
    );
  }

  Widget _buildAcademyBanner(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const Learn()),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withValues(alpha: 0.9),
              AppColors.darkBlue,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    LocaleData.financeAcademy.getString(context),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    LocaleData.learnFinanceDescription.getString(context),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.school,
                color: AppColors.primary,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLocalizedTitle(BuildContext context, String title) {
    switch (title) {
      case 'Insights':
        return LocaleData.insights.getString(context);
      case 'AI Assistant':
        return LocaleData.aiAssistant.getString(context);
      case 'Prediction':
        return LocaleData.prediction.getString(context);
      case 'Goals':
        return LocaleData.goals.getString(context);
      case 'Reminder':
        return LocaleData.reminder.getString(context);
      case 'Settings':
        return LocaleData.settings.getString(context);
      default:
        return title;
    }
  }

  Widget _buildNavigationTile(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 50),
          ),
          const SizedBox(height: 8),
          Text(
            _getLocalizedTitle(context, title),
            style: TextStyle(
              fontSize: 12,
              color: AppColors.darkBlue,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// Helper class to organize feature data
class _FeatureItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  
  _FeatureItem({
    required this.title,
    required this.icon,
    this.color = AppColors.primary, // Default to primary app color
    required this.onTap,
  });
}