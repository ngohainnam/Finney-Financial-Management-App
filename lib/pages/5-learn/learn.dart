import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:finney/assets/theme/app_color.dart';

class Learn extends StatelessWidget {
  const Learn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Financial Basics',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 16),
          _buildSimpleCard(
            context,
            title: 'Money Management',
            subtitle: 'Track, plan, and control your money',
            icon: Icons.account_balance_wallet,
            color: AppColors.primary,
            onTap: () => _navigateToMoneyBasics(context),
          ),
          _buildSimpleCard(
            context,
            title: 'Saving & Budgeting',
            subtitle: 'Learn how to save and budget smartly',
            icon: Icons.savings,
            color: Colors.green,
            onTap: () => _navigateToSaving(context),
          ),
          _buildSimpleCard(
            context,
            title: 'Investing Fundamentals',
            subtitle: 'Understand how to grow your money',
            icon: Icons.trending_up,
            color: Colors.orange,
            onTap: () => _navigateToInvesting(context),
          ),
          _buildSimpleCard(
            context,
            title: 'Financial Safety',
            subtitle: 'Stay secure and avoid scams',
            icon: Icons.shield,
            color: Colors.blue,
            onTap: () => _navigateToSafety(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToMoneyBasics(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => SectionDetailPage(
              title: 'Money Management',
              points: [
                "Track income and expenses regularly",
                "Differentiate between needs and wants",
                "Understand basic banking services",
                "Maintain a simple financial record",
              ],
              resources: [
                Resource(
                  type: ResourceType.video,
                  title: "Basic Money Management",
                  url:
                      "https://www.youtube.com/results?search_query=emergency+funds+save+for+emergency",
                ),
                Resource(
                  type: ResourceType.article,
                  title: "Journal: Personal Finance Basics",
                  url: "https://www.investopedia.com/personal-finance-4427760",
                ),
              ],
            ),
      ),
    );
  }

  void _navigateToSaving(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => SectionDetailPage(
              title: 'Saving & Budgeting',
              points: [
                "Follow the 50-30-20 rule (Needs-Wants-Savings)",
                "Build an emergency fund (3-6 months expenses)",
                "Automate your savings",
                "Review and adjust budget monthly",
              ],
              resources: [
                Resource(
                  type: ResourceType.video,
                  title: "Budgeting for Beginners",
                  url: "https://www.youtube.com/watch?v=7lHNMGoACdQ",
                ),
              ],
            ),
      ),
    );
  }

  void _navigateToInvesting(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => SectionDetailPage(
              title: 'Investing Fundamentals',
              points: [
                "Understand risk and return",
                "Diversify your investments",
                "Learn about stocks, bonds, and mutual funds",
                "Start with small investments and grow gradually",
              ],
              resources: [
                Resource(
                  type: ResourceType.video,
                  title: "Investing 101",
                  url: "https://www.youtube.com/watch?v=gFQNPmLKj1k",
                ),
                Resource(
                  type: ResourceType.article,
                  title: "Guide to Investing Basics",
                  url:
                      "https://www.nerdwallet.com/article/investing/investing-basics",
                ),
              ],
            ),
      ),
    );
  }

  void _navigateToSafety(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => SectionDetailPage(
              title: 'Financial Safety',
              points: [
                "Recognize and avoid financial scams",
                "Understand the importance of insurance",
                "Secure your online financial accounts",
                "Learn about identity theft protection",
              ],
              resources: [
                Resource(
                  type: ResourceType.video,
                  title: "Financial Safety Tips",
                  url: "https://www.youtube.com/watch?v=G6O7lU7sxq8",
                ),
                Resource(
                  type: ResourceType.article,
                  title: "Guide to Financial Security",
                  url: "https://www.consumerfinance.gov/consumer-tools/fraud/",
                ),
              ],
            ),
      ),
    );
  }
}

enum ResourceType { video, article }

class Resource {
  final ResourceType type;
  final String title;
  final String url;

  Resource({required this.type, required this.title, required this.url});
}

class SectionDetailPage extends StatelessWidget {
  final String title;
  final List<String> points;
  final List<Resource> resources;

  const SectionDetailPage({
    super.key,
    required this.title,
    required this.points,
    this.resources = const [],
  });

  Future<void> _launchURL(String url) async {
    try {
      final uri = Uri.parse(url);
      if (!await canLaunchUrl(uri)) {
        throw Exception('Could not launch $url');
      }
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Error launching URL: $e');
      // You might want to show a snackbar or dialog here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              'Key Points:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            ...points.map(
              (point) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Icon(
                        Icons.check_circle,
                        size: 18,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        point,
                        style: const TextStyle(fontSize: 16, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (resources.isNotEmpty) ...[
              const SizedBox(height: 32),
              Text(
                'Learn More:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              ...resources.map(
                (resource) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Icon(
                      resource.type == ResourceType.video
                          ? Icons.play_circle_fill
                          : Icons.article_outlined,
                      color: Colors.blue,
                      size: 28,
                    ),
                    title: Text(resource.title),
                    trailing: const Icon(Icons.open_in_new, size: 18),
                    onTap: () => _launchURL(resource.url),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Back to Topics'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
