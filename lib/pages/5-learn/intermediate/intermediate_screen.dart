import 'package:flutter/material.dart';
import 'package:finney/pages/5-learn/intermediate/intermediate_quiz.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/localization/locales.dart';
import 'package:flutter_localization/flutter_localization.dart';

class IntermediateScreen extends StatelessWidget {
  const IntermediateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getSafeString(context, LocaleData.intermediateScreenTitle)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: AppColors.darkBlue),
      ),
      backgroundColor: AppColors.softGray,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildLessonCard(
            context: context,
            icon: Icons.pie_chart,
            titleKey: LocaleData.advancedBudgetingTitle,
            pointKeys: [
              LocaleData.advancedBudgetingPoint1,
              LocaleData.advancedBudgetingPoint2,
              LocaleData.advancedBudgetingPoint3,
            ],
            onTap: () {
            },
          ),
          _buildLessonCard(
            context: context,
            icon: Icons.credit_card,
            titleKey: LocaleData.creditBasicsTitle,
            pointKeys: [
              LocaleData.creditBasicsPoint1,
              LocaleData.creditBasicsPoint2,
              LocaleData.creditBasicsPoint3,
            ],
          ),
          _buildLessonCard(
            context: context,
            icon: Icons.savings,
            titleKey: LocaleData.savingStrategiesTitle,
            pointKeys: [
              LocaleData.savingStrategiesPoint1,
              LocaleData.savingStrategiesPoint2,
              LocaleData.savingStrategiesPoint3,
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const IntermediateQuiz(),
                  ),
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
                getSafeString(context, LocaleData.takeIntermediateQuiz),
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonCard({
    required BuildContext context,
    required IconData icon,
    required String titleKey,
    required List<String> pointKeys,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
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
                    getSafeString(context, titleKey),
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
                      Expanded(child: Text(getSafeString(context, pointKey))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fallback mechanism for missing translations
  String getSafeString(BuildContext context, String key) {
    final translation = key.getString(context);
    return translation == key ? 'Translation missing for $key' : translation;
  }
}