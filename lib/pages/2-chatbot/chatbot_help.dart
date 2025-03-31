import 'package:flutter/material.dart';
import 'package:finney/assets/widgets/help_dialog.dart';

class ChatbotHelp {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AppDialog(
        title: "How to Use Finney AI",
        subtitle: "Your personal financial assistant",
        headerIcon: Icons.support_agent_rounded,
        instructions: const [
          AppDialogInstruction(
            icon: Icons.chat_bubble_outline,
            text: "Ask finance-related questions for instant advice",
          ),
          AppDialogInstruction(
            icon: Icons.image_outlined,
            text: "Upload financial documents or receipts for analysis",
          ),
          AppDialogInstruction(
            icon: Icons.psychology_outlined,
            text: "Get personalized financial guidance and tips",
          ),
          AppDialogInstruction(
            icon: Icons.touch_app_outlined,
            text: "Try suggested questions or type your own :)",
          ),
        ],
      ),
    );
  }
}