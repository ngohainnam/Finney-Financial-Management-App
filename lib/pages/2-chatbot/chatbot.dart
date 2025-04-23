import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/pages/2-chatbot/presentation/chat_interface.dart';
import 'package:finney/pages/2-chatbot/presentation/voicechat_interface.dart';
import 'package:finney/pages/2-chatbot/services/llm_transactionparser.dart';
import 'package:finney/pages/2-chatbot/services/local_storage_service.dart';
import 'package:finney/pages/2-chatbot/services/cloud_storage_service.dart'; // Added cloud storage import
import 'package:finney/pages/2-chatbot/utils/chat_constants.dart'; 
import 'package:finney/pages/3-dashboard/services/transaction_services.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:image_picker/image_picker.dart';
import 'services/chat_service.dart';
import 'presentation/welcome_screen.dart';
import 'utils/chatbot_help.dart';
import 'dart:async'; 

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final ChatStorageService _localStorageService = ChatStorageService();
  final FirebaseChatStorageService _cloudStorageService = FirebaseChatStorageService();
  final TransactionService _transactionService = TransactionService();
  late ChatService _chatService;
  final gemini = Gemini.instance;
  bool showWelcomeScreen = true;
  List<ChatMessage> messages = [];
  List<Content> conversationHistory = [];
  
  // Stream subscription to properly dispose
  StreamSubscription? _messagesSubscription;
  
  // For transaction handling
  bool _awaitingTransactionConfirmation = false;
  Map<String, dynamic>? _pendingTransaction;

  // For AI typing animation
  bool _isAiTyping = false;
  
  // For cloud message loading
  bool _isLoadingMessages = true;

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    await _localStorageService.init();
    _chatService = ChatService(
      gemini: gemini,
      conversationHistory: conversationHistory,
    );
    _loadCloudMessages();
  }

  void _loadCloudMessages() {
    if (!mounted) return;
    
    setState(() {
      _isLoadingMessages = true;
    });
    
    // Store the subscription so we can cancel it later
    _messagesSubscription = _cloudStorageService.getMessages().listen(
      (cloudMessages) {
        if (!mounted) return;
        
        setState(() {
          messages = cloudMessages;
          showWelcomeScreen = messages.isEmpty;
          _isLoadingMessages = false;
        });
        
        // Update conversation history for LLM context
        conversationHistory = _extractConversationHistory(cloudMessages);
        _chatService.updateConversationHistory(conversationHistory);
      }, 
      onError: (error) {
        debugPrint('Error loading cloud messages: $error');
        
        if (!mounted) return;
        
        setState(() {
          _isLoadingMessages = false;
          // Fallback to local if cloud fails
          messages = _localStorageService.loadMessages();
          conversationHistory = _localStorageService.loadConversationHistory();
          showWelcomeScreen = messages.isEmpty;
        });
      }
    );
  }

  // Helper method to convert chat messages to conversation history
  List<Content> _extractConversationHistory(List<ChatMessage> chatMessages) {
    List<Content> history = [];
    
    for (var message in chatMessages.reversed) { // Process from oldest to newest
      String role = message.customProperties?['role'] ?? 
                   (message.user.id == ChatConstants.geminiUser.id ? 'model' : 'user');
      
      history.add(Content(
        role: role,
        parts: [TextPart(message.text)],
      ));
    }
    
    return history;
  }

  void _sendMessage(ChatMessage chatMessage) async {
    if (_awaitingTransactionConfirmation) {
      _handleTransactionConfirmation(chatMessage);
      return;
    }

    setState(() {
      messages = [chatMessage] + messages;
      showWelcomeScreen = false;
      _isAiTyping = true;  // Start the typing animation
    });
    
    // Save to both storage services for redundancy
    await _cloudStorageService.saveMessage(chatMessage, role: 'user');
    await _localStorageService.saveMessage(chatMessage, role: 'user');

    // We'll no longer add the loading message, the animation will show the AI is thinking
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
          _isAiTyping = false;  // Stop the typing animation
          messages = [message] + messages;
        });
        
        // Save to both storage services
        await _cloudStorageService.saveMessage(message, role: 'model');
        await _localStorageService.saveMessage(message, role: 'model');
        
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
      _isAiTyping = false;  // Stop the typing animation
      messages = [message] + messages;
    });
    
    // Save to both storage services
    await _cloudStorageService.saveMessage(message, role: 'model');
    await _localStorageService.saveMessage(message, role: 'model');
  }

  void _handleTransactionConfirmation(ChatMessage userMessage) async {
    setState(() {
      messages = [userMessage] + messages;
      _isAiTyping = true;  // Start typing animation
    });
    
    // Save user confirmation message
    await _cloudStorageService.saveMessage(userMessage, role: 'user');
    await _localStorageService.saveMessage(userMessage, role: 'user');
    
    String responseText;
    
    if (TransactionParser.isConfirmingTransaction(userMessage.text)) {
      try {
        final transactionModel = TransactionParser.createTransactionModel(_pendingTransaction!);
        await _transactionService.addTransaction(transactionModel);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
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
        _isAiTyping = false;  // Stop typing animation
        messages = [message] + messages;
      });
      
      await _cloudStorageService.saveMessage(message, role: 'model');
      await _localStorageService.saveMessage(message, role: 'model');
      
      return;
    }
    
    final message = ChatMessage(
      user: ChatConstants.geminiUser,
      createdAt: DateTime.now(),
      text: responseText,
    );

    setState(() {
      _isAiTyping = false;  // Stop typing animation
      messages = [message] + messages;
    });
    
    await _cloudStorageService.saveMessage(message, role: 'model');
    await _localStorageService.saveMessage(message, role: 'model');
    
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
    await _cloudStorageService.clearChat();
    await _localStorageService.clearChat(); // Also clear local for consistency
    
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
    _messagesSubscription?.cancel();
    _localStorageService.dispose();
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
                child: _isLoadingMessages 
                  ? const Center(child: CircularProgressIndicator())
                  : showWelcomeScreen 
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
                        isAiTyping: _isAiTyping,  // Pass the typing state to ChatInterface
                      ),
              ),
            ],
          ),
          
          Positioned(
            right: 16,
            bottom: 60,
            child: Material(
              elevation: 4.0,
              shape: const CircleBorder(),
              color: AppColors.darkBlue,
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