import 'package:flutter/material.dart';
import 'package:finney/pages/5-learn/advanced/advanced_quiz.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/localization/locales.dart';
import 'package:flutter_localization/flutter_localization.dart';

class AdvancedScreen extends StatelessWidget {
  const AdvancedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleData.advancedScreenTitle.getString(context)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: AppColors.darkBlue),
      ),
      backgroundColor: AppColors.softGray,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildLessonCard(
            context,
            icon: Icons.trending_up,
            titleKey: LocaleData.investmentBasicsTitle,
            pointKeys: [
              LocaleData.investmentBasicsPoint1,
              LocaleData.investmentBasicsPoint2,
              LocaleData.investmentBasicsPoint3,
            ],
          ),
          _buildLessonCard(
            context,
            icon: Icons.real_estate_agent,
            titleKey: LocaleData.retirementPlanningTitle,
            pointKeys: [
              LocaleData.retirementPlanningPoint1,
              LocaleData.retirementPlanningPoint2,
              LocaleData.retirementPlanningPoint3,
            ],
          ),
          _buildLessonCard(
            context,
            icon: Icons.health_and_safety,
            titleKey: LocaleData.insuranceProtectionTitle,
            pointKeys: [
              LocaleData.insuranceProtectionPoint1,
              LocaleData.insuranceProtectionPoint2,
              LocaleData.insuranceProtectionPoint3,
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AdvancedQuiz()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                LocaleData.takeAdvancedQuiz.getString(context),
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonCard(
    BuildContext context, {
    required IconData icon,
    required String titleKey,
    required List<String> pointKeys,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 28),
                const SizedBox(width: 12),
                Text(
                  titleKey.getString(context), // titleKey is already a String
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...pointKeys.map(
              (pointKey) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.circle, size: 8, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Expanded(child: Text(pointKey.getString(context))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}