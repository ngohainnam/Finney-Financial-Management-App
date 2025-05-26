import 'package:flutter/material.dart';
import '../../../core/storage/storage_manager.dart';
import '../../../core/storage/cloud/models/learning_model.dart';
import 'quiz.dart';
import 'quiz_questions.dart';
import 'quiz_review_page.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:finney/pages/5-learn/string_extension.dart';


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
  String feedbackMessage = '';
  int? highestScore;

  @override
  void initState() {
    super.initState();
    percent = widget.score / widget.total;
    _saveQuizResult();
    _loadHighestScore();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    feedbackMessage = _getFeedback(percent);
  }

  String _getFeedback(double percent) {
    if (percent >= 0.87) {
      return LocaleData.feedbackMessageExcellent.getString(context);
    } else if (percent >= 0.67) {
      return LocaleData.feedbackMessageGood.getString(context);
    } else if (percent >= 0.4) {
      return LocaleData.feedbackMessageNotBad.getString(context);
    } else {
      return LocaleData.feedbackMessageKeepGoing.getString(context);
    }
  }

  Future<void> _saveQuizResult() async {
    try {
      final quizResult = QuizResult(
        id: '',
        score: widget.score,
        totalQuestions: widget.total,
        timestamp: DateTime.now(),
      );
      await StorageManager().learningService.saveQuizResult(quizResult);
    } catch (e) {
      debugPrint('Error saving quiz result: $e');
    }
  }

  Future<void> _loadHighestScore() async {
    try {
      final results = await StorageManager().learningService.getAllQuizResults();
      if (results.isNotEmpty) {
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
        title: Text(LocaleData.quizCompleted.getString(context)),
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
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.blueAccent,
                      ),
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
                "${LocaleData.score.getString(context)}: ${widget.score} / ${widget.total}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${LocaleData.accuracy.getString(context)}: $displayPercent%",
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 12),

              if (highestScore != null)
                Text(
                  "${LocaleData.highScore.getString(context)}: $highestScore",
                  style: TextStyle(
                    fontSize: 16,
                    color: highestScore == widget.score
                        ? Colors.green
                        : Colors.black87,
                    fontWeight: highestScore == widget.score
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),

              const SizedBox(height: 20),

              Text(
                feedbackMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(LocaleData.backToQuiz.getString(context)),
              ),
              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const QuizPage()),
                  );
                },
                child: Text(
                  LocaleData.restartQuiz.getString(context),
                  style: const TextStyle(color: Colors.blueAccent),
                ),
              ),

              const SizedBox(height: 12),

              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizReviewPage(
                        questions: quizQuestions(context),
                        userAnswers: widget.userAnswers,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.visibility),
                label: Text(LocaleData.reviewAnswers.getString(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
