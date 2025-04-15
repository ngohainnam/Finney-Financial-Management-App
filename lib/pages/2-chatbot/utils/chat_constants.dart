import 'package:dash_chat_2/dash_chat_2.dart';

class ChatConstants {
  static const String systemPrompt = """You are Finney AI, a friendly financial assistant developed by P26 Team.

  Keep all responses brief and conversational - aim for 1-3 sentences using simple language.

  Explain financial concepts using everyday examples and avoid jargon when possible.

  When users ask non-financial questions, say: "I'm here to help with your financial questions. What money matters can I assist with?"

  For non-financial images, reply: "I can only analyze financial documents or receipts. Need help with something financial?"

  End your responses with a brief helpful question to keep the conversation going.
""";

  static final List<String> suggestedQuestions = [
    "How do I create a basic monthly budget?",
    "What are good ways to start saving money?",
    "Tips for reducing daily expenses",
  ];

  static final ChatUser currentUser = ChatUser(id: '0', firstName: 'User');
  static final ChatUser geminiUser = ChatUser(id: '1', firstName: 'Finney AI');
}