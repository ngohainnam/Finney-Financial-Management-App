import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:finney/assets/theme/app_color.dart';

Widget chatMessageBubble(ChatMessage message, ChatUser currentUser) {
  bool isUserMessage = message.user.id == currentUser.id;

  Color backgroundColor = AppColors.softGray; 
  Color textColor = Colors.black; 

  if (isUserMessage) {
    backgroundColor = AppColors.userChatColor;
    textColor = Colors.white;
  }

  return Container(
    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      message.text,
      style: TextStyle(
        color: textColor,
        fontSize: 16,
      ),
    ),
  );
}
