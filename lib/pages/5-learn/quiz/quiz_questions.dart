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

final List<QuizQuestion> quizQuestions = [
  QuizQuestion(
    question: 'What is the purpose of the Finney app?',
    options: ['Gaming', 'Social networking', 'Financial literacy', 'Online shopping'],
    correctAnswerIndex: 2,
  ),
  QuizQuestion(
    question: 'Which screen helps track expenses?',
    options: ['Dashboard', 'Chatbot', 'Learn', 'Settings'],
    correctAnswerIndex: 0,
  ),
  QuizQuestion(
    question: 'What is a budget used for?',
    options: ['Tracking spending', 'Entertainment', 'Investing in crypto', 'Buying groceries'],
    correctAnswerIndex: 0,
  ),
  QuizQuestion(
    question: 'Which category would rent typically go under?',
    options: ['Savings', 'Needs', 'Wants', 'Luxury'],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: 'What is one smart spending tip?',
    options: ['Buy unnecessary items', 'Track every dollar', 'Avoid discounts', 'Spend impulsively'],
    correctAnswerIndex: 1,
  ),

  // Add 10 more questions as needed...
];
