import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:finney/pages/5-learn/beginner/beginner_quiz.dart';
import 'package:finney/pages/5-learn/models/resource.dart';

class BeginnerScreen extends StatelessWidget {
  const BeginnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beginner Financial Skills'),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFFF7F6FA),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildLessonCard(
            context: context,
            icon: Icons.attach_money,
            title: 'Understanding Money',
            points: [
              'What is money and how it works',
              'Different types of money (cash, digital)',
              'Basic needs vs wants',
            ],
            resources: [
              Resource(
                type: ResourceType.video,
                title: "What is Money? - Simple Explanation",
                url: "https://youtu.be/m5lQ5d3oykM",
              ),
              Resource(
                type: ResourceType.article,
                title: "Needs vs Wants: How to Tell the Difference",
                url:
                    "https://www.moneysmart.gov.au/managing-your-money/budgeting/needs-and-wants",
              ),
            ],
          ),
          _buildLessonCard(
            context: context,
            icon: Icons.account_balance_wallet,
            title: 'Simple Budgeting',
            points: [
              'Tracking daily expenses',
              'The 50-30-20 rule simplified',
              'Saving small amounts regularly',
            ],
            resources: [
              Resource(
                type: ResourceType.video,
                title: "Budgeting for Beginners",
                url: "https://youtu.be/HQzoZfc3GwQ",
              ),
              Resource(
                type: ResourceType.article,
                title: "The 50/30/20 Budget Rule Explained",
                url:
                    "https://www.nerdwallet.com/article/finance/nerdwallet-budget-guide",
              ),
            ],
          ),
          _buildLessonCard(
            context: context,
            icon: Icons.account_balance,
            title: 'Bank Accounts',
            points: [
              'Types of bank accounts',
              'How to deposit and withdraw money',
              'Understanding bank statements',
            ],
            resources: [
              Resource(
                type: ResourceType.video,
                title: "Banking Basics for Beginners",
                url: "https://youtu.be/EJVGzyW34LE",
              ),
              Resource(
                type: ResourceType.article,
                title: "How to Read a Bank Statement",
                url:
                    "https://www.investopedia.com/articles/personal-finance/082315/how-read-your-bank-statement.asp",
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BeginnerQuiz()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Take Beginner Quiz',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required List<String> points,
    List<Resource> resources = const [],
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
                Icon(icon, color: Colors.green, size: 28),
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
                    const Icon(Icons.circle, size: 8, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(child: Text(point)),
                  ],
                ),
              ),
            ),

            if (resources.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Text(
                'Learn More:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              ...resources.map(
                (resource) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => _launchResource(context, resource.url),
                    child: Row(
                      children: [
                        Icon(
                          resource.type == ResourceType.video
                              ? Icons.play_circle_outline
                              : Icons.article_outlined,
                          color: Colors.blue,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            resource.title,
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _launchResource(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);
      if (!await canLaunchUrl(uri)) {
        throw Exception('Could not launch $url');
      }
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not open resource: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
