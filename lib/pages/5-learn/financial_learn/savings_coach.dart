import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/shared/localization/locales.dart';

class SavingsCoach extends StatefulWidget {
  const SavingsCoach({super.key});

  @override
  State<SavingsCoach> createState() => SavingsCoachState();
}

class SavingsCoachState extends State<SavingsCoach> {
  int currentStep = 0;
  String selectedOptionKey = '';
  TextEditingController otherController = TextEditingController();
  List<String> userAnswers = [];

  List<Map<String, dynamic>> get questions => [
    {
      'question': LocaleData.coachQ1.getString(context),
      'options': [
        {'key': 'coachOpt1A', 'label': LocaleData.coachOpt1A.getString(context)},
        {'key': 'coachOpt1B', 'label': LocaleData.coachOpt1B.getString(context)},
        {'key': 'coachOpt1C', 'label': LocaleData.coachOpt1C.getString(context)},
      ],
    },
    {
      'question': LocaleData.coachQ2.getString(context),
      'options': [
        {'key': 'coachOpt2A', 'label': LocaleData.coachOpt2A.getString(context)},
        {'key': 'coachOpt2B', 'label': LocaleData.coachOpt2B.getString(context)},
        {'key': 'coachOpt2C', 'label': LocaleData.coachOpt2C.getString(context)},
      ],
    },
    {
      'question': LocaleData.coachQ3.getString(context),
      'options': [
        {'key': 'coachOpt3A', 'label': LocaleData.coachOpt3A.getString(context)},
        {'key': 'coachOpt3B', 'label': LocaleData.coachOpt3B.getString(context)},
        {'key': 'coachOpt3C', 'label': LocaleData.coachOpt3C.getString(context)},
      ],
    },
    {
      'question': LocaleData.coachQ4.getString(context),
      'options': [
        {'key': 'coachOpt4A', 'label': LocaleData.coachOpt4A.getString(context)},
        {'key': 'coachOpt4B', 'label': LocaleData.coachOpt4B.getString(context)},
        {'key': 'coachOpt4C', 'label': LocaleData.coachOpt4C.getString(context)},
      ],
    },
    {
      'question': LocaleData.coachQ5.getString(context),
      'options': [
        {'key': 'coachOpt5A', 'label': LocaleData.coachOpt5A.getString(context)},
        {'key': 'coachOpt5B', 'label': LocaleData.coachOpt5B.getString(context)},
        {'key': 'coachOpt5C', 'label': LocaleData.coachOpt5C.getString(context)},
      ],
    },
    {
      'question': LocaleData.coachQ6.getString(context),
      'options': [
        {'key': 'coachOpt6A', 'label': LocaleData.coachOpt6A.getString(context)},
        {'key': 'coachOpt6B', 'label': LocaleData.coachOpt6B.getString(context)},
        {'key': 'coachOpt6C', 'label': LocaleData.coachOpt6C.getString(context)},
      ],
    },
    {
      'question': LocaleData.coachQ7.getString(context),
      'options': [
        {'key': 'coachOpt7A', 'label': LocaleData.coachOpt7A.getString(context)},
        {'key': 'coachOpt7B', 'label': LocaleData.coachOpt7B.getString(context)},
        {'key': 'coachOpt7C', 'label': LocaleData.coachOpt7C.getString(context)},
      ],
    },
    {
      'question': LocaleData.coachQ8.getString(context),
      'options': [
        {'key': 'coachOpt8A', 'label': LocaleData.coachOpt8A.getString(context)},
        {'key': 'coachOpt8B', 'label': LocaleData.coachOpt8B.getString(context)},
        {'key': 'coachOpt8C', 'label': LocaleData.coachOpt8C.getString(context)},
      ],
    },
    {
      'question': LocaleData.coachQ9.getString(context),
      'options': [
        {'key': 'coachOpt9A', 'label': LocaleData.coachOpt9A.getString(context)},
        {'key': 'coachOpt9B', 'label': LocaleData.coachOpt9B.getString(context)},
        {'key': 'coachOpt9C', 'label': LocaleData.coachOpt9C.getString(context)},
      ],
    },
    {
      'question': LocaleData.coachQ10.getString(context),
      'options': [
        {'key': 'coachOpt10A', 'label': LocaleData.coachOpt10A.getString(context)},
        {'key': 'coachOpt10B', 'label': LocaleData.coachOpt10B.getString(context)},
        {'key': 'coachOpt10C', 'label': LocaleData.coachOpt10C.getString(context)},
      ],
    },
    {
      'question': LocaleData.coachQ11.getString(context),
      'options': [
        {'key': 'coachOpt11A', 'label': LocaleData.coachOpt11A.getString(context)},
        {'key': 'coachOpt11B', 'label': LocaleData.coachOpt11B.getString(context)},
        {'key': 'coachOpt11C', 'label': LocaleData.coachOpt11C.getString(context)},
      ],
    },
    {
      'question': LocaleData.coachQ12.getString(context),
      'options': [
        {'key': 'coachOpt12A', 'label': LocaleData.coachOpt12A.getString(context)},
        {'key': 'coachOpt12B', 'label': LocaleData.coachOpt12B.getString(context)},
        {'key': 'coachOpt12C', 'label': LocaleData.coachOpt12C.getString(context)},
      ],
    },
    {
      'question': LocaleData.coachQ13.getString(context),
      'options': [
        {'key': 'coachOpt13A', 'label': LocaleData.coachOpt13A.getString(context)},
        {'key': 'coachOpt13B', 'label': LocaleData.coachOpt13B.getString(context)},
        {'key': 'coachOpt13C', 'label': LocaleData.coachOpt13C.getString(context)},
      ],
    },
    {
      'question': LocaleData.coachQ14.getString(context),
      'options': [
        {'key': 'coachOpt14A', 'label': LocaleData.coachOpt14A.getString(context)},
        {'key': 'coachOpt14B', 'label': LocaleData.coachOpt14B.getString(context)},
        {'key': 'coachOpt14C', 'label': LocaleData.coachOpt14C.getString(context)},
      ],
    },
    {
      'question': LocaleData.coachQ15.getString(context),
      'options': [
        {'key': 'coachOpt15A', 'label': LocaleData.coachOpt15A.getString(context)},
        {'key': 'coachOpt15B', 'label': LocaleData.coachOpt15B.getString(context)},
        {'key': 'coachOpt15C', 'label': LocaleData.coachOpt15C.getString(context)},
      ],
    },
    {
      'question': LocaleData.coachQ16.getString(context),
      'options': [
        {'key': 'coachOpt16A', 'label': LocaleData.coachOpt16A.getString(context)},
        {'key': 'coachOpt16B', 'label': LocaleData.coachOpt16B.getString(context)},
        {'key': 'coachOpt16C', 'label': LocaleData.coachOpt16C.getString(context)},
      ],
    },
    {
      'question': LocaleData.coachQ17.getString(context),
      'options': [
        {'key': 'coachOpt17A', 'label': LocaleData.coachOpt17A.getString(context)},
        {'key': 'coachOpt17B', 'label': LocaleData.coachOpt17B.getString(context)},
        {'key': 'coachOpt17C', 'label': LocaleData.coachOpt17C.getString(context)},
      ],
    },
    {
      'question': LocaleData.coachQ18.getString(context),
      'options': [
        {'key': 'coachOpt18A', 'label': LocaleData.coachOpt18A.getString(context)},
        {'key': 'coachOpt18B', 'label': LocaleData.coachOpt18B.getString(context)},
        {'key': 'coachOpt18C', 'label': LocaleData.coachOpt18C.getString(context)},
      ],
    },
    {
      'question': LocaleData.coachQ19.getString(context),
      'options': [
        {'key': 'coachOpt19A', 'label': LocaleData.coachOpt19A.getString(context)},
        {'key': 'coachOpt19B', 'label': LocaleData.coachOpt19B.getString(context)},
        {'key': 'coachOpt19C', 'label': LocaleData.coachOpt19C.getString(context)},
      ],
    },
    {
      'question': LocaleData.coachQ20.getString(context),
      'options': [
        {'key': 'coachOpt20A', 'label': LocaleData.coachOpt20A.getString(context)},
        {'key': 'coachOpt20B', 'label': LocaleData.coachOpt20B.getString(context)},
        {'key': 'coachOpt20C', 'label': LocaleData.coachOpt20C.getString(context)},
      ],
    },
    {
      'question': LocaleData.coachQ21.getString(context),
      'options': [
        {'key': 'coachOpt21A', 'label': LocaleData.coachOpt21A.getString(context)},
        {'key': 'coachOpt21B', 'label': LocaleData.coachOpt21B.getString(context)},
        {'key': 'coachOpt21C', 'label': LocaleData.coachOpt21C.getString(context)},
      ],
    },
    {
      'question': LocaleData.coachQ22.getString(context),
      'options': [
        {'key': 'coachOpt22A', 'label': LocaleData.coachOpt22A.getString(context)},
        {'key': 'coachOpt22B', 'label': LocaleData.coachOpt22B.getString(context)},
        {'key': 'coachOpt22C', 'label': LocaleData.coachOpt22C.getString(context)},
      ],
    },
    {
      'question': LocaleData.coachQ23.getString(context),
      'options': [
        {'key': 'coachOpt23A', 'label': LocaleData.coachOpt23A.getString(context)},
        {'key': 'coachOpt23B', 'label': LocaleData.coachOpt23B.getString(context)},
        {'key': 'coachOpt23C', 'label': LocaleData.coachOpt23C.getString(context)},
      ],
    },
    {
      'question': LocaleData.coachQ24.getString(context),
      'options': [
        {'key': 'coachOpt24A', 'label': LocaleData.coachOpt24A.getString(context)},
        {'key': 'coachOpt24B', 'label': LocaleData.coachOpt24B.getString(context)},
        {'key': 'coachOpt24C', 'label': LocaleData.coachOpt24C.getString(context)},
      ],
    },
    {
      'question': LocaleData.coachQ25.getString(context),
      'options': [
        {'key': 'coachOpt25A', 'label': LocaleData.coachOpt25A.getString(context)},
        {'key': 'coachOpt25B', 'label': LocaleData.coachOpt25B.getString(context)},
        {'key': 'coachOpt25C', 'label': LocaleData.coachOpt25C.getString(context)},
      ],
    }
  ];

