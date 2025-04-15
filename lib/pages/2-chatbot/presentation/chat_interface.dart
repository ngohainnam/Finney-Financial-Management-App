import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:finney/assets/theme/app_color.dart';

class ChatInterface extends StatelessWidget {
  final ChatUser currentUser;
  final Function(ChatMessage) onSend;
  final List<ChatMessage> messages;
  final VoidCallback onMediaSend;

  const ChatInterface({
    super.key,
    required this.currentUser,
    required this.onSend,
    required this.messages,
    required this.onMediaSend,
  });

  @override
  Widget build(BuildContext context) {
    return DashChat(
      currentUser: currentUser,
      onSend: onSend,
      messages: messages,
      messageOptions: MessageOptions(
        containerColor: AppColors.softGray,
        currentUserContainerColor: AppColors.primary,
        textColor: Colors.black,
        currentUserTextColor: Colors.white,
        showTime: true,
      ),
      inputOptions: InputOptions(
        trailing: [
          IconButton(
            onPressed: onMediaSend,
            icon: Icon(Icons.image, color: AppColors.primary),
          ),
        ],
        inputDecoration: InputDecoration(
          hintText: "Ask me financial question. . .",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: AppColors.blurGray),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: AppColors.primary, width: 1),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        sendButtonBuilder: (onSend) => IconButton(
          icon: const Icon(Icons.send_rounded, color: AppColors.primary),
          onPressed: onSend,
        ),
      ),
    );
  }
}