import 'package:finney/shared/theme/app_color.dart';
import 'package:finney/core/storage/cloud/models/chat_message_model.dart';
import 'package:finney/core/storage/cloud/service/chat_cloud_service.dart';
import 'package:finney/core/storage/cloud/service/transaction_cloud_service.dart';
import 'package:finney/pages/2-chatbot/presentation/chat_interface.dart';
import 'package:finney/pages/2-chatbot/presentation/transaction_preview.dart';
import 'package:finney/pages/2-chatbot/presentation/voicechat_interface.dart';
import 'package:finney/pages/2-chatbot/services/llm_transactionparser.dart';
import 'package:finney/pages/2-chatbot/utils/chat_constants.dart'; 
import 'package:finney/core/storage/storage_manager.dart';
import 'package:finney/shared/widgets/common/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:image_picker/image_picker.dart';
import 'services/llm_service.dart';
import 'presentation/welcome_screen.dart';
import 'dart:async';
import 'package:finney/shared/localization/locales.dart';
import 'package:flutter_localization/flutter_localization.dart';
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
  // Use core services from StorageManager
  final ChatCloudService _chatCloudService = StorageManager().chatCloudService;
  final TransactionCloudService _transactionService = StorageManager().transactionService;
  late LlmService _llmService;
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

  // ADD THESE ADAPTER METHODS TO HANDLE TYPE CONVERSIONS

  // Adapter method to save a message
  Future<void> saveMessage(ChatMessage message, {required String role}) async {
    final chatModel = ChatMessageModel(
      text: message.text,
      createdAt: message.createdAt,
      userId: message.user.id,
      userFirstName: message.user.firstName ?? '',
      role: role,
      mediaUrl: message.medias?.isNotEmpty == true ? message.medias!.first.url : null,
    );
    
    await _chatCloudService.addMessage(chatModel);
  }
  
  // Adapter method to convert ChatMessageModel to List<Content> for Gemini
  List<Content> toGeminiContent(List<ChatMessageModel> messages) {
    return messages.map((message) {
      // Convert each message to Gemini Content format
      return Content(
        role: message.role,
        parts: [TextPart(message.text)],
      );
    }).toList();
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
    _llmService = LlmService(
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
    _messagesSubscription = _chatCloudService.streamMessages().listen(
      (cloudMessages) {
        if (!mounted) return;
        
        // Convert CloudMessages to ChatMessages
        final convertedMessages = cloudMessages.map((cloudMsg) {
          return ChatMessage(
            text: cloudMsg.text,
            user: ChatUser(
              id: cloudMsg.userId,
              firstName: cloudMsg.userFirstName,
            ),
            createdAt: cloudMsg.createdAt,
            medias: cloudMsg.mediaUrl != null 
              ? [ChatMedia(url: cloudMsg.mediaUrl!, fileName: '', type: MediaType.image)]
              : null,
            customProperties: {'role': cloudMsg.role},
          );
        }).toList();
        
        setState(() {
          messages = convertedMessages;
          showWelcomeScreen = messages.isEmpty;
          _isLoadingMessages = false;
        });
        
        // Update conversation history for LLM context
        conversationHistory = toGeminiContent(cloudMessages);
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
        
        // Show error using AppSnackBar
        AppSnackBar.showError(
          context,
          message: LocaleData.errorLoadingMessages.getString(context),
        );
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
    await saveMessage(chatMessage, role: 'user');

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
        await saveMessage(message, role: 'model');
        
        // Show the transaction preview dialog with simplified interface (no edit)
        if (mounted) {
          final confirmed = await TransactionPreviewPopup.show(
            context: context, 
            transaction: transactionModel,
            onConfirm: (confirmedTransaction) async {
              try {
                // Handle confirmation - save the transaction using core service
                await _transactionService.addTransaction(confirmedTransaction);
                
                if (mounted) {
                  // Show success message using AppSnackBar
                  AppSnackBar.showSuccess(
                    context,
                    message: LocaleData.transactionAddedSuccess.getString(context),
                  );
                }
              } catch (e) {
                // Show error using AppSnackBar if transaction fails
                if (mounted) {
                  AppSnackBar.showError(
                    context,
                    message: LocaleData.transactionAddError.getString(context),
                  );
                }
              }
            },
          );
          
          // Handle cancellation
          if (confirmed == false) {
            if (mounted) {
            // Show success message using AppSnackBar
            AppSnackBar.showInfo(
              context,
              message: LocaleData.transactionCanceled.getString(context),
              );
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
    await saveMessage(message, role: 'model');
  }

  void _handleTransactionConfirmation(ChatMessage userMessage) async {
    setState(() {
      messages = [userMessage] + messages;
      _isAiTyping = true;  // Start typing animation
    });
    
    // Save user confirmation message
    await saveMessage(userMessage, role: 'user');
    
    
    if (_pendingTransaction != null) {
      final transactionModel = TransactionParser.createTransactionModel(_pendingTransaction!);
      
      if (TransactionParser.isConfirmingTransaction(userMessage.text)) {
        try {
          await _transactionService.addTransaction(transactionModel);

          if (mounted) {
            // Use AppSnackBar for success messages
            AppSnackBar.showSuccess(
              context,
              message: LocaleData.transactionAddedSuccess.getString(context),
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
          
          await saveMessage(message, role: 'model');
          
        } catch (e) {
          // Use AppSnackBar for error messages
          if (mounted) {
            AppSnackBar.showError(
              context,
              message: LocaleData.transactionAddError.getString(context),
            );
          }
          
          final message = ChatMessage(
            user: ChatConstants.geminiUser,
            createdAt: DateTime.now(),
            text: LocaleData.transactionAddError.getString(context),
          );
          
          setState(() {
            _isAiTyping = false;
            messages = [message] + messages;
          });
          
          await saveMessage(message, role: 'model');
        }
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
        
        await saveMessage(message, role: 'model');
        
        // Show the popup
        if (mounted) {
          await TransactionPreviewPopup.show(
            context: context,
            transaction: transactionModel,
            onConfirm: (confirmedTransaction) async {
              try {
                await _transactionService.addTransaction(confirmedTransaction);
                
                if (mounted) {
                  // Use AppSnackBar for success messages
                  AppSnackBar.showSuccess(
                    context,
                    message: LocaleData.transactionAddedSuccess.getString(context),
                  );
                  
                  final confirmMessage = ChatMessage(
                    user: ChatConstants.geminiUser,
                    createdAt: DateTime.now(),
                    text: LocaleData.transactionAddedSuccess.getString(context),
                  );
                  
                  setState(() {
                    messages = [confirmMessage] + messages;
                  });
                  
                  await saveMessage(confirmMessage, role: 'model');
                }
              } catch (e) {
                // Use AppSnackBar for error messages
                if (mounted) {
                  AppSnackBar.showError(
                    context,
                    message: LocaleData.transactionAddError.getString(context),
                  );
                }
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
      
      await saveMessage(message, role: 'model');
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
    await _chatCloudService.clearChat();
    
    setState(() {
      messages = [];
      conversationHistory = [];
      showWelcomeScreen = true;
      _awaitingTransactionConfirmation = false;
      _pendingTransaction = null;
    });
    
    // Show confirmation using AppSnackBar
    if (mounted) {
      AppSnackBar.showInfo(
        context,
        message: LocaleData.chatCleared.getString(context),
      );
    }
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
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: clearChat,
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
            right: 17,
            bottom: 80,
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(16),
              color: AppColors.darkBlue,
              child: InkWell(
                onTap: _navigateToVoiceChat,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 56.0,
                  height: 56.0,
                  alignment: Alignment.center,
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