  bool get canProceed =>
      selectedOptionKey.isNotEmpty || otherController.text.trim().isNotEmpty;

  void nextStep() {
    final answer = selectedOptionKey.isNotEmpty
        ? selectedOptionKey
        : 'other:${otherController.text.trim()}';
    userAnswers.add(answer);

    if (currentStep < questions.length - 1) {
      setState(() {
        currentStep++;
        selectedOptionKey = '';
        otherController.clear();
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(userAnswers: userAnswers),
        ),
      );
    }
  }

  Widget buildOptions(List<Map<String, String>> options) {
    return Column(
      children: [
        ...options.map((option) => GestureDetector(
          onTap: () {
            setState(() {
              selectedOptionKey = option['key']!;
              otherController.clear();
            });
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: selectedOptionKey == option['key']
                  ? Colors.blueAccent.withOpacity(0.2)
                  : Colors.white,
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(option['label']!, style: const TextStyle(fontSize: 16)),
          ),
        )),
        const SizedBox(height: 12),
        TextField(
          controller: otherController,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: LocaleData.coachOtherHint.getString(context),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ],
    );
  }

  Widget buildProgressBar() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    child: LinearProgressIndicator(
      value: (currentStep + 1) / questions.length,
      backgroundColor: Colors.white54,
      valueColor: const AlwaysStoppedAnimation<Color>(Colors.blueAccent),
    ),
  );

