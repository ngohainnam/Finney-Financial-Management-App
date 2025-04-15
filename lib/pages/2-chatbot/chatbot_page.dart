import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:finney/helpers/voice_helper.dart';

class ChatbotPage extends StatefulWidget {
  const ChatbotPage({super.key});

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  String _response = '';
  bool _isLoading = false;

  void askGemini(String question) async {
    setState(() => _isLoading = true);

    final gemini = Gemini.instance;
    final prompt = "Please reply in Bengali:\n$question";
    final result = await gemini.text(prompt);
    final responseText = result?.output ?? "No response found.";

    setState(() {
      _response = responseText;
      _isLoading = false;
    });

    VoiceHelper.speak(responseText);
  }


  @override
  void dispose() {
    VoiceHelper.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Finney AI Chatbot")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Ask about financial literacy...',
                border: OutlineInputBorder(),
              ),
              onSubmitted: askGemini,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => askGemini(_controller.text),
              child: const Text("Ask"),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : Text(_response),
          ],
        ),
      ),
    );
  }
}
