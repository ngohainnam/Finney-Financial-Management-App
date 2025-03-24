import 'dart:io';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final gemini = Gemini.instance;
  final String _systemPrompt = """You are Finney AI, a financial assistant made by P26 Team, trained by Google.\n
  Your mission is to provide financial advice and management to users with low financial literacy and digital literacy.\n
  Your responses should be not too long but provide enough information, concise, and easy to understand.\n
  If the user asks a question that is not related to finance, you can respond with "I'm sorry, I can only help with financial questions.\n
  If the user sends a picture, if it is finance related, describe the picture.\n
  Always ask the user if they want more support in the topic you are discussing.\n
  """;

  final TextEditingController inputController = TextEditingController();
  List<ChatMessage> messages = [];

  ChatUser currentUser = ChatUser(id: '0', firstName: 'User');
  ChatUser geminiUser = ChatUser(id: '1', firstName: 'Finney AI');

  final List<String> sampleQuestions = [
    "How does this work?",
    "What is the best approach?",
    "How can I use this feature?",
  ];

  bool isProcessing = false; // Flag to check if response is being processed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Visualize"),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelpDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Logo
            Center(child: Image.asset('lib/images/app_logo.png', height: 180)),
            const SizedBox(height: 20),

            // Suggested Questions
            Align(
              alignment: Alignment.centerLeft, // Align to the left
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,  // Ensure the items inside the column are left-aligned
                children: [
                  const Text(
                    "Suggested Questions:",  // Title aligned to the left
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  // Map through the questions and display them
                  ...sampleQuestions.map((question) {
                    return GestureDetector(
                      onTap: () => _sendMessage(question),  // On tap, send the question
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          question,
                          style: const TextStyle(fontSize: 16, color: Colors.blueAccent),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Expanded(child: _buildChat()),

            // Custom input section instead of DashChat's input toolbar
            _buildInputSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildChat() {
    return DashChat(
      currentUser: currentUser,
      messages: messages,
      onSend: (ChatMessage chatMessage) => isProcessing ? null : _sendMessage(chatMessage.text), // Prevent sending while processing
      inputOptions: const InputOptions(inputDisabled: true), // Disables DashChat's input field
      readOnly: true, // Disable DashChat's default input field completely
    );
  }

  Widget _buildInputSection() {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.image),
          onPressed: isProcessing ? null : _sendMediaMessage, // Disable if processing
        ),
        IconButton(
          icon: const Icon(Icons.mic),
          onPressed: isProcessing ? null : () {}, // Disable if processing
        ),
        Expanded(
          child: TextField(
            controller: inputController,
            decoration: InputDecoration(
              hintText: "Ask a question...",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onSubmitted: isProcessing ? null : (text) => _sendMessage(text), // Disable on submit if processing
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: isProcessing ? null : () => _sendMessage(inputController.text), // Disable send button if processing
        ),
      ],
    );
  }

  void _sendMessage(String text) {
  if (isProcessing) return; // Prevent sending if already processing

  final chatMessage = ChatMessage(
    user: currentUser,
    createdAt: DateTime.now(),
    text: text,
  );

  setState(() {
    messages = [chatMessage] + messages;
    isProcessing = true; // Mark processing as true while waiting for the response
    inputController.clear(); // Clear the input field after sending the message
  });

  try {
    String augmentedQuestion = "$_systemPrompt\n\nUser Question: $text";

    // Prepare the content parts based on whether there's media or not
    List<Part> parts = [];

    // Add image part if media is present
    if (chatMessage.medias?.isNotEmpty ?? false) {
      Uint8List images = File(chatMessage.medias!.first.url).readAsBytesSync();
      parts.add(Part.uint8List(images));
    } else {
      parts.add(Part.text(augmentedQuestion));
    }

    // Prepare the content for the chat
    List<Content> conversation = [
      Content(
        parts: parts,
        role: 'user',
      ),
    ];

    // Call the Gemini chat method to handle multi-turn conversation
    gemini.chat(conversation).then((value) {
      String response;
      if (value != null && value.output != null) {
        response = value.output!;
      } else {
        response = 'Something went wrong with the model. Please try again later...';
      }

      // Create a new ChatMessage with the response
      ChatMessage message = ChatMessage(
        user: geminiUser,
        createdAt: DateTime.now(),
        text: response,
      );

      // Add the new message to the conversation
      setState(() {
        messages = [message] + messages;
        isProcessing = false; // Mark processing as false once response is received
      });
    }).catchError((e) {
      // Handle errors related to the Gemini chat method
      setState(() {
        messages = [
          ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: 'An error occurred while contacting Gemini: $e',
          )
        ] + messages;
        isProcessing = false; // Mark processing as false on error
      });
    });
  } catch (e) {
    // Catch any unexpected errors
    setState(() {
      messages = [
        ChatMessage(
          user: geminiUser,
          createdAt: DateTime.now(),
          text: 'An unexpected error occurred: $e',
        )
      ] + messages;
      isProcessing = false; // Mark processing as false on unexpected error
    });
  }
}


  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Help"),
          content: const Text("This is your chatbot, ask questions related to finance and get advice."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _sendMediaMessage() {
    // Media message functionality
  }
}
