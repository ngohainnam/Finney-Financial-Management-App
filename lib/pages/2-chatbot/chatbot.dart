import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];

  ChatUser currentUser = ChatUser(
    id:'0', 
    firstName: 'User'
  );

  ChatUser geminiUser = ChatUser(
    id: '1', 
    firstName: 'Finney AI', 
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
      currentUser: currentUser, 
      onSend: _sendMessage, 
      messages: messages,
      
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    //Add the user's message to the list first to update the UI
    setState(() {
      messages = [chatMessage] + messages;
    });

    try {
      String question = chatMessage.text;

      //Prepare the content for the chat (multi-turn)
      List<Content> conversation = [
        Content(
          parts: [Part.text(question)],
          role: 'user',
        ),
      ];

      //Call the Gemini chat method to handle multi-turn conversation
      gemini.chat(conversation).then((value) {    
        String response;
        if (value != null && value.output != null) {
          response = value.output!;
        } else {
          response = 'Something wrong with the model. Please try again later...';
        }

        //Create a new ChatMessage with the response
        ChatMessage message = ChatMessage(
          user: geminiUser, 
          createdAt: DateTime.now(),
          text: response,
        );
        //Add the new message to the conversation
        setState(() {
          messages = [message] + messages;
        });
      }).catchError((e) {
        //this is for catch error but havent implemented
      });
    } catch (e) {
      //this is for catch error but havent implemented
    }
  }
}