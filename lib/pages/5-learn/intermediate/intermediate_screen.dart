import 'package:flutter/material.dart';
import 'package:finney/pages/5-learn/intermediate/intermediate_quiz.dart';

class IntermediateScreen extends StatelessWidget {
  const IntermediateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Intermediate Financial Skills'),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFFF7F6FA),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildLessonCard(
            icon: Icons.pie_chart,
            title: 'Advanced Budgeting',
            points: [
              'Creating a monthly budget plan',
              'Setting financial goals',
              'Managing irregular income',
            ],
          ),
          _buildLessonCard(
            icon: Icons.credit_card,
            title: 'Credit Basics',
            points: [
              'Understanding credit scores',
              'Responsible credit card use',
              'Avoiding debt traps',
            ],
          ),
          _buildLessonCard(
            icon: Icons.savings,
            title: 'Saving Strategies',
            points: [
              'Emergency funds (3-6 months)',
              'Saving for big purchases',
              'Automating your savings',
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const IntermediateQuiz(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Take Intermediate Quiz',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonCard({
    required IconData icon,
    required String title,
    required List<String> points,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue, size: 28),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...points.map(
              (point) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.circle, size: 8, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(child: Text(point)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
