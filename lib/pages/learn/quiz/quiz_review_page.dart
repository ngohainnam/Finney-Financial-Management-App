import 'package:flutter/material.dart';
import 'quiz_questions.dart';

class QuizReviewPage extends StatelessWidget {
  final List<QuizQuestion> questions;
  final List<int?> userAnswers;

  const QuizReviewPage({
    super.key,
    required this.questions,
    required this.userAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("Review Answers"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: questions.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final question = questions[index];
          final selected = userAnswers[index];
          final correct = question.correctAnswerIndex;

          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 6),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Q${index + 1}: ${question.question}",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                ...List.generate(question.options.length, (optIndex) {
                  Color bgColor = Colors.white;
                  if (optIndex == correct) {
                    bgColor = Colors.green.shade100;
                  }
                  if (selected != correct && optIndex == selected) {
                    bgColor = Colors.red.shade100;
                  }

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      question.options[optIndex],
                      style: const TextStyle(fontSize: 15),
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
