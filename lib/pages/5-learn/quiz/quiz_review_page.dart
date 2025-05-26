import 'package:flutter/material.dart';
import 'quiz_questions.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:finney/pages/5-learn/string_extension.dart';

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
        title: Text(LocaleData.reviewAnswers.getString(context)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32), // bottom padding
        itemCount: userAnswers.length,
        itemBuilder: (context, index) {
          final question = questions[index];
          final selected = index < userAnswers.length ? userAnswers[index] : null;
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
