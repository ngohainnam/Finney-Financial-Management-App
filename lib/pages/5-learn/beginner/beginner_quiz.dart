import 'package:flutter/material.dart';
import 'package:finney/assets/theme/app_color.dart';

class BeginnerQuiz extends StatefulWidget {
  const BeginnerQuiz({super.key});

  @override
  State<BeginnerQuiz> createState() => _BeginnerQuizState();
}

class _BeginnerQuizState extends State<BeginnerQuiz> {
  int _currentQuestionIndex = 0;
  int _score = 0;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is the first step in managing money?',
      'answers': [
        {'text': 'Spend everything you earn', 'correct': false},
        {'text': 'Track your income and expenses', 'correct': true},
        {'text': 'Invest in stocks', 'correct': false},
      ],
    },
    {
      'question': 'Which is a "need" rather than a "want"?',
      'answers': [
        {'text': 'New smartphone', 'correct': false},
        {'text': 'Groceries', 'correct': true},
        {'text': 'Vacation', 'correct': false},
      ],
    },
    {
      'question': 'How much should you ideally save from your income?',
      'answers': [
        {'text': '5%', 'correct': false},
        {'text': '20%', 'correct': true},
        {'text': '50%', 'correct': false},
      ],
    },
  ];

  void _answerQuestion(bool isCorrect) {
    if (isCorrect) {
      setState(() {
        _score++;
      });
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Quiz Completed!'),
            content: Text('Your score: $_score/${_questions.length}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: const Text('Finish'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beginner Quiz'),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFFF7F6FA),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              minHeight: 8,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
            ),
            const SizedBox(height: 16),
            Text(
              'Question ${_currentQuestionIndex + 1}/${_questions.length}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              _questions[_currentQuestionIndex]['question'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ...(_questions[_currentQuestionIndex]['answers']
                    as List<Map<String, dynamic>>)
                .map(
                  (answer) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ElevatedButton(
                      onPressed: () => _answerQuestion(answer['correct']),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 1,
                      ),
                      child: Text(answer['text']),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
