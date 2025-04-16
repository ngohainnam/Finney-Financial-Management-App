import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/pages/2-chatbot/presentation/chat_interface.dart';
import 'package:finney/pages/2-chatbot/presentation/voicechat_interface.dart';
import 'package:finney/pages/2-chatbot/services/llm_transactionparser.dart';
import 'package:finney/pages/2-chatbot/services/storage_service.dart';
import 'package:finney/pages/2-chatbot/utils/chat_constants.dart'; 
import 'package:finney/pages/3-dashboard/services/transaction_services.dart'; 
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
  final TransactionService _transactionService = TransactionService();
  late ChatService _chatService;
  final gemini = Gemini.instance;
  bool showWelcomeScreen = true;
  List<ChatMessage> messages = [];
  List<Content> conversationHistory = [];
  
  //for transaction handling
  bool _awaitingTransactionConfirmation = false;
  Map<String, dynamic>? _pendingTransaction;

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
      showWelcomeScreen = messages.isEmpty;
    });
  }

  void _sendMessage(ChatMessage chatMessage) async {
    if (_awaitingTransactionConfirmation) {
      _handleTransactionConfirmation(chatMessage);
      return;
    }

    setState(() {
      messages = [chatMessage] + messages;
      showWelcomeScreen = false;
    });
    await _storageService.saveMessage(chatMessage, role: 'user');

    final loadingMessage = ChatMessage(
      user: ChatConstants.geminiUser,
      createdAt: DateTime.now(),
      text: "I am thinking...",
      customProperties: {"isLoading": true},
    );

    setState(() {
      messages = [loadingMessage] + messages;
    });

    final response = await _chatService.sendMessage(chatMessage);
    
    if (TransactionParser.hasTransactionInfo(response)) {
      final transactionData = TransactionParser.extractTransactionFromMessage(response);
      
      if (transactionData != null) {
        _pendingTransaction = transactionData;
        
        final message = ChatMessage(
          user: ChatConstants.geminiUser,
          createdAt: DateTime.now(),
          text: response,
        );
        
        setState(() {
          messages.removeAt(0);
          messages = [message] + messages;
        });
        await _storageService.saveMessage(message, role: 'model');
        
        _awaitingTransactionConfirmation = true;
        return;
      }
    }

    final message = ChatMessage(
      user: ChatConstants.geminiUser,
      createdAt: DateTime.now(),
      text: response,
    );

    setState(() {
      messages.removeAt(0);
      messages = [message] + messages;
    });
    await _storageService.saveMessage(message, role: 'model');
  }

  void _handleTransactionConfirmation(ChatMessage userMessage) async {
    setState(() {
      messages = [userMessage] + messages;
    });
    
    String responseText;
    
    if (TransactionParser.isConfirmingTransaction(userMessage.text)) {
      try {
        final transactionModel = TransactionParser.createTransactionModel(_pendingTransaction!);
        await _transactionService.addTransaction(transactionModel);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Transaction added successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
        responseText = "Transaction added successfully!";
      } catch (e) {
        responseText = "Sorry, I couldn't add the transaction. Please try again later.";
      }
    } else if (TransactionParser.isCancelingTransaction(userMessage.text)) {
      responseText = "No problem, I won't add that transaction.";
    } 
    else {
      responseText = "I'm not sure if you want to add this transaction or not. Please answer with Yes or No.";
      
      final message = ChatMessage(
        user: ChatConstants.geminiUser,
        createdAt: DateTime.now(),
        text: responseText,
      );

      setState(() {
        messages = [message] + messages;
      });
      await _storageService.saveMessage(message, role: 'model');
      
      return;
    }
    
    final message = ChatMessage(
      user: ChatConstants.geminiUser,
      createdAt: DateTime.now(),
      text: responseText,
    );

    setState(() {
      messages = [message] + messages;
    });
    await _storageService.saveMessage(message, role: 'model');
    
    _awaitingTransactionConfirmation = false;
    _pendingTransaction = null;
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

  void _navigateToVoiceChat() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VoiceChatInterface(
          currentUser: ChatConstants.currentUser,
          onSend: _sendMessage,
          messages: messages,
        ),
      ),
    );
  }

  Future<void> clearChat() async {
    await _storageService.clearChat();
    setState(() {
      messages = [];
      conversationHistory = [];
      showWelcomeScreen = true;
      _awaitingTransactionConfirmation = false;
      _pendingTransaction = null;
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
      appBar: AppBar(
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
            icon: const Icon(Icons.delete_outline),
            onPressed: clearChat,
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () => ChatbotHelp.show(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: showWelcomeScreen 
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
          
          //cannot use floatingbutton here (then the floating button in dashboard wont work?)
          Positioned(
            right: 16,
            bottom: 60,
            child: Material(
              elevation: 4.0,
              shape: const CircleBorder(),
              color: AppColors.primary,
              child: InkWell(
                onTap: _navigateToVoiceChat,
                customBorder: const CircleBorder(),
                child: Container(
                  width: 56.0,
                  height: 56.0,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.mic,
                    color: Colors.white,
                    size: 24.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}