import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'quiz.dart';
import 'quiz_results_page.dart';
import '../../../core/storage/local/models/quiz/quiz_result_model.dart';
import 'package:intl/intl.dart';

class QuizHomePage extends StatelessWidget {
  const QuizHomePage({super.key});

  Future<Map<String, dynamic>> _getSummary() async {
    final box = Hive.box<QuizResult>('quiz_results');
    if (box.isEmpty) return {'total': 0, 'average': 0.0, 'last': null};

    int totalAttempts = box.length;
    double avgScore = 0;
    DateTime? last;

    for (int i = 0; i < box.length; i++) {
      final result = box.getAt(i);
      if (result != null) {
        avgScore += result.score / result.totalQuestions;
        if (last == null || result.timestamp.isAfter(last)) {
          last = result.timestamp;
        }
      }
    }

    return {
      'total': totalAttempts,
      'average': (avgScore / totalAttempts) * 100,
      'last': last
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _getSummary(),
      builder: (context, snapshot) {
        final summary = snapshot.data;

        return DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: const Color(0xFFF5F7FB),
            appBar: AppBar(
              title: const Text("Quiz"),
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              bottom: const TabBar(
                labelColor: Colors.blueAccent,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blueAccent,
                tabs: [
                  Tab(text: 'Take the Quiz'),
                  Tab(text: 'Results'),
                ],
              ),
            ),
            body: Column(
              children: [
                if (summary != null) ...[
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Attempts",
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            Text("${summary['total']}",
                                style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Average Score",
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            Text("${summary['average'].toStringAsFixed(1)}%",
                                style: const TextStyle(fontSize: 16)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Last Attempt",
                                style: TextStyle(fontWeight: FontWeight.w500)),
                            Text(
                              summary['last'] != null
                                  ? DateFormat('MMM d, h:mm a').format(summary['last'])
                                  : "-",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
                const Expanded(
                  child: TabBarView(
                    children: [
                      QuizPage(),
                      QuizResultsPage(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
