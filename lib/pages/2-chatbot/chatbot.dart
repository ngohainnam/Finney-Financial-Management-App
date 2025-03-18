import 'dart:io';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final gemini = Gemini.instance;

  final String _systemPrompt = """You are Finney AI, a financial assistant made by P26 Team, trained by Google.\n
  Your mission is to provide financial advice and management to users with low financial literacy and digital literacy.\n
  Your responses should be not too long but provide enough information, concise, and easy to understand.\n
  If the user asks a question that is not related to finance, you can respond with "I'm sorry, I can only help with financial questions.\n
  If the user sends a picture, if it is finance related, describe the picture.\n
  Always ask the user if they want more support in the topic you are discussing.\n
  """;
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
    messageOptions: MessageOptions(
      containerColor: AppColors.softGray,
      currentUserContainerColor: AppColors.primary,
      textColor: Colors.black,
      currentUserTextColor: Colors.white,
    ),
    inputOptions: InputOptions(
      trailing: [
        IconButton(
          onPressed: _sendMediaMessage,
          icon: Icon(Icons.image, color: AppColors.primary),
        ),
      ],
      inputDecoration: InputDecoration(
        hintText: "How can Finney AI help you?",
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

  void _sendMessage(ChatMessage chatMessage) {
    //Add the user's message to the list first to update the UI
    setState(() {
      messages = [chatMessage] + messages;
    });

    try {
      String augmentedQuestion = "$_systemPrompt\n\nUser Question: ${chatMessage.text}";

      // Prepare the content parts based on whether there's media or not
      List<Part> parts = [];
      
      // Add image part if media is present
      if (chatMessage.medias?.isNotEmpty ?? false) {
        Uint8List images = File(chatMessage.medias!.first.url).readAsBytesSync();
        parts.add(Part.uint8List(images));
      }
      else {
        parts.add(Part.text(augmentedQuestion));
      }

      // Prepare the content for the chat
      List<Content> conversation = [
        Content(
          parts: parts,
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

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (file != null) {
      ChatMessage message = ChatMessage(
        user: currentUser,
        createdAt: DateTime.now(),
        medias: [
          ChatMedia(
            url: file.path, 
            fileName: '',
            type:MediaType.image,
          ),
        ],
      );
      _sendMessage(message);
    }
  }
}