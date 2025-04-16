import 'package:finney/assets/path/app_images.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:finney/assets/theme/app_color.dart';

class WelcomeScreen extends StatelessWidget {
  final List<String> suggestedQuestions;
  final Function(ChatMessage) onSendMessage;
  final ChatUser currentUser;
  final Function() onQuestionSelected;

  const WelcomeScreen({
    super.key,
    required this.suggestedQuestions,
    required this.onSendMessage,
    required this.currentUser,
    required this.onQuestionSelected,
  });

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Image.asset(AppImages.appLogo),
            const SizedBox(height: 30),
            _buildTryAskingText(),
            const SizedBox(height: 20),
            _buildSuggestedQuestions(),
            const SizedBox(height: 20),
            _buildSkipButton(),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildTryAskingText() {
    return Text(
      'Try asking',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey[700],
      ),
    );
  }

  Widget _buildSuggestedQuestions() {
    return Column(
      children: suggestedQuestions.map((question) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              onQuestionSelected();
              onSendMessage(ChatMessage(
                text: question,
                user: currentUser,
                createdAt: DateTime.now(),
              ));
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.chat_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      question,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.primary,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSkipButton() {
    return TextButton(
      onPressed: onQuestionSelected,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.5), // Use withOpacity instead of withValues
          ),
        ),
      ),
      child: Text(
        'Write your own question',
        style: TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}