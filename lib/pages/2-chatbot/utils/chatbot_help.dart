import 'package:flutter/material.dart';
import 'package:finney/assets/widgets/common/help_dialog.dart';

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
            text: "Upload financial images for analysis",
          ),
          AppDialogInstruction(
            icon: Icons.mic,
            text: "You can use the microphone to talk with the AI assistant",
          ),
          AppDialogInstruction(
            icon: Icons.touch_app_outlined,
            text: "Try suggested questions or type your own",
          ),
        ],
      ),
    );
  }
}