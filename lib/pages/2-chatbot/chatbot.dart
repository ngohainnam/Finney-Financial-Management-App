import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/pages/2-chatbot/presentation/chat_interface.dart';
import 'package:finney/pages/2-chatbot/services/storage_service.dart';
import 'package:finney/pages/2-chatbot/utils/chat_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:image_picker/image_picker.dart';
import 'services/chat_service.dart';
import 'presentation/welcome_screen.dart';
import 'utils/chatbot_help.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final ChatStorageService _storageService = ChatStorageService();
  late ChatService _chatService;
  final gemini = Gemini.instance;
  bool showWelcomeScreen = true;
  List<ChatMessage> messages = [];
  List<Content> conversationHistory = [];

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    await _storageService.init();
    _chatService = ChatService(
      gemini: gemini,
      conversationHistory: conversationHistory,
    );
    _loadMessages();
  }

  void _loadMessages() {
    setState(() {
      messages = _storageService.loadMessages();
      conversationHistory = _storageService.loadConversationHistory();
      if (messages.isNotEmpty) {
        showWelcomeScreen = false;
      }
    });
  }

  void _sendMessage(ChatMessage chatMessage) async {
    setState(() {
      messages = [chatMessage] + messages;
      showWelcomeScreen = false;
    });
    await _storageService.saveMessage(chatMessage, role: 'user');

    final response = await _chatService.sendMessage(chatMessage);
    final message = ChatMessage(
      user: ChatConstants.geminiUser,
      createdAt: DateTime.now(),
      text: response,
    );

    setState(() {
      messages = [message] + messages;
    });
    await _storageService.saveMessage(message, role: 'model');
  }

  void _sendMediaMessage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      final message = ChatMessage(
        user: ChatConstants.currentUser,
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
    await _storageService.clearChat();
    setState(() {
      messages = [];
      conversationHistory = [];
      showWelcomeScreen = true;
    });
  }

  @override
  void dispose() {
    _storageService.dispose();
    super.dispose();
  }

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
                IconButton(
                  icon: Icon(Icons.help_outline),
                  onPressed: () => ChatbotHelp.show(context),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline),
                  onPressed: clearChat,
                )
              ],
            ),
            Expanded(
              child: showWelcomeScreen && messages.isEmpty
                  ? WelcomeScreen(
                      suggestedQuestions: ChatConstants.suggestedQuestions,
                      onSendMessage: _sendMessage,
                      currentUser: ChatConstants.currentUser,
                      onQuestionSelected: () {
                        setState(() {
                          showWelcomeScreen = false;
                        });
                      },
                    )
                  : ChatInterface(
                      currentUser: ChatConstants.currentUser,
                      onSend: _sendMessage,
                      messages: messages,
                      onMediaSend: _sendMediaMessage,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}