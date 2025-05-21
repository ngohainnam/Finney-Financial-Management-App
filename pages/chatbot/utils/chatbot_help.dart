import 'package:flutter/material.dart';
import 'package:finney/assets/widgets/common/help_dialog.dart';
import 'package:finney/localization/locales.dart';
import 'package:flutter_localization/flutter_localization.dart';

class ChatbotHelp {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AppDialog(
        title: LocaleData.chatbotHelpTitle.getString(context),
        subtitle: LocaleData.chatbotHelpSubtitle.getString(context),
        headerIcon: Icons.support_agent_rounded,
        instructions: [
          AppDialogInstruction(
            icon: Icons.chat_bubble_outline,
            text: LocaleData.chatbotHelpInstruction1.getString(context),
          ),
          AppDialogInstruction(
            icon: Icons.image_outlined,
            text: LocaleData.chatbotHelpInstruction2.getString(context),
          ),
          AppDialogInstruction(
            icon: Icons.mic,
            text: LocaleData.chatbotHelpInstruction3.getString(context),
          ),
          AppDialogInstruction(
            icon: Icons.touch_app_outlined,
            text: LocaleData.chatbotHelpInstruction4.getString(context),
          ),
        ],
      ),
    );
  }
}