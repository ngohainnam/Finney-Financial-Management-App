import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/localization/locales.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

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
      'questionKey': LocaleData.quizQuestion1,
      'answers': [
        {'textKey': LocaleData.quizQuestion1Answer1, 'correct': true},
        {'textKey': LocaleData.quizQuestion1Answer2, 'correct': false},
        {'textKey': LocaleData.quizQuestion1Answer3, 'correct': false},
      ],
    },
    {
      'questionKey': LocaleData.quizQuestion2,
      'answers': [
        {'textKey': LocaleData.quizQuestion2Answer1, 'correct': false},
        {'textKey': LocaleData.quizQuestion2Answer2, 'correct': true},
        {'textKey': LocaleData.quizQuestion2Answer3, 'correct': false},
      ],
    },
    {
      'questionKey': LocaleData.quizQuestion3,
      'answers': [
        {'textKey': LocaleData.quizQuestion3Answer1, 'correct': false},
        {'textKey': LocaleData.quizQuestion3Answer2, 'correct': true},
        {'textKey': LocaleData.quizQuestion3Answer3, 'correct': false},
      ],
    },
    {
      'questionKey': LocaleData.quizQuestion4,
      'answers': [
        {'textKey': LocaleData.quizQuestion4Answer1, 'correct': true},
        {'textKey': LocaleData.quizQuestion4Answer2, 'correct': false},
        {'textKey': LocaleData.quizQuestion4Answer3, 'correct': false},
      ],
    },
    {
      'questionKey': LocaleData.quizQuestion5,
      'answers': [
        {'textKey': LocaleData.quizQuestion5Answer1, 'correct': false},
        {'textKey': LocaleData.quizQuestion5Answer2, 'correct': true},
        {'textKey': LocaleData.quizQuestion5Answer3, 'correct': false},
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

  void _resetQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
    });
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleData.quizCompleted.getString(context)),
        content: Text(
          LocaleData.quizScore
              .getString(context)
              .replaceFirst('%s', '$_score')
              .replaceFirst('%s', '${_questions.length}'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetQuiz();
            },
            child: Text(LocaleData.quizTryAgain.getString(context)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(LocaleData.quizFinish.getString(context)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleData.quizTitle.getString(context)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: AppColors.darkBlue),
      ),
      backgroundColor: AppColors.softGray,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              minHeight: 8,
              backgroundColor: AppColors.gray,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'Question ${_currentQuestionIndex + 1}/${_questions.length}',
              style: TextStyle(fontSize: 16, color: AppColors.gray),
            ),
            const SizedBox(height: 8),
            Text(
              // Use the string key directly with getString
              (_questions[_currentQuestionIndex]['questionKey'] as String).getString(context),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlue,
              ),
            ),
            const SizedBox(height: 24),
            ...(_questions[_currentQuestionIndex]['answers'] as List<Map<String, dynamic>>).map(
              (answer) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: () => _answerQuestion(answer['correct']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.darkBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 1,
                  ),
                  child: Text(
                    // Use the string key directly with getString
                    (answer['textKey'] as String).getString(context),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}