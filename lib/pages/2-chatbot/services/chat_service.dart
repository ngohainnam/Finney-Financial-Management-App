import 'dart:io';
import 'package:finney/pages/2-chatbot/services/tts_service.dart';
import 'package:finney/pages/2-chatbot/utils/chat_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

class ChatService {
  final Gemini gemini;
  final List<Content> conversationHistory;

  ChatService({
    required this.gemini,
    required this.conversationHistory,
  });

  Future<String> sendMessage(ChatMessage chatMessage) async {
    String augmentedQuestion = "${ChatConstants.systemPrompt}\n\nUser Question: ${chatMessage.text}";
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
      
      await TtsService().speak(response);
      
      conversationHistory.add(Content(
        parts: [Part.text(response)],
        role: 'model',
      ));

      return response;
    } catch (e) {
      return 'An error occurred. Please try again after 1 minute.';
    }
  }
}