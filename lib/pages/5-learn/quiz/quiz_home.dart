import 'package:flutter/material.dart';
import 'quiz.dart';
import 'quiz_results_page.dart';
import '../../../core/storage/storage_manager.dart';
import 'package:intl/intl.dart';

class QuizHomePage extends StatelessWidget {
  const QuizHomePage({super.key});

  Future<Map<String, dynamic>> _getSummary() async {
    try {
      // Get the cloud service from StorageManager
      final learningService = StorageManager().learningService;
      
      // Fetch the summary from cloud service
      return await learningService.getQuizSummary();
    } catch (e) {
      debugPrint('Error getting quiz summary: $e');
      return {'total': 0, 'average': 0.0, 'last': null};
    }
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
                            Text("${(summary['average'] as double).toStringAsFixed(1)}%",
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
                                  ? DateFormat('MMM d, h:mm a').format(
                                      summary['last'] is String 
                                          ? DateTime.parse(summary['last']) 
                                          : summary['last'])
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