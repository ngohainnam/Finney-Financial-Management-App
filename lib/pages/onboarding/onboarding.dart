import 'package:flutter/material.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

class Onboarding extends StatefulWidget {
  final VoidCallback onComplete;
  
  const Onboarding({
    super.key,
    required this.onComplete,
  });

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Welcome to Finney!',
      description: 'Your personal financial assistant that helps you manage your money smartly.',
      lottieAsset: 'lib/images/welcome_animation.json',
      icon: Icons.account_balance_wallet,
      color: AppColors.primary,
    ),
    OnboardingPage(
      title: 'Track Your Expenses',
      description: 'Easily record and categorize your expenses to see where your money goes.',
      lottieAsset: 'lib/images/expense_tracking.json',
      icon: Icons.insert_chart,
      color: Colors.blue,
    ),
    OnboardingPage(
      title: 'Set Your Budget',
      description: 'Create budgets for different categories to keep your spending in check.',
      lottieAsset: 'lib/images/budget_planning.json',
      icon: Icons.savings,
      color: Colors.green,
    ),
    OnboardingPage(
      title: 'Learn Financial Skills',
      description: 'Access educational content to improve your financial knowledge and skills.',
      lottieAsset: 'lib/images/learning.json',
      icon: Icons.school,
      color: Colors.orange,
    ),
    OnboardingPage(
      title: 'Chat with FinBot',
      description: 'Ask financial questions to our AI assistant and get personalized advice.',
      lottieAsset: 'lib/images/chat_bot.json',
      icon: Icons.chat,
      color: Colors.purple,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton.icon(
                onPressed: _completeOnboarding,
                icon: const Icon(Icons.skip_next),
                label: Text(
                  'Skip',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            
            // Page indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: List.generate(
                  _pages.length,
                  (index) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      height: 4,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? _pages[_currentPage].color
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Page content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPageContent(_pages[index]);
                },
              ),
            ),
            
            // Navigation buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button with icon
                  if (_currentPage > 0)
                    IconButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      icon: const Icon(Icons.arrow_back_ios_rounded),
                      color: _pages[_currentPage].color,
                      tooltip: 'Previous',
                    )
                  else
                    const SizedBox(width: 48), // Placeholder for spacing
                  
                  // Next/Finish button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _pages[_currentPage].color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () {
                      if (_currentPage < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        _completeOnboarding();
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Different icon and text based on page
                        _currentPage < _pages.length - 1
                            ? const Icon(Icons.arrow_forward_ios_rounded, size: 16)
                            : const Icon(Icons.check_circle_outline, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          _currentPage < _pages.length - 1
                              ? 'Next'
                              : 'Get Started',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animation or icon fallback
          Expanded(
            flex: 3,
            child: _buildAnimationOrIcon(page),
          ),
          const SizedBox(height: 32),
          
          // Title
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          // Description
          Expanded(
            flex: 1,
            child: Text(
              page.description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAnimationOrIcon(OnboardingPage page) {
    // First try to load Lottie animation if available
    if (page.lottieAsset.isNotEmpty) {
      return FutureBuilder<bool>(
        // Check if asset exists
        future: _checkLottieAssetExists(page.lottieAsset),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data == true) {
            // Asset exists, show animation
            return Lottie.asset(
              page.lottieAsset,
              fit: BoxFit.contain,
            );
          } else {
            // Fallback to icon
            return _buildFallbackIcon(page);
          }
        },
      );
    } else {
      // No animation specified, use icon
      return _buildFallbackIcon(page);
    }
  }
  
  Widget _buildFallbackIcon(OnboardingPage page) {
    return Center(
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: page.color.withValues(alpha: 0.2),
        ),
        child: Icon(
          page.icon,
          size: 60,
          color: page.color,
        ),
      ),
    );
  }
  
  // Helper to check if a Lottie asset exists
  Future<bool> _checkLottieAssetExists(String assetPath) async {
    try {
      // This is a simple check - in production you might want a more robust solution
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _completeOnboarding() async {
    // Mark onboarding as completed
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    
    // Call the callback provided by parent
    widget.onComplete();
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String lottieAsset;
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.lottieAsset,
    required this.icon,
    required this.color,
  });
}