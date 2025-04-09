import 'package:flutter/material.dart';
import 'package:finney/assets/widgets/common/app_navbar.dart';
import 'package:finney/pages/5-learn/widgets/section_card.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/pages/2-chatbot/chatbot.dart';

//import 'package:flutter/material.dart';

class Learn extends StatelessWidget {
  const Learn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Learn',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Expand your financial knowledge',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            context,
            title: 'Fundamentals of Finance',
            color: Colors.blue,
            icon: Icons.menu_book,
            topics: [
              _Topic(
                'You and Money',
                "Understanding income, expenses, and needs vs wants.",
              ),
              _Topic(
                'Investing Basics',
                "How investing differs from saving and what compounding means.",
              ),
              _Topic(
                'Society and Money',
                "How the economy, government, and banks impact your finances.",
              ),
            ],
          ),
          _buildSectionCard(
            context,
            title: 'Trading Basics',
            color: Colors.green,
            icon: Icons.show_chart,
            topics: [
              _Topic(
                'What is Trading?',
                "Intro to buying and selling assets like stocks or crypto.",
              ),
              _Topic(
                'Common Trading Terms',
                "Learn bid/ask, stop loss, bull & bear markets.",
              ),
              _Topic(
                'Types of Traders',
                "Differences between day, swing, and long-term traders.",
              ),
            ],
          ),
          _buildSectionCard(
            context,
            title: 'Investing Basics',
            color: Colors.orange,
            icon: Icons.bar_chart,
            topics: [
              _Topic(
                'Why Invest Early',
                "Benefits of long-term investing and compound interest.",
              ),
              _Topic(
                'Asset Types',
                "Stocks, bonds, ETFs, mutual funds, and crypto.",
              ),
              _Topic(
                'Diversification',
                "How spreading investments lowers your risk.",
              ),
            ],
          ),
          _buildSectionCard(
            context,
            title: 'Investing Advanced',
            color: Colors.purple,
            icon: Icons.rocket_launch,
            topics: [
              _Topic(
                'Risk Management',
                "How to evaluate and manage investment risk.",
              ),
              _Topic(
                'Stock Analysis',
                "Intro to fundamental and technical analysis.",
              ),
              _Topic(
                'Building a Portfolio',
                "Create a mix of growth, value, and dividend stocks.",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required Color color,
    required IconData icon,
    required List<_Topic> topics,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
          ),
          const Divider(),
          ...topics.map(
            (t) => ListTile(
              title: Text(t.title),
              subtitle: Text(t.description),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => LearnDetailPage(
                            title: t.title,
                            content: t.description,
                          ),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Topic {
  final String title;
  final String description;
  _Topic(this.title, this.description);
}

class LearnDetailPage extends StatelessWidget {
  final String title;
  final String content;

  const LearnDetailPage({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(content, style: const TextStyle(fontSize: 16, height: 1.5)),
      ),
    );
  }
}
