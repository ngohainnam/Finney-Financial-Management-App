import 'package:flutter/material.dart';
import '../../../core/storage/storage_manager.dart';
import '../../../core/storage/cloud/models/learning_model.dart';
import 'quiz.dart';
import 'quiz_questions.dart';
import 'quiz_review_page.dart';

class QuizResultPage extends StatefulWidget {
  final int score;
  final int total;
  final List<int?> userAnswers;

  const QuizResultPage({
    super.key,
    required this.score,
    required this.total,
    required this.userAnswers,
  });

  @override
  State<QuizResultPage> createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  late double percent;
  late String feedbackMessage;
  int? highestScore;

  @override
  void initState() {
    super.initState();
    percent = widget.score / widget.total;
    feedbackMessage = _getFeedback(percent);
    _saveQuizResult();
    _loadHighestScore();
  }

  String _getFeedback(double percent) {
    if (percent >= 0.87) {
      return "🎉 Excellent! You're a money master!";
    } else if (percent >= 0.67) {
      return "👍 Great job! You're on the right path.";
    } else if (percent >= 0.4) {
      return "🧠 Not bad! A little more learning will go a long way.";
    } else {
      return "📘 Keep going! Review the Learn section and try again.";
    }
  }

  Future<void> _saveQuizResult() async {
    try {
      // Create a new quiz result
      final quizResult = QuizResult(
        id: '', 
        score: widget.score,
        totalQuestions: widget.total,
        timestamp: DateTime.now(),
      );

      // Save to Firebase
      await StorageManager().learningService.saveQuizResult(quizResult);
    } catch (e) {
      debugPrint('Error saving quiz result: $e');
    }
  }

  Future<void> _loadHighestScore() async {
    try {
      // Get all quiz results from Firebase
      final results = await StorageManager().learningService.getAllQuizResults();
      
      if (results.isNotEmpty) {
        // Find the highest score
        final highest = results.fold<int>(0, (prev, result) => 
          result.score > prev ? result.score : prev);
        
        setState(() {
          highestScore = highest;
        });
      }
    } catch (e) {
      debugPrint('Error loading highest score: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayPercent = (percent * 100).toStringAsFixed(1);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("Quiz Completed"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circular Progress
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: percent,
                      strokeWidth: 12,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                    ),
                  ),
                  Text(
                    "${(percent * 100).toInt()}%",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Text(
                "Score: ${widget.score} / ${widget.total}",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                "Accuracy: $displayPercent%",
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 12),

              // Highest Score Badge
              if (highestScore != null)
                Text(
                  "🏅 Highest Score: $highestScore",
                  style: TextStyle(
                    fontSize: 16,
                    color: highestScore == widget.score ? Colors.green : Colors.black87,
                    fontWeight: highestScore == widget.score ? FontWeight.bold : FontWeight.normal,
                  ),
                ),

              const SizedBox(height: 20),

              // Feedback Message
              Text(
                feedbackMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Go back
                },
                child: const Text("Back to Quiz"),
              ),
              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const QuizPage()),
                  );
                },
                child: const Text(
                  "Restart Quiz",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),

              const SizedBox(height: 12),

              // Review Answers Button
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizReviewPage(
                        questions: quizQuestions,
                        userAnswers: widget.userAnswers,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.visibility),
                label: const Text("Review Your Answers"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}