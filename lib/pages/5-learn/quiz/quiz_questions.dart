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
  QuizQuestion(
    question: 'Why should you wait 24 hours before buying something unplanned?',
    options: ['Shops may close', 'Helps avoid impulse spending', 'Prices might drop', 'You might get paid'],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: 'What is a “want” in budgeting terms?',
    options: ['Essential food', 'Rent', 'Medical expenses', 'Designer sneakers'],
    correctAnswerIndex: 3,
  ),
  QuizQuestion(
    question: 'Which of the following helps increase income?',
    options: ['Skipping meals', 'Skill development', 'Spending more', 'Taking loans'],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: 'What is the 50-30-20 rule commonly used for?',
    options: ['Meal planning', 'Work hours', 'Budgeting', 'Exercise routine'],
    correctAnswerIndex: 2,
  ),
  QuizQuestion(
    question: 'What should you do before spending money?',
    options: ['Check trends', 'Post on social media', 'Make a budget plan', 'Borrow from friends'],
    correctAnswerIndex: 2,
  ),
  QuizQuestion(
    question: 'Where is it safest to invest first, according to the Finney app videos?',
    options: ['Crypto', 'Land', 'Forex', 'NFTs'],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: 'What’s a benefit of cooking at home?',
    options: ['More plastic waste', 'Higher delivery cost', 'Saves money and improves health', 'Takes more time'],
    correctAnswerIndex: 2,
  ),
  QuizQuestion(
    question: 'Why is saving early in the month smart?',
    options: ['To avoid shopping', 'So you don’t have to budget', 'To build financial discipline', 'To pay fines early'],
    correctAnswerIndex: 2,
  ),
  QuizQuestion(
    question: 'How much should ideally go into personal development according to budgeting tips?',
    options: ['55%', '15%', '30%', '10%'],
    correctAnswerIndex: 3,
  ),
  QuizQuestion(
    question: 'What does “protecting your money” usually refer to?',
    options: ['Spending on gadgets', 'Avoiding all risks', 'Using insurance and emergency funds', 'Buying gold'],
    correctAnswerIndex: 2,
  ),
  QuizQuestion(
    question: 'What is the first step in setting a financial goal?',
    options: ['Spend freely', 'Set a savings target', 'Shop online', 'Borrow money'],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: 'Which feature provides instant financial help in the Finney app?',
    options: ['Settings', 'QnA Chatbot', 'Expense Tracker', 'Profile'],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: 'An emergency fund is mainly used for?',
    options: ['Vacations', 'Unexpected expenses', 'Entertainment', 'Shopping'],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: 'Which is a good saving habit?',
    options: ['Impulse buying', 'Tracking expenses', 'Ignoring bills', 'Overspending'],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: 'If you earn 20000 and spend 18000, your savings are?',
    options: ['5000', '3000', '2000', '1000'],
    correctAnswerIndex: 2,
  ),
  QuizQuestion(
    question: 'What usually causes financial stress?',
    options: ['Overspending', 'Saving regularly', 'Following a budget', 'Having insurance'],
    correctAnswerIndex: 0,
  ),
  QuizQuestion(
    question: 'When should you ideally save money?',
    options: ['End of the month', 'After income', 'After expenses', 'When borrowing'],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: 'Budgeting helps in?',
    options: ['Spending more', 'Managing money better', 'Losing savings', 'Gambling'],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: 'Which is a “need” expense?',
    options: ['Netflix subscription', 'Groceries', 'Luxury car', 'Designer watch'],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: 'Before investing, you should always check?',
    options: ['Popularity', 'Risk and return', 'Number of likes', 'Brand name'],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: 'How to reduce impulse buying?',
    options: ['Use credit cards', 'Use shopping lists', 'Follow ads', 'Shop when emotional'],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: 'A good financial goal is?',
    options: ['Vague and distant', 'Specific and measurable', 'Expensive and fast', 'Lucky and random'],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: 'Saving money mainly helps with?',
    options: ['Showing off', 'Building security', 'Buying unnecessary items', 'Spending faster'],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: 'Which section in the Finney app helps improve financial skills?',
    options: ['Settings', 'Learn Academy', 'Notifications', 'Profile'],
    correctAnswerIndex: 1,
  ),
  QuizQuestion(
    question: 'If expenses are greater than income, what happens?',
    options: ['Debt increases', 'Savings increase', 'Net worth grows', 'Salary doubles'],
    correctAnswerIndex: 0,
  ),
];
