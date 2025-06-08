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
import 'package:finney/shared/widgets/common/settings_notifier.dart';

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
  final ChatCloudService _chatCloudService = StorageManager().chatCloudService;
  final TransactionCloudService _transactionService = StorageManager().transactionService;
  late LlmService _llmService;
  final gemini = Gemini.instance;
  bool showWelcomeScreen = true;
  List<ChatMessage> messages = [];
  List<Content> conversationHistory = [];
  StreamSubscription? _messagesSubscription;
  bool _isAiTyping = false;
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
  
  List<Content> toGeminiContent(List<ChatMessageModel> messages) {
    return messages.map((message) {
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
    _messagesSubscription = _chatCloudService.streamMessages().listen(
      (cloudMessages) {
        if (!mounted) return;
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
        AppSnackBar.showError(
          context,
          message: LocaleData.errorLoadingMessages.getString(context),
        );
      }
    );
  }

  void _sendMessage(ChatMessage chatMessage) async {
    setState(() {
      messages = [chatMessage] + messages;
      showWelcomeScreen = false;
      _isAiTyping = true;
    });
    await saveMessage(chatMessage, role: 'user');
    final response = await _llmService.sendMessage(chatMessage, context);
    if (TransactionParser.hasTransactionInfo(response)) {
      final transactionData = TransactionParser.extractTransactionFromMessage(response);
      if (transactionData != null) {
        final transactionModel = TransactionParser.createTransactionModel(transactionData);
        final message = ChatMessage(
          user: ChatConstants.geminiUser,
          createdAt: DateTime.now(),
          text: response,
        );
        setState(() {
          _isAiTyping = false;
          messages = [message] + messages;
        });
        await saveMessage(message, role: 'model');
        if (mounted) {
          final confirmed = await TransactionPreviewPopup.show(
            context: context, 
            transaction: transactionModel,
            onConfirm: (confirmedTransaction) async {
              try {
                await _transactionService.addTransaction(confirmedTransaction);
                if (mounted) {
                  AppSnackBar.showSuccess(
                    context,
                    message: LocaleData.transactionAddedSuccess.getString(context),
                  );
                }
              } catch (e) {
                if (mounted) {
                  AppSnackBar.showError(
                    context,
                    message: LocaleData.transactionAddError.getString(context),
                  );
                }
              }
            },
          );
          if (confirmed == false) {
            if (mounted) {
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
    await saveMessage(message, role: 'model');
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
    });
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

    return ValueListenableBuilder<String>(
      valueListenable: SettingsNotifier().textSizeNotifier,
      builder: (context, textSize, child) {
        double textScaleFactor;
        switch (textSize) {
          case 'Small':
            textScaleFactor = 0.8;
            break;
          case 'Large':
            textScaleFactor = 1.2;
            break;
          default:
            textScaleFactor = 1.0;
        }

        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScaleFactor),
          ),
          child: Scaffold(
            backgroundColor: AppColors.lightBackground,
            appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          LocaleData.chatbotTitle.getString(context),
          style: const TextStyle(
            color: AppColors.darkBlue,
            fontWeight: FontWeight.bold,
            fontSize: 28,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.darkBlue),
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
          ),
        );
      },
    );
  }
}