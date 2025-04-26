import 'package:hive/hive.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:finney/pages/2-chatbot/models/chat_message_model.dart';

class ChatStorageService {
  late Box<ChatMessageModel> chatBox;

  Future<void> init() async {
    chatBox = await Hive.openBox<ChatMessageModel>('chat_message');
  }

  List<ChatMessage> loadMessages() {
    final savedMessages = chatBox.values.toList().reversed;
    return savedMessages.map((model) => model.toChatMessage()).toList();
  }

  List<Content> loadConversationHistory() {
    final savedMessages = chatBox.values.toList().reversed;
    return savedMessages.map((model) => Content(
      parts: [Part.text(model.text)],
      role: model.role,
    )).toList();
  }

  Future<void> saveMessage(ChatMessage message, {required String role}) async {
    final messageModel = ChatMessageModel.fromChatMessage(message, role: role);
    await chatBox.add(messageModel);
  }

  Future<void> clearChat() async {
    await chatBox.clear();
  }

  void dispose() {
    chatBox.close();
  }
}