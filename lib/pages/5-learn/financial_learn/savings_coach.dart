import 'package:flutter/material.dart';

class SavingsCoach extends StatefulWidget {
  const SavingsCoach({super.key});

  @override
  SavingsCoachState createState() => SavingsCoachState();
}

class SavingsCoachState extends State<SavingsCoach> {
  int currentStep = 0;
  String selectedOption = '';
  TextEditingController otherController = TextEditingController();
  List<String> userAnswers = [];

  final List<Map<String, dynamic>> questions = [
    {
      'question': "How good are you with managing your money? Boss level or still figuring it out?",
      'options': ['Money boss', 'Doing okay', 'Needs work'],
    },
    {
      'question': "How much money do you usually save each month?",
      'options': ['\$0-\$200', '\$200-\$500', '\$500+'],
    },
    {
      'question': "How much do you usually spend each month?",
      'options': ['\$0-\$1000', '\$1000-\$2000', '\$2000+'],
    },
    {
      'question': "In a perfect world, how much would you love to save monthly?",
      'options': ['\$100', '\$500', '\$1000+'],
    },
    {
      'question': "Can you easily tell needs apart from wants?",
      'options': ['Always', 'Sometimes', 'Not really'],
    },
    {
      'question': "What category eats up most of your money?",
      'options': ['Food', 'Shopping', 'Entertainment'],
    },
    {
      'question': "Do you track where your money goes?",
      'options': ['Always', 'Sometimes', 'Never'],
    },
    {
      'question': "Are you willing to adjust your spending habits?",
      'options': ['Yes', 'Maybe', 'No'],
    },
    {
      'question': "Do you often spend money without planning?",
      'options': ['Yes', 'Sometimes', 'Rarely'],
    },
    {
      'question': "When you get extra cash, do you save it or spend it?",
      'options': ['Save it', 'Spend it', 'A bit of both'],
    },
    {
      'question': "Would you rather save for a big goal or enjoy small treats now?",
      'options': ['Save for big goal', 'Enjoy small treats', 'Not sure'],
    },
  ];

  bool get canProceed {
    return selectedOption.isNotEmpty || otherController.text.trim().isNotEmpty;
  }

  void nextStep() {
    String answer = selectedOption.isNotEmpty ? selectedOption : otherController.text.trim();
    userAnswers.add(answer);

    if (currentStep < questions.length - 1) {
      setState(() {
        currentStep++;
        selectedOption = '';
        otherController.clear();
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ResultScreen(userAnswers: userAnswers)),
      );
    }
  }

  Widget buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: LinearProgressIndicator(
        value: (currentStep + 1) / questions.length,
        backgroundColor: Colors.white54,
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
      ),
    );
  }

  Widget buildCard(Widget child) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget buildOptions(List<String> options) {
    return Column(
      children: [
        ...options.map((option) => GestureDetector(
              onTap: () {
                setState(() {
                  selectedOption = option;
                  otherController.clear();
                });
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: selectedOption == option ? Colors.blueAccent.withValues(alpha: 0.2) : Colors.white,
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(option, style: const TextStyle(fontSize: 16)),
              ),
            )),
        const SizedBox(height: 12),
        TextField(
          controller: otherController,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: "Other (please specify)",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentStep];

    return Scaffold(
      backgroundColor: const Color(0xFFDFF8EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDFF8EB),
        elevation: 0,
        title: const Text('Savings Coach', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Column(
          children: [
            buildProgressBar(),
            buildCard(
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentQuestion['question'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    buildOptions(currentQuestion['options']),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: ElevatedButton(
                onPressed: canProceed ? nextStep : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(currentStep == questions.length - 1 ? "See Result" : "Next"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final List<String> userAnswers;

  const ResultScreen({super.key, required this.userAnswers});

  String generateAdvice() {
    String savingRange = userAnswers[1];
    String spendingRange = userAnswers[2];
    //String dreamSave = userAnswers[3];
    String bigSpendArea = userAnswers[5];
    String tracksExpenses = userAnswers[6];
    String willingToAdjust = userAnswers[7];

    String advice = "";

    if (savingRange == "\$0-\$200") {
      advice += "Looks like you are saving small right now. ";
    } else if (savingRange == "\$200-\$500") {
      advice += "You're on your way with decent savings! ";
    } else {
      advice += "Great saving habit! ";
    }

    if (spendingRange == "\$2000+") {
      advice += "But your spending is high. Try cutting at least \$150 from your $bigSpendArea.\n";
    } else if (spendingRange == "\$1000-\$2000") {
      advice += "There is still room to trim about \$100 from $bigSpendArea.\n";
    } else {
      advice += "Spending looks healthy. Keep it up!\n";
    }

    if (tracksExpenses == "Never") {
      advice += "Start tracking where your money goes. It will surprise you!\n";
    } else if (tracksExpenses == "Sometimes") {
      advice += "Tracking a little more seriously could reveal hidden leaks.\n";
    }

    if (willingToAdjust == "No") {
      advice += "Even tiny changes like skipping one takeaway meal a week can save \$100+ a month.\n";
    } else if (willingToAdjust == "Maybe") {
      advice += "Try testing small adjustments. You might love the results!\n";
    } else {
      advice += "You are ready to smash your savings goals. Time to go all in!\n";
    }

    return advice;
  }

  @override
  Widget build(BuildContext context) {
    String advice = generateAdvice();

    return Scaffold(
      backgroundColor: const Color(0xFFDFF8EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDFF8EB),
        elevation: 0,
        title: const Text('Your Saving Plan', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Your Personalized Advice",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  advice,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => SavingsCoach()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text("Restart Savings Coach"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
