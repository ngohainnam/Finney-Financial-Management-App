import 'package:flutter/material.dart';

class IntermediateQuiz extends StatefulWidget {
  const IntermediateQuiz({super.key});

  @override
  State<IntermediateQuiz> createState() => _IntermediateQuizState();
}

class _IntermediateQuizState extends State<IntermediateQuiz> {
  int _currentQuestionIndex = 0;
  int _score = 0;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is the purpose of an emergency fund?',
      'answers': [
        {'text': 'To pay for vacations', 'correct': false},
        {'text': 'To cover unexpected expenses', 'correct': true},
        {'text': 'To invest in stocks', 'correct': false},
      ],
    },
    {
      'question':
          'What percentage of your income should go to needs in the 50-30-20 rule?',
      'answers': [
        {'text': '20%', 'correct': false},
        {'text': '30%', 'correct': false},
        {'text': '50%', 'correct': true},
      ],
    },
    {
      'question': 'What is a good credit score range?',
      'answers': [
        {'text': '300-500', 'correct': false},
        {'text': '670-850', 'correct': true},
        {'text': '100-300', 'correct': false},
      ],
    },
    {
      'question': 'What is the first step to get out of debt?',
      'answers': [
        {'text': 'Ignore it and hope it goes away', 'correct': false},
        {'text': 'Create a debt repayment plan', 'correct': true},
        {'text': 'Take on more debt to pay it off', 'correct': false},
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
        title: const Text('Intermediate Quiz'),
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
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
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
