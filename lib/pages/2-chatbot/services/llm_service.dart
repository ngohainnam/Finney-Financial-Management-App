import 'dart:io';
import 'package:finney/pages/2-chatbot/services/llm_rag.dart';
import 'package:finney/pages/2-chatbot/services/tts_service.dart';
import 'package:finney/pages/2-chatbot/utils/chat_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';

class LlmService {
  final Gemini gemini;
  List<Content> conversationHistory;
  final TransactionRAGService _transactionRAGService = TransactionRAGService();

  LlmService({
    required this.gemini,
    required this.conversationHistory,
  });

  void updateConversationHistory(List<Content> newHistory) {
    conversationHistory = newHistory;
  }

  Future<String> sendMessage(ChatMessage chatMessage, BuildContext context) async {
    bool needsTransactionContext = _messageNeedsTransactionContext(chatMessage.text);
    String transactionContext = '';

    if (needsTransactionContext) {
      transactionContext = await _transactionRAGService.getTransactionContext();
    }

    String augmentedQuestion;

    if (needsTransactionContext) {
      augmentedQuestion = """${ChatConstants.systemPrompt}

User's Transaction Data Context:
$transactionContext

User Question: ${chatMessage.text}""";
    } else {
      augmentedQuestion = "${ChatConstants.systemPrompt}\n\nUser Question: ${chatMessage.text}";
    }

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

    try {
      final value = await gemini.chat(conversationHistory);
      String response = value?.output ?? 'Something went wrong. Please try again later...';

      bool isFromVoiceInput = chatMessage.customProperties?['fromVoiceInput'] == true;
      if (isFromVoiceInput) {
        final isBengali = Localizations.localeOf(context).languageCode == 'bn';
        await TtsService().setLanguage(isBengali ? "bn-BD" : "en-US");
        await TtsService().speak(response);
      }

      conversationHistory.add(Content(
        parts: [Part.text(response)],
        role: 'model',
      ));

      return response;
    } catch (e) {
      return 'An error occurred. Please try again after 1 minute.';
    }
  }

  bool _messageNeedsTransactionContext(String message) {
    final List<String> transactionKeywords = [
      'transaction', 'spent', 'spend', 'spending', 'income', 'expense', 'expenses',
      'how much', 'balance', 'budget', 'category', 'money', 'financial', 'summary',
      'report', 'analytics', 'analysis', 'history', 'account', 'payment', 'purchase',
      'bought', 'paid', 'finance', 'statistics', 'total', 'spend'
    ];

    message = message.toLowerCase();

    return transactionKeywords.any((keyword) => message.contains(keyword));
  }
}