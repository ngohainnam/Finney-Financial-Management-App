import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/pages/chatbot/presentation/chat_interface.dart';
import 'package:finney/pages/chatbot/presentation/transaction_preview.dart';
import 'package:finney/pages/chatbot/presentation/voicechat_interface.dart';
import 'package:finney/pages/chatbot/services/llm_transactionparser.dart';
import 'package:finney/pages/chatbot/utils/chat_constants.dart'; 
import 'package:finney/pages/dashboard/transaction/transaction_services.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:image_picker/image_picker.dart';
import 'services/llm_service.dart' as llm;
import 'presentation/welcome_screen.dart';
import 'utils/chatbot_help.dart';
import 'dart:async';
import 'package:finney/assets/localization/locales.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/core/storage/storage_manager.dart';
import 'package:finney/core/service/chat_service.dart'; // Import without namespace

class Chatbot extends StatefulWidget {
  final String? initialQuestion;
  
  const Chatbot({
    super.key, 
    this.initialQuestion,
  });

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  // Use core service for storage directly (no namespace)
  final ChatService _storageService = StorageManager().chatService;
  final TransactionService _transactionService = TransactionService();
  late llm.ChatService _llmService;
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

    if (widget.initialQuestion != null && widget.initialQuestion!.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _handleInitialQuestion(widget.initialQuestion!);
      });
    }
  }

  void _handleInitialQuestion(String question) {
    final chatMessage = ChatMessage(
      user: ChatConstants.currentUser,
      createdAt: DateTime.now(),
      text: question,
    );
    _sendMessage(chatMessage);
    setState(() {
      showWelcomeScreen = false;
    });
  }

  Future<void> _initServices() async {
    _llmService = llm.ChatService(
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
    _messagesSubscription = _storageService.streamMessages().listen(
      (cloudMessages) {
        if (!mounted) return;
        
        setState(() {
          messages = cloudMessages;
          showWelcomeScreen = messages.isEmpty;
          _isLoadingMessages = false;
        });
        
        // Update conversation history for LLM context
        conversationHistory = _storageService.toGeminiContent(cloudMessages);
        _llmService.updateConversationHistory(conversationHistory);
      }, 
      onError: (error) {
        debugPrint('Error loading cloud messages: $error');
        
        if (!mounted) return;
        
        setState(() {
          _isLoadingMessages = false;
          messages = [];
          showWelcomeScreen = true;
        });
      }
    );
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
    
    // Save to cloud storage service
    await _storageService.saveMessage(chatMessage, role: 'user');

    // The animation will show the AI is thinking
    final response = await _llmService.sendMessage(chatMessage);
    
    if (TransactionParser.hasTransactionInfo(response)) {
      final transactionData = TransactionParser.extractTransactionFromMessage(response);
      
      if (transactionData != null) {
        // Create transaction model for preview
        final transactionModel = TransactionParser.createTransactionModel(transactionData);
        
        final message = ChatMessage(
          user: ChatConstants.geminiUser,
          createdAt: DateTime.now(),
          text: response,
        );
        
        setState(() {
          _isAiTyping = false;  // Stop the typing animation
          messages = [message] + messages;
        });
        
        // Save to cloud storage service
        await _storageService.saveMessage(message, role: 'model');
        
        // Show the transaction preview dialog with simplified interface (no edit)
        if (mounted) {
          final confirmed = await TransactionPreviewPopup.show(
            context: context, 
            transaction: transactionModel,
            onConfirm: (confirmedTransaction) async {
              // Handle confirmation - save the transaction
              await _transactionService.addTransaction(confirmedTransaction);
              
              if (mounted) {
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(LocaleData.transactionAddedSuccess.getString(context)),
                    backgroundColor: Colors.green,
                  ),
                );
                
                // Add confirmation message to chat
                final confirmMessage = ChatMessage(
                  user: ChatConstants.geminiUser,
                  createdAt: DateTime.now(),
                  text: LocaleData.transactionAddedSuccess.getString(context),
                );
                
                setState(() {
                  messages = [confirmMessage] + messages;
                });
                
                await _storageService.saveMessage(confirmMessage, role: 'model');
              }
            },
          );
          
          // Handle cancellation
          if (confirmed == false) {
            if (mounted) {
              // Add a cancellation message from the bot
              final cancelMessage = ChatMessage(
                user: ChatConstants.geminiUser,
                createdAt: DateTime.now(),
                text: LocaleData.transactionCanceled.getString(context),
              );
              
              setState(() {
                messages = [cancelMessage] + messages;
              });
              
              await _storageService.saveMessage(cancelMessage, role: 'model');
            }
          }
        }
        
        return;
      }
    }

    final message = ChatMessage(
      user: ChatConstants.geminiUser,
      createdAt: DateTime.now(),
      text: response,
    );

    setState(() {
      _isAiTyping = false; 
      messages = [message] + messages;
    });
    
    // Save to cloud storage service
    await _storageService.saveMessage(message, role: 'model');
  }

  void _handleTransactionConfirmation(ChatMessage userMessage) async {
    setState(() {
      messages = [userMessage] + messages;
      _isAiTyping = true;  // Start typing animation
    });
    
    // Save user confirmation message
    await _storageService.saveMessage(userMessage, role: 'user');
    
    
    if (_pendingTransaction != null) {
      final transactionModel = TransactionParser.createTransactionModel(_pendingTransaction!);
      
      if (TransactionParser.isConfirmingTransaction(userMessage.text)) {
        try {
          await _transactionService.addTransaction(transactionModel);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(LocaleData.transactionAddedSuccess.getString(context)),
                backgroundColor: Colors.green,
              ),
            );
          }
          
          final message = ChatMessage(
            user: ChatConstants.geminiUser,
            createdAt: DateTime.now(),
            text: LocaleData.transactionAddedSuccess.getString(context),
          );
          
          setState(() {
            _isAiTyping = false;
            messages = [message] + messages;
          });
          
          await _storageService.saveMessage(message, role: 'model');
          
        } catch (e) {
          final message = ChatMessage(
            user: ChatConstants.geminiUser,
            createdAt: DateTime.now(),
            text: LocaleData.transactionAddError.getString(context),
          );
          
          setState(() {
            _isAiTyping = false;
            messages = [message] + messages;
          });
          
          await _storageService.saveMessage(message, role: 'model');
        }
      } else if (TransactionParser.isCancelingTransaction(userMessage.text)) {
        final message = ChatMessage(
          user: ChatConstants.geminiUser,
          createdAt: DateTime.now(),
          text: LocaleData.transactionCanceled.getString(context),
        );
        
        setState(() {
          _isAiTyping = false;
          messages = [message] + messages;
        });
        
        await _storageService.saveMessage(message, role: 'model');
      } else {
        // If the user's response wasn't clear, show the popup
        final message = ChatMessage(
          user: ChatConstants.geminiUser,
          createdAt: DateTime.now(),
          text: LocaleData.transactionConfirmPrompt.getString(context),
        );
        
        setState(() {
          _isAiTyping = false;
          messages = [message] + messages;
        });
        
        await _storageService.saveMessage(message, role: 'model');
        
        // Show the popup
        if (mounted) {
          await TransactionPreviewPopup.show(
            context: context,
            transaction: transactionModel,
            onConfirm: (confirmedTransaction) async {
              await _transactionService.addTransaction(confirmedTransaction);
              
              if (mounted) {
                final confirmMessage = ChatMessage(
                  user: ChatConstants.geminiUser,
                  createdAt: DateTime.now(),
                  text: LocaleData.transactionAddedSuccess.getString(context),
                );
                
                setState(() {
                  messages = [confirmMessage] + messages;
                });
                
                await _storageService.saveMessage(confirmMessage, role: 'model');
              }
            },
          );
        }
      }
    } else {
      // If somehow _pendingTransaction is null
      final message = ChatMessage(
        user: ChatConstants.geminiUser,
        createdAt: DateTime.now(),
        text: LocaleData.transactionNoPending.getString(context),
      );
      
      setState(() {
        _isAiTyping = false;
        messages = [message] + messages;
      });
      
      await _storageService.saveMessage(message, role: 'model');
    }
    
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
    _messagesSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final suggestedQuestions = ChatConstants.getSuggestedQuestions(context);

    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          LocaleData.chatbotTitle.getString(context),
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
                            suggestedQuestions: suggestedQuestions,
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
                            isAiTyping: _isAiTyping,
                          ),
              ),
            ],
          ),
          
          Positioned(
            right: 16,
            bottom: 80,
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