  Widget buildCard(Widget child) => Expanded(
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

  @override
  Widget build(BuildContext context) {
    final currentQuestion = questions[currentStep];

    return Scaffold(
      backgroundColor: const Color(0xFFDFF8EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDFF8EB),
        elevation: 0,
        title: Text(
          LocaleData.savingsCoach.getString(context),
          style: const TextStyle(color: Colors.black),
        ),
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
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    buildOptions(List<Map<String, String>>.from(currentQuestion['options'])),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  currentStep == questions.length - 1
                      ? LocaleData.coachSeeResult.getString(context)
                      : LocaleData.coachNext.getString(context),
                ),
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

  static const Map<String, int> scoreMap = {
    'coachOpt1A': 2, 'coachOpt1B': 1, 'coachOpt1C': 1,
    'coachOpt2A': 3, 'coachOpt2B': 2, 'coachOpt2C': 1,
    'coachOpt3A': 2, 'coachOpt3B': 1, 'coachOpt3C': 1,
    'coachOpt4A': 3, 'coachOpt4B': 2, 'coachOpt4C': 1,
    'coachOpt5A': 3, 'coachOpt5B': 1, 'coachOpt5C': 2,
    'coachOpt6A': 3, 'coachOpt6B': 2, 'coachOpt6C': 1,
    'coachOpt7A': 3, 'coachOpt7B': 1, 'coachOpt7C': 2,
    'coachOpt8A': 3, 'coachOpt8B': 2, 'coachOpt8C': 1,
    'coachOpt9A': 3, 'coachOpt9B': 1, 'coachOpt9C': 2,
    'coachOpt10A': 3, 'coachOpt10B': 2, 'coachOpt10C': 1,
    'coachOpt11A': 3, 'coachOpt11B': 1, 'coachOpt11C': 2,
    'coachOpt12A': 3, 'coachOpt12B': 2, 'coachOpt12C': 1,
    'coachOpt13A': 3, 'coachOpt13B': 1, 'coachOpt13C': 2,
    'coachOpt14A': 3, 'coachOpt14B': 2, 'coachOpt14C': 1,
    'coachOpt15A': 3, 'coachOpt15B': 1, 'coachOpt15C': 2,
    'coachOpt16A': 3, 'coachOpt16B': 2, 'coachOpt16C': 1,
    'coachOpt17A': 3, 'coachOpt17B': 2, 'coachOpt17C': 1,
    'coachOpt18A': 3, 'coachOpt18B': 2, 'coachOpt18C': 1,
    'coachOpt19A': 3, 'coachOpt19B': 1, 'coachOpt19C': 2,
    'coachOpt20A': 3, 'coachOpt20B': 2, 'coachOpt20C': 1,
    'coachOpt21A': 1, 'coachOpt21B': 2, 'coachOpt21C': 3,
    'coachOpt22A': 3, 'coachOpt22B': 2, 'coachOpt22C': 1,
    'coachOpt23A': 3, 'coachOpt23B': 2, 'coachOpt23C': 1,
    'coachOpt24A': 3, 'coachOpt24B': 2, 'coachOpt24C': 1,
    'coachOpt25A': 3, 'coachOpt25B': 2, 'coachOpt25C': 1,
  };

  String generateAdvice(BuildContext context) {
    int totalScore = 0;

    for (var key in userAnswers) {
      if (key.startsWith('coachOpt')) {
        totalScore += scoreMap[key] ?? 2;
      }
    }

    if (totalScore <= 40) {
      return LocaleData.coachAdviceLow.getString(context);
    } else if (totalScore <= 60) {
      return LocaleData.coachAdviceMid.getString(context);
    } else {
      return LocaleData.coachAdviceHigh.getString(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final advice = generateAdvice(context);

    return Scaffold(
      backgroundColor: const Color(0xFFDFF8EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDFF8EB),
        elevation: 0,
        title: Text(
          LocaleData.coachSavingPlan.getString(context),
          style: const TextStyle(color: Colors.black),
        ),
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
                Text(
                  LocaleData.coachAdviceTitle.getString(context),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
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
                      MaterialPageRoute(
                        builder: (_) => const SavingsCoach(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(LocaleData.coachRestart.getString(context)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
