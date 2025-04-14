import 'package:flutter/material.dart';
import 'quiz_questions.dart';
import 'quiz_result_model.dart';
import 'quiz_results_page.dart';
import 'package:hive/hive.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedIndex;
  bool _answered = false;

  void _handleAnswer(int index) {
    if (_answered) return;
    setState(() {
      _selectedIndex = index;
      _answered = true;
      if (index == quizQuestions[_currentIndex].correctAnswerIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (!_answered) return;

    if (_currentIndex + 1 < quizQuestions.length) {
      setState(() {
        _currentIndex++;
        _selectedIndex = null;
        _answered = false;
      });
    } else {
      _saveResult();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const QuizResultsPage()),
      );
    }
  }

  void _saveResult() async {
    final box = await Hive.openBox<QuizResult>('quiz_results');
    final result = QuizResult(
      score: _score,
      totalQuestions: quizQuestions.length,
      timestamp: DateTime.now(),
    );
    box.add(result);
  }

  @override
  Widget build(BuildContext context) {
    final question = quizQuestions[_currentIndex];
    double progress = (_currentIndex + 1) / quizQuestions.length;

    return Scaffold(
      backgroundColor: const Color(0xFFE1EBF5), // Soft pastel blue
      body: SafeArea(
        child: Column(
          children: [
            // Top controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD6E9FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Smart Spending",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),

            // Progress bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white54,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              ),
            ),

            const SizedBox(height: 8),
            Text(
              "Question ${_currentIndex + 1}/${quizQuestions.length}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 24),

            // Card with question + options
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Question capsule
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5F0FB),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          question.question,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Options
                      ...List.generate(question.options.length, (index) {
                        final isCorrect = index == question.correctAnswerIndex;
                        final isSelected = index == _selectedIndex;

                        Color bgColor = Colors.white;
                        if (_answered) {
                          if (isSelected && isCorrect) {
                            bgColor = Colors.green[100]!;
                          } else if (isSelected && !isCorrect) {
                            bgColor = Colors.red[100]!;
                          }
                        }

                        return GestureDetector(
                          onTap: () => _handleAnswer(index),
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1.4,
                              ),
                            ),
                            child: Text(
                              question.options[index],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: _answered ? _nextQuestion : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          _currentIndex + 1 == quizQuestions.length ? "Finish" : "Next",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
