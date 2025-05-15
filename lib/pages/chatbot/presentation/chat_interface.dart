import 'package:finney/pages/chatbot/utils/robot_animation.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/assets/localization/locales.dart';
import 'package:flutter_localization/flutter_localization.dart';

class ChatInterface extends StatelessWidget {
  final ChatUser currentUser;
  final Function(ChatMessage) onSend;
  final List<ChatMessage> messages;
  final VoidCallback onMediaSend;
  final bool isAiTyping;

  const ChatInterface({
    super.key,
    required this.currentUser,
    required this.onSend,
    required this.messages,
    required this.onMediaSend,
    this.isAiTyping = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RobotAnimationHeader(isTyping: isAiTyping),
        
        Expanded(
          child: DashChat(
            currentUser: currentUser,
            onSend: onSend,
            messages: messages,
            messageOptions: MessageOptions(
              containerColor: AppColors.softGray,
              currentUserContainerColor: AppColors.primary,
              textColor: Colors.black,
              currentUserTextColor: Colors.white,
              showTime: false,
              showOtherUsersName: false,
              showOtherUsersAvatar: false,
              showCurrentUserAvatar: false,
            ),
            inputOptions: InputOptions(
              trailing: [
                IconButton(
                  onPressed: onMediaSend,
                  icon: Icon(Icons.image, color: AppColors.darkBlue),
                ),
              ],
              inputDecoration: InputDecoration(
                hintText: LocaleData.chatInputHint.getString(context),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none, 
                ),
                filled: true,
                fillColor: AppColors.blurGray.withValues(alpha: 0.2), 
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              sendButtonBuilder: (onSend) => IconButton(
                icon: const Icon(Icons.send_rounded, color: AppColors.darkBlue),
                onPressed: onSend,
              ),
            ),
          ),
        ),
      ],
    );
  }
}