import 'package:flutter/material.dart';

class AdvancedQuiz extends StatefulWidget {
  const AdvancedQuiz({super.key});

  @override
  State<AdvancedQuiz> createState() => _AdvancedQuizState();
}

class _AdvancedQuizState extends State<AdvancedQuiz> {
  int _currentQuestionIndex = 0;
  int _score = 0;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is the main benefit of compound interest?',
      'answers': [
        {'text': 'Money grows faster over time', 'correct': true},
        {'text': 'It reduces your taxes', 'correct': false},
        {'text': 'It\'s safer than regular interest', 'correct': false},
      ],
    },
    {
      'question': 'What does diversification in investing mean?',
      'answers': [
        {'text': 'Putting all money in one stock', 'correct': false},
        {
          'text': 'Spreading investments across different assets',
          'correct': true,
        },
        {'text': 'Investing only in what you know', 'correct': false},
      ],
    },
    {
      'question': 'What is a key feature of index funds?',
      'answers': [
        {'text': 'High management fees', 'correct': false},
        {'text': 'Tracks a specific market index', 'correct': true},
        {'text': 'Guaranteed returns', 'correct': false},
      ],
    },
    {
      'question': 'What is the 4% retirement rule?',
      'answers': [
        {
          'text': 'Withdraw 4% of savings annually in retirement',
          'correct': true,
        },
        {'text': 'Save 4% of income for retirement', 'correct': false},
        {'text': 'Work 4% longer than planned', 'correct': false},
      ],
    },
    {
      'question':
          'What type of insurance is most important for income protection?',
      'answers': [
        {'text': 'Travel insurance', 'correct': false},
        {'text': 'Income protection insurance', 'correct': true},
        {'text': 'Pet insurance', 'correct': false},
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
        title: const Text('Advanced Quiz'),
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
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.purple),
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
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}
