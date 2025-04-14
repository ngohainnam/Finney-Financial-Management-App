import 'package:flutter/material.dart';

class QuizResultPage extends StatelessWidget {
  final int score;
  final int total;

  const QuizResultPage({
    Key? key,
    required this.score,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percent = (score / total * 100).toStringAsFixed(1);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("Quiz Completed"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Your Score", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text("$score / $total", style: TextStyle(fontSize: 32, color: Colors.blueAccent)),
            const SizedBox(height: 12),
            Text("Accuracy: $percent%", style: TextStyle(fontSize: 18, color: Colors.black54)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to quiz home
              },
              child: const Text("Back to Quiz"),
            ),
          ],
        ),
      ),
    );
  }
}
