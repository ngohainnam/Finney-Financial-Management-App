import 'dart:io';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/models/chat_message_model.dart';
import 'package:finney/pages/2-chatbot/chatbot_help.dart';
import 'package:finney/pages/2-chatbot/welcome_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  late Box<ChatMessageModel> chatBox;
  final gemini = Gemini.instance;
  bool showWelcomeScreen = true;
  List<ChatMessage> messages = [];

  //NEW UPDATE: this is for the conversation history using Hive storage (chatbot needs to remember the conversation)
  List<Content> conversationHistory = [];

  @override
  void initState() {
    super.initState();
    _initChatBox();
  }

  Future<void> _initChatBox() async {
    chatBox = await Hive.openBox<ChatMessageModel>('chat_message');
    _loadMessages();
  }

  void _loadMessages() {
    final savedMessages = chatBox.values.toList().reversed;
    setState(() {
      messages = savedMessages.map((model) => model.toChatMessage()).toList();
      // Rebuild conversation history
      conversationHistory = savedMessages.map((model) => Content(
        parts: [Part.text(model.text)],
        role: model.role,
      )).toList();
      if (messages.isNotEmpty) {
        showWelcomeScreen = false;
      }
    });
  }

  Future<void> _saveMessage(ChatMessage message, {required String role}) async {
    final messageModel = ChatMessageModel.fromChatMessage(message, role: role);
    await chatBox.add(messageModel);
  }

  void _sendMessage(ChatMessage chatMessage) async {
    setState(() {
      messages = [chatMessage] + messages;
      showWelcomeScreen = false;
    });
    await _saveMessage(chatMessage, role: 'user');

    try {
      String augmentedQuestion = "$_systemPrompt\n\nUser Question: ${chatMessage.text}";
      List<Part> parts = [];
      
      if (chatMessage.medias?.isNotEmpty ?? false) {
        Uint8List images = File(chatMessage.medias!.first.url).readAsBytesSync();
        parts.add(Part.uint8List(images));
      } else {
        parts.add(Part.text(augmentedQuestion));
      }

      conversationHistory.add(Content(
        parts: parts,
        role: 'user',
      ));

      gemini.chat(conversationHistory).then((value) async {    
        String response = value?.output ?? 'Something went wrong. Please try again later...';

        conversationHistory.add(Content(
          parts: [Part.text(response)],
          role: 'model',
        ));

        ChatMessage message = ChatMessage(
          user: geminiUser, 
          createdAt: DateTime.now(),
          text: response,
        );

        setState(() {
          messages = [message] + messages;
        });
        await _saveMessage(message, role: 'model');
      }).catchError((e) {
        setState(() {
          messages = [
            ChatMessage(
              user: geminiUser,
              createdAt: DateTime.now(),
              text: 'An error occurred. Please try again after 1 minute.',
            )
          ] + messages;
        });
      });
    } catch (e) {
      setState(() {
        messages = [
          ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: 'An error occurred. Please try again after 1 minute.',
          )
        ] + messages;
      });
      
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
            type: MediaType.image,
          ),
        ],
      );
      _sendMessage(message);
    }
  }

  Future<void> clearChat() async {
    await chatBox.clear();
    setState(() {
      messages = [];
      conversationHistory = [];
      showWelcomeScreen = true;
    });
  }

  @override
  void dispose() {
    chatBox.close();
    super.dispose();
  }

  final String _systemPrompt = """You are Finney AI, a financial assistant made by P26 Team, trained by Google.\n
  Your mission is to provide financial advice and management to users with low financial literacy and digital literacy.\n
  Your responses should be not too long but provide enough information, concise, and easy to understand.\n
  If the user asks a question that is not related to finance, you can respond with "I'm sorry, I can only help with financial questions.\n
  IF the user send an image is not related to finance, you can respond with "I'm sorry, this image is not related to finance.\n
  Always ask the user if they want more support in the topic you are discussing.\n
  """;

  final List<String> suggestedQuestions = [
    "How do I create a basic monthly budget?",
    "What are good ways to start saving money?",
    "Tips for reducing daily expenses",
  ];

  ChatUser currentUser = ChatUser(id: '0', firstName: 'User');
  ChatUser geminiUser = ChatUser(id: '1', firstName: 'Finney AI');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Text(
                'Finney AI',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),

              actions: [
                IconButton (
                  icon: Icon(Icons.help_outline),
                  onPressed: () {
                    ChatbotHelp.show(context);
                  }
                ),
                IconButton (
                  icon: Icon(Icons.delete_outline),
                  onPressed: clearChat,
                )
              ]

            ),


            Expanded(
              child: showWelcomeScreen && messages.isEmpty
                  ? WelcomeScreen(
                      suggestedQuestions: suggestedQuestions,
                      onSendMessage: _sendMessage,
                      currentUser: currentUser,
                      onQuestionSelected: () {
                        setState(() {
                          showWelcomeScreen = false;
                        });
                      },
                    )
                  : _buildChatInterface(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatInterface() {
    return DashChat(
      currentUser: currentUser,
      onSend: _sendMessage,
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
            onPressed: _sendMediaMessage,
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