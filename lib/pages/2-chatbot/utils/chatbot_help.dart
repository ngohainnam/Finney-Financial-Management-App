import 'package:flutter/material.dart';
import 'package:finney/shared/widgets/common/help_pages.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/shared/path/app_images.dart';

class ChatbotHelp {
  static void show(BuildContext context) {
    final pages = [
      AppHelpPage(
        title: LocaleData.chatbotHelpTitle.getString(context),
        image: Image.asset(
          AppImages.chatbotText,
          fit: BoxFit.contain,
        ),
        description: LocaleData.chatbotHelpInstruction1.getString(context),
      ),
      AppHelpPage(
        title: LocaleData.chatbotHelpTitle.getString(context),
        image: Image.asset(
          AppImages.chatbotImage,
          fit: BoxFit.contain,
        ),
        description: LocaleData.chatbotHelpInstruction2.getString(context),
      ),
      AppHelpPage(
        title: LocaleData.chatbotHelpTitle.getString(context),
        image: Image.asset(
          AppImages.chatbotVoice,
          fit: BoxFit.contain,
        ),
        description: LocaleData.chatbotHelpInstruction3.getString(context),
      ),
      AppHelpPage(
        title: LocaleData.chatbotHelpTitle.getString(context),
        image: Image.asset(
          AppImages.chatbotInteraction,
          fit: BoxFit.contain,
        ),
        description: LocaleData.chatbotHelpInstruction4.getString(context),
      ),
    ];
    
    AppHelp.show(context, pages);
  }
}