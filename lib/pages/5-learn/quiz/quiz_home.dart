import 'package:flutter/material.dart';
import 'package:finney/pages/5-learn/beginner/beginner_quiz.dart';
import 'package:finney/pages/5-learn/intermediate/intermediate_quiz.dart';
import 'package:finney/pages/5-learn/advanced/advanced_quiz.dart';

class QuizHomeScreen extends StatelessWidget {
  const QuizHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Financial Knowledge Quiz')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildQuizOption(
              context,
              level: 'Beginner',
              color: Colors.green,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BeginnerQuiz(),
                    ),
                  ), // Navigate to beginner quiz
            ),
            _buildQuizOption(
              context,
              level: 'Intermediate',
              color: Colors.blue,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IntermediateQuiz(),
                    ),
                  ), // Navigate to intermediate quiz
            ),
            _buildQuizOption(
              context,
              level: 'Advanced',
              color: Colors.purple,
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdvancedQuiz(),
                    ),
                  ), // Navigate to advanced quiz
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizOption(
    BuildContext context, {
    required String level,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 2),
        ),
        child: Center(
          child: Text(
            '$level Level Quiz',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
