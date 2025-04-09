import 'package:flutter/material.dart';
import 'package:finney/assets/widgets/common/app_navbar.dart';
import 'package:finney/pages/5-learn/widgets/section_card.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/pages/2-chatbot/chatbot.dart';

class Learn extends StatelessWidget {
  const Learn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Expand your financial knowledge',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              title: 'Fundamentals of Finance',
              modules: [
                'You and Money',
                'Investing Basics',
                'Society and Money',
              ],
              icon: Icons.account_balance_wallet,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              title: 'Trading Basics',
              modules: const [],
              icon: Icons.trending_up,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              title: 'Investing Basics',
              modules: const [],
              icon: Icons.bar_chart,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              title: 'Investing Advanced',
              modules: const [],
              icon: Icons.rocket_launch,
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<String> modules,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color),
                ),
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
            if (modules.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              ...modules.map(
                (module) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      const Icon(Icons.play_circle_outline, size: 20),
                      const SizedBox(width: 8),
                      Text(module),
                      const Spacer(),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
