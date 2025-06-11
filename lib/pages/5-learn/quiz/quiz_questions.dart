import 'package:finney/shared/localization/locales.dart';
import 'package:flutter/material.dart';
import 'package:finney/pages/5-learn/string_extension.dart';

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });
}

List<QuizQuestion> quizQuestions(BuildContext context) => [
  QuizQuestion(
    question: LocaleData.quizQ1.getString(context),
    options: [
      LocaleData.quizQ1A1.getString(context),
      LocaleData.quizQ1A2.getString(context),
      LocaleData.quizQ1A3.getString(context),
      LocaleData.quizQ1A4.getString(context),
    ],
    correctAnswerIndex: 2,
  ),
  QuizQuestion(
    question: LocaleData.quizQ2.getString(context),
    options: [
      LocaleData.quizQ2A1.getString(context),
      LocaleData.quizQ2A2.getString(context),
      LocaleData.quizQ2A3.getString(context),
      LocaleData.quizQ2A4.getString(context),
    ],
    correctAnswerIndex: 0,
  ),
  QuizQuestion(
    question: LocaleData.quizQ3.getString(context),
    options: [
      LocaleData.quizQ3A1.getString(context),
      LocaleData.quizQ3A2.getString(context),
      LocaleData.quizQ3A3.getString(context),
      LocaleData.quizQ3A4.getString(context),
    ],
    correctAnswerIndex: 0,
  ),
  QuizQuestion(
    question: LocaleData.quizQ4.getString(context),
    options: [
      LocaleData.quizQ4A1.getString(context),
      LocaleData.quizQ4A2.getString(context),
      LocaleData.quizQ4A3.getString(context),
      LocaleData.quizQ4A4.getString(context),
    ],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: LocaleData.quizQ5.getString(context),
    options: [
      LocaleData.quizQ5A1.getString(context),
      LocaleData.quizQ5A2.getString(context),
      LocaleData.quizQ5A3.getString(context),
      LocaleData.quizQ5A4.getString(context),
    ],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: LocaleData.quizQ6.getString(context),
    options: [
      LocaleData.quizQ6A1.getString(context),
      LocaleData.quizQ6A2.getString(context),
      LocaleData.quizQ6A3.getString(context),
      LocaleData.quizQ6A4.getString(context),
    ],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: LocaleData.quizQ7.getString(context),
    options: [
      LocaleData.quizQ7A1.getString(context),
      LocaleData.quizQ7A2.getString(context),
      LocaleData.quizQ7A3.getString(context),
      LocaleData.quizQ7A4.getString(context),
    ],
    correctAnswerIndex: 3,
  ),
  QuizQuestion(
    question: LocaleData.quizQ8.getString(context),
    options: [
      LocaleData.quizQ8A1.getString(context),
      LocaleData.quizQ8A2.getString(context),
      LocaleData.quizQ8A3.getString(context),
      LocaleData.quizQ8A4.getString(context),
    ],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: LocaleData.quizQ9.getString(context),
    options: [
      LocaleData.quizQ9A1.getString(context),
      LocaleData.quizQ9A2.getString(context),
      LocaleData.quizQ9A3.getString(context),
      LocaleData.quizQ9A4.getString(context),
    ],
    correctAnswerIndex: 2,
  ),
  QuizQuestion(
    question: LocaleData.quizQ10.getString(context),
    options: [
      LocaleData.quizQ10A1.getString(context),
      LocaleData.quizQ10A2.getString(context),
      LocaleData.quizQ10A3.getString(context),
      LocaleData.quizQ10A4.getString(context),
    ],
    correctAnswerIndex: 2,
  ),
  QuizQuestion(
    question: LocaleData.quizQ11.getString(context),
    options: [
      LocaleData.quizQ11A1.getString(context),
      LocaleData.quizQ11A2.getString(context),
      LocaleData.quizQ11A3.getString(context),
      LocaleData.quizQ11A4.getString(context),
    ],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: LocaleData.quizQ12.getString(context),
    options: [
      LocaleData.quizQ12A1.getString(context),
      LocaleData.quizQ12A2.getString(context),
      LocaleData.quizQ12A3.getString(context),
      LocaleData.quizQ12A4.getString(context),
    ],
    correctAnswerIndex: 2,
  ),
  QuizQuestion(
    question: LocaleData.quizQ13.getString(context),
    options: [
      LocaleData.quizQ13A1.getString(context),
      LocaleData.quizQ13A2.getString(context),
      LocaleData.quizQ13A3.getString(context),
      LocaleData.quizQ13A4.getString(context),
    ],
    correctAnswerIndex: 2,
  ),
  QuizQuestion(
    question: LocaleData.quizQ14.getString(context),
    options: [
      LocaleData.quizQ14A1.getString(context),
      LocaleData.quizQ14A2.getString(context),
      LocaleData.quizQ14A3.getString(context),
      LocaleData.quizQ14A4.getString(context),
    ],
    correctAnswerIndex: 3,
  ),
  QuizQuestion(
    question: LocaleData.quizQ15.getString(context),
    options: [
      LocaleData.quizQ15A1.getString(context),
      LocaleData.quizQ15A2.getString(context),
      LocaleData.quizQ15A3.getString(context),
      LocaleData.quizQ15A4.getString(context),
    ],
    correctAnswerIndex: 2,
  ),
  QuizQuestion(
    question: LocaleData.quizQ16.getString(context),
    options: [
      LocaleData.quizQ16A1.getString(context),
      LocaleData.quizQ16A2.getString(context),
      LocaleData.quizQ16A3.getString(context),
      LocaleData.quizQ16A4.getString(context),
    ],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: LocaleData.quizQ17.getString(context),
    options: [
      LocaleData.quizQ17A1.getString(context),
      LocaleData.quizQ17A2.getString(context),
      LocaleData.quizQ17A3.getString(context),
      LocaleData.quizQ17A4.getString(context),
    ],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: LocaleData.quizQ18.getString(context),
    options: [
      LocaleData.quizQ18A1.getString(context),
      LocaleData.quizQ18A2.getString(context),
      LocaleData.quizQ18A3.getString(context),
      LocaleData.quizQ18A4.getString(context),
    ],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: LocaleData.quizQ19.getString(context),
    options: [
      LocaleData.quizQ19A1.getString(context),
      LocaleData.quizQ19A2.getString(context),
      LocaleData.quizQ19A3.getString(context),
      LocaleData.quizQ19A4.getString(context),
    ],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: LocaleData.quizQ20.getString(context),
    options: [
      LocaleData.quizQ20A1.getString(context),
      LocaleData.quizQ20A2.getString(context),
      LocaleData.quizQ20A3.getString(context),
      LocaleData.quizQ20A4.getString(context),
    ],
    correctAnswerIndex: 2,
  ),
  QuizQuestion(
    question: LocaleData.quizQ21.getString(context),
    options: [
      LocaleData.quizQ21A1.getString(context),
      LocaleData.quizQ21A2.getString(context),
      LocaleData.quizQ21A3.getString(context),
      LocaleData.quizQ21A4.getString(context),
    ],
    correctAnswerIndex: 0,
  ),
  QuizQuestion(
    question: LocaleData.quizQ22.getString(context),
    options: [
      LocaleData.quizQ22A1.getString(context),
      LocaleData.quizQ22A2.getString(context),
      LocaleData.quizQ22A3.getString(context),
      LocaleData.quizQ22A4.getString(context),
    ],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: LocaleData.quizQ23.getString(context),
    options: [
      LocaleData.quizQ23A1.getString(context),
      LocaleData.quizQ23A2.getString(context),
      LocaleData.quizQ23A3.getString(context),
      LocaleData.quizQ23A4.getString(context),
    ],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: LocaleData.quizQ24.getString(context),
    options: [
      LocaleData.quizQ24A1.getString(context),
      LocaleData.quizQ24A2.getString(context),
      LocaleData.quizQ24A3.getString(context),
      LocaleData.quizQ24A4.getString(context),
    ],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: LocaleData.quizQ25.getString(context),
    options: [
      LocaleData.quizQ25A1.getString(context),
      LocaleData.quizQ25A2.getString(context),
      LocaleData.quizQ25A3.getString(context),
      LocaleData.quizQ25A4.getString(context),
    ],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: LocaleData.quizQ26.getString(context),
    options: [
      LocaleData.quizQ26A1.getString(context),
      LocaleData.quizQ26A2.getString(context),
      LocaleData.quizQ26A3.getString(context),
      LocaleData.quizQ26A4.getString(context),
    ],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: LocaleData.quizQ27.getString(context),
    options: [
      LocaleData.quizQ27A1.getString(context),
      LocaleData.quizQ27A2.getString(context),
      LocaleData.quizQ27A3.getString(context),
      LocaleData.quizQ27A4.getString(context),
    ],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: LocaleData.quizQ28.getString(context),
    options: [
      LocaleData.quizQ28A1.getString(context),
      LocaleData.quizQ28A2.getString(context),
      LocaleData.quizQ28A3.getString(context),
      LocaleData.quizQ28A4.getString(context),
    ],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: LocaleData.quizQ29.getString(context),
    options: [
      LocaleData.quizQ29A1.getString(context),
      LocaleData.quizQ29A2.getString(context),
      LocaleData.quizQ29A3.getString(context),
      LocaleData.quizQ29A4.getString(context),
    ],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: LocaleData.quizQ30.getString(context),
    options: [
      LocaleData.quizQ30A1.getString(context),
      LocaleData.quizQ30A2.getString(context),
      LocaleData.quizQ30A3.getString(context),
      LocaleData.quizQ30A4.getString(context),
    ],
    correctAnswerIndex: 0,
  ),

// Appended 31–42 kept as-is
  QuizQuestion(
    question: LocaleData.quizQ31.getString(context),
    options: [
      LocaleData.quizQ31A1.getString(context),
      LocaleData.quizQ31A2.getString(context),
      LocaleData.quizQ31A3.getString(context),
      LocaleData.quizQ31A4.getString(context),
    ],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: LocaleData.quizQ32.getString(context),
    options: [
      LocaleData.quizQ32A1.getString(context),
      LocaleData.quizQ32A2.getString(context),
      LocaleData.quizQ32A3.getString(context),
      LocaleData.quizQ32A4.getString(context),
    ],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: LocaleData.quizQ33.getString(context),
    options: [
      LocaleData.quizQ33A1.getString(context),
      LocaleData.quizQ33A2.getString(context),
      LocaleData.quizQ33A3.getString(context),
      LocaleData.quizQ33A4.getString(context),
    ],
    correctAnswerIndex: 0,
  ),
  QuizQuestion(
    question: LocaleData.quizQ34.getString(context),
    options: [
      LocaleData.quizQ34A1.getString(context),
      LocaleData.quizQ34A2.getString(context),
      LocaleData.quizQ34A3.getString(context),
      LocaleData.quizQ34A4.getString(context),
    ],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: LocaleData.quizQ35.getString(context),
    options: [
      LocaleData.quizQ35A1.getString(context),
      LocaleData.quizQ35A2.getString(context),
      LocaleData.quizQ35A3.getString(context),
      LocaleData.quizQ35A4.getString(context),
    ],
    correctAnswerIndex: 0,
  ),
  QuizQuestion(
    question: LocaleData.quizQ36.getString(context),
    options: [
      LocaleData.quizQ36A1.getString(context),
      LocaleData.quizQ36A2.getString(context),
      LocaleData.quizQ36A3.getString(context),
      LocaleData.quizQ36A4.getString(context),
    ],
    correctAnswerIndex: 2,
  ),
  QuizQuestion(
    question: LocaleData.quizQ37.getString(context),
    options: [
      LocaleData.quizQ37A1.getString(context),
      LocaleData.quizQ37A2.getString(context),
      LocaleData.quizQ37A3.getString(context),
      LocaleData.quizQ37A4.getString(context),
    ],
    correctAnswerIndex: 2,
  ),
  QuizQuestion(
    question: LocaleData.quizQ38.getString(context),
    options: [
      LocaleData.quizQ38A1.getString(context),
      LocaleData.quizQ38A2.getString(context),
      LocaleData.quizQ38A3.getString(context),
      LocaleData.quizQ38A4.getString(context),
    ],
    correctAnswerIndex: 0,
  ),
  QuizQuestion(
    question: LocaleData.quizQ39.getString(context),
    options: [
      LocaleData.quizQ39A1.getString(context),
      LocaleData.quizQ39A2.getString(context),
      LocaleData.quizQ39A3.getString(context),
      LocaleData.quizQ39A4.getString(context),
    ],
    correctAnswerIndex: 2,
  ),
  QuizQuestion(
    question: LocaleData.quizQ40.getString(context),
    options: [
      LocaleData.quizQ40A1.getString(context),
      LocaleData.quizQ40A2.getString(context),
      LocaleData.quizQ40A3.getString(context),
      LocaleData.quizQ40A4.getString(context),
    ],

    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: LocaleData.quizQ41.getString(context),
    options: [
      LocaleData.quizQ41A1.getString(context),
      LocaleData.quizQ41A2.getString(context),
      LocaleData.quizQ41A3.getString(context),
      LocaleData.quizQ41A4.getString(context),
    ],
    correctAnswerIndex: 0,
  ),
  QuizQuestion(
    question: LocaleData.quizQ42.getString(context),
    options: [
      LocaleData.quizQ42A1.getString(context),
      LocaleData.quizQ42A2.getString(context),
      LocaleData.quizQ42A3.getString(context),
      LocaleData.quizQ42A4.getString(context),
    ],
    correctAnswerIndex: 1,
  ),
];