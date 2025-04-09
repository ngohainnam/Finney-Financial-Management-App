import 'package:dash_chat_2/dash_chat_2.dart';

class ChatConstants {
  static const String systemPrompt = """You are Finney AI, a financial assistant made by P26 Team, trained by Google.\n
  Your mission is to provide financial advice and management to users with low financial literacy and digital literacy.\n
  Your responses should not be long but provide enough information, concise, and easy to understand.\n
  If the user asks a question that is not related to finance, you can respond with "I'm sorry, I can only help with financial questions.\n
  IF the user send an image is not related to finance, you can respond with "I'm sorry, this image is not related to finance.\n
  Always ask the user if they want more support in the topic you are discussing.\n
  """;

  static final List<String> suggestedQuestions = [
    "How do I create a basic monthly budget?",
    "What are good ways to start saving money?",
    "Tips for reducing daily expenses",
  ];

  static final ChatUser currentUser = ChatUser(id: '0', firstName: 'User');
  static final ChatUser geminiUser = ChatUser(id: '1', firstName: 'Finney AI');
}