import 'package:flutter/material.dart';
import 'package:finney/pages/2-chatbot/chatbot_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finney Home'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Financial Literacy Chatbot"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatbotPage()),
              );
            },
          ),
          // Add more sections here if needed
        ],
      ),
    );
  }
}
