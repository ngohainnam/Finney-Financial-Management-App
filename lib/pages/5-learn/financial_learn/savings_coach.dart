import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/shared/localization/locales.dart';

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

  List<Map<String, dynamic>> get questions => [
    {
      'question': LocaleData.coachQ1.getString(context),
      'options': [
        LocaleData.coachOptMoneyBoss.getString(context),
        LocaleData.coachOptDoingOkay.getString(context),
        LocaleData.coachOptNeedsWork.getString(context),
      ],
    },
    {
      'question': LocaleData.coachQ2.getString(context),
      'options': [
        LocaleData.coachOpt0_200.getString(context),
        LocaleData.coachOpt200_500.getString(context),
        LocaleData.coachOpt500plus.getString(context),
      ],
    },
    {
      'question': LocaleData.coachQ3.getString(context),
      'options': [
        LocaleData.coachOpt0_1000.getString(context),
        LocaleData.coachOpt1000_2000.getString(context),
        LocaleData.coachOpt2000plus.getString(context),
      ],
    },
    {
      'question': LocaleData.coachQ4.getString(context),
      'options': [
        LocaleData.coachOpt100.getString(context),
        LocaleData.coachOpt500.getString(context),
        LocaleData.coachOpt1000plus.getString(context),
      ],
    },
    {
      'question': LocaleData.coachQ5.getString(context),
      'options': [
        LocaleData.coachOptAlways.getString(context),
        LocaleData.coachOptSometimes.getString(context),
        LocaleData.coachOptNotReally.getString(context),
      ],
    },
    {
      'question': LocaleData.coachQ6.getString(context),
      'options': [
        LocaleData.coachOptFood.getString(context),
        LocaleData.coachOptShopping.getString(context),
        LocaleData.coachOptEntertainment.getString(context),
      ],
    },
    {
      'question': LocaleData.coachQ7.getString(context),
      'options': [
        LocaleData.coachOptAlways.getString(context),
        LocaleData.coachOptSometimes.getString(context),
        LocaleData.coachOptNever.getString(context),
      ],
    },
    {
      'question': LocaleData.coachQ8.getString(context),
      'options': [
        LocaleData.coachOptYes.getString(context),
        LocaleData.coachOptMaybe.getString(context),
        LocaleData.coachOptNo.getString(context),
      ],
    },
    {
      'question': LocaleData.coachQ9.getString(context),
      'options': [
        LocaleData.coachOptYes.getString(context),
        LocaleData.coachOptSometimes.getString(context),
        LocaleData.coachOptRarely.getString(context),
      ],
    },
    {
      'question': LocaleData.coachQ10.getString(context),
      'options': [
        LocaleData.coachOptSaveIt.getString(context),
        LocaleData.coachOptSpendIt.getString(context),
        LocaleData.coachOptBoth.getString(context),
      ],
    },
    {
      'question': LocaleData.coachQ11.getString(context),
      'options': [
        LocaleData.coachOptSaveBig.getString(context),
        LocaleData.coachOptTreats.getString(context),
        LocaleData.coachOptNotSure.getString(context),
      ],
    },
  ];

  bool get canProceed {
    return selectedOption.isNotEmpty || otherController.text.trim().isNotEmpty;
  }

  void nextStep() {
    String answer =
    selectedOption.isNotEmpty
        ? selectedOption
        : otherController.text.trim();
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
        MaterialPageRoute(
          builder: (_) => ResultScreen(userAnswers: userAnswers),
        ),
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
        ...options.map(
              (option) => GestureDetector(
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
                color:
                selectedOption == option
                    ? Colors.blueAccent.withValues(alpha: 0.2)
                    : Colors.white,
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(option, style: const TextStyle(fontSize: 16)),
            ),
          ),
        ),
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
          style: TextStyle(color: Colors.black),
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

class ResultScreen extends StatefulWidget {
  final List<String> userAnswers;

  const ResultScreen({super.key, required this.userAnswers});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String generateAdvice() {
    String savingRange = widget.userAnswers[1];
    String spendingRange = widget.userAnswers[2];
    String bigSpendArea = widget.userAnswers[5];
    String tracksExpenses = widget.userAnswers[6];
    String willingToAdjust = widget.userAnswers[7];

    String advice = "";

    if (savingRange == "\$0-\$200") {
      advice += LocaleData.coachSavingSmall.getString(context);
    } else if (savingRange == "\$200-\$500") {
      advice += LocaleData.coachOnYourWay.getString(context);
    } else {
      advice += LocaleData.coachPraiseGreat.getString(context);
    }

    if (spendingRange == "\$2000+") {
      advice += LocaleData.coachSpendingHigh
          .getString(context)
          .replaceFirst('%s', bigSpendArea);
    } else if (spendingRange == "\$1000-\$2000") {
      advice += LocaleData.coachSpendingMedium
          .getString(context)
          .replaceFirst('%s', bigSpendArea);
    } else {
      advice += LocaleData.coachSpendingHealthy.getString(context);
    }

    if (tracksExpenses == LocaleData.never.getString(context)) {
      advice += LocaleData.coachTrackStart.getString(context);
    } else if (tracksExpenses == LocaleData.sometimes.getString(context)) {
      advice += LocaleData.coachTrackMore.getString(context);
    }

    if (willingToAdjust == LocaleData.no.getString(context)) {
      advice += LocaleData.coachAdjustNo.getString(context);
    } else if (willingToAdjust == LocaleData.maybe.getString(context)) {
      advice += LocaleData.coachAdjustMaybe.getString(context);
    } else {
      advice += LocaleData.coachAdjustYes.getString(context);
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
        title: Text(
          LocaleData.coachSavingPlan.getString(context),
          style: TextStyle(color: Colors.black),
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
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
