import 'package:finney/pages/0-onboarding/onboarding_questions.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:finney/shared/path/app_images.dart';
import 'package:flutter/material.dart';
import 'package:finney/shared/widgets/common/my_button.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:flutter_localization/flutter_localization.dart';

class OnboardingIntroPage extends StatefulWidget {
  const OnboardingIntroPage({super.key});

  @override
  State<OnboardingIntroPage> createState() => _OnboardingIntroPageState();
}

class _OnboardingIntroPageState extends State<OnboardingIntroPage> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _pages = [
    {
      "image": AppImages.appLogo,
      "title": LocaleData.onboardingWelcomeTitle,
      "desc": LocaleData.onboardingWelcomeDesc,
    },
    {
      "image": AppImages.appLogo,
      "title": LocaleData.onboardingTrackTitle,
      "desc": LocaleData.onboardingTrackDesc,
    },
    {
      "image": AppImages.appLogo,
      "title": LocaleData.onboardingBudgetTitle,
      "desc": LocaleData.onboardingBudgetDesc,
    },
    {
      "image": AppImages.appLogo,
      "title": LocaleData.onboardingAdviceTitle,
      "desc": LocaleData.onboardingAdviceDesc,
    },
    {
      "image": AppImages.appLogo,
      "title": LocaleData.onboardingInsightsTitle,
      "desc": LocaleData.onboardingInsightsDesc,
    },
    {
      "image": AppImages.appLogo,
      "title": LocaleData.onboardingLearnTitle,
      "desc": LocaleData.onboardingLearnDesc,
    },
  ];

  void _nextPage() {
    if (_currentIndex < _pages.length - 1) {
      _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OnboardingQuestionsPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentIndex = i),
                itemBuilder: (context, i) {
                  final page = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(page["image"]!, height: 200),
                        const SizedBox(height: 32),
                        Text(
                          page["title"]!.getString(context),
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.darkBlue),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page["desc"]!.getString(context),
                          style: const TextStyle(fontSize: 16, color: AppColors.darkBlue),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (i) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _currentIndex == i ? AppColors.primary : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: MyButton(
                onTap: _nextPage,
                text: _currentIndex == _pages.length - 1 ? LocaleData.finish.getString(context) : LocaleData.next.getString(context),
                backgroundColor: AppColors.darkBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}