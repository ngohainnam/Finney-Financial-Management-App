import 'package:flutter/material.dart';
import 'package:finney/shared/theme/app_color.dart';

// Search for "policy.txt" to view the full policy text
class PolicyPage extends StatelessWidget {
  const PolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.darkBlue),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Terms & Privacy Policy',
          style: TextStyle(
            color: AppColors.darkBlue,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 700,
          constraints: const BoxConstraints(maxWidth: 800),
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PolicySection(
                        title: 'Last Updated',
                        children: [
                          '10 June 2025',
                        ],
                      ),
                      const SizedBox(height: 18),
                      _PolicySection(
                        title: '1. Introduction',
                        children: [
                          'Welcome to Finney AI. By creating an account and using our money tracking app (“the App”), you agree to these Terms and Conditions. If you do not accept these terms, please refrain from using the App.',
                        ],
                      ),
                      const SizedBox(height: 18),
                      _PolicySection(
                        title: '2. Account Registration',
                        children: [
                          '• You must provide accurate and up-to-date information during registration.',
                          '• You are responsible for safeguarding your login credentials and for all activities under your account.',
                          '• Notify us immediately if you suspect unauthorized access.',
                        ],
                      ),
                      const SizedBox(height: 18),
                      _PolicySection(
                        title: '3. User Conduct',
                        children: [
                          'You agree to use the App in compliance with all applicable laws and must not:',
                          '• Use the App for unlawful purposes.',
                          '• Attempt to interfere with or reverse-engineer any part of the App.',
                          '• Upload harmful content or impersonate others.',
                        ],
                      ),
                      const SizedBox(height: 18),
                      _PolicySection(
                        title: '4. Intellectual Property',
                        children: [
                          '• All content, features, and technology of the App are owned by Finney AI and protected by applicable laws.',
                          '• You may not copy, modify, or redistribute any part of the App without prior written consent.',
                          '• Any feedback or input you provide may be used by Finney AI without obligation or attribution.',
                        ],
                      ),
                      const SizedBox(height: 18),
                      _PolicySection(
                        title: '5. Account Termination',
                        children: [
                          '• You may request account deletion at any time.',
                          '• We reserve the right to suspend or terminate accounts that violate these terms or compromise the integrity of the App or its users.',
                        ],
                      ),
                      const SizedBox(height: 18),
                      _PolicySection(
                        title: '6. Disclaimer and Liability',
                        children: [
                          '• The App is provided “as is” without warranties of any kind.',
                          '• We do not guarantee uninterrupted or error-free service.',
                          '• To the fullest extent permitted by law, Finney AI is not liable for any indirect or consequential damages arising from your use of the App.',
                        ],
                      ),
                      const SizedBox(height: 18),
                      _PolicySection(
                        title: '7. Data and Privacy',
                        children: [
                          '• Your expense data is stored securely in our Firebase database and may be processed using Large Language Models (LLMs) to generate financial insights.',
                          '• Your data will not be used to train AI systems or shared with advertisers.',
                          '• We apply security measures to protect your information and offer data deletion upon request.',
                        ],
                      ),
                      const SizedBox(height: 18),
                      _PolicySection(
                        title: '8. Financial Disclaimer',
                        children: [
                          '• Advice or suggestions offered in the App are generated automatically and should not be considered professional financial guidance.',
                          '• Always consult a qualified advisor for personal financial decisions.',
                        ],
                      ),
                      const SizedBox(height: 18),
                      _PolicySection(
                        title: '9. Modifications',
                        children: [
                          '• We may update these Terms at any time.',
                          '• Continued use of the App after updates indicates your acceptance of the revised terms.',
                          '• The effective date is shown at the top of this document.',
                        ],
                      ),
                      const SizedBox(height: 18),
                      _PolicySection(
                        title: '10. Contact',
                        children: [
                          'For questions or support, contact us at: ',
                        ],
                      ),
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
}

class _PolicySection extends StatelessWidget {
  final String title;
  final List<String> children;

  const _PolicySection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.darkBlue.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.darkBlue,
              fontWeight: FontWeight.bold,
              fontSize: 16.5,
            ),
          ),
          const SizedBox(height: 8),
          ...children.map((line) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  line,
                  style: TextStyle(
                    color: AppColors.darkBlue,
                    fontSize: 15,
                    fontWeight: line.startsWith('•') ? FontWeight.normal : FontWeight.w500,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}