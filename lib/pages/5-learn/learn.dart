import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/pages/2-chatbot/chatbot.dart'; // Ensure this import is correct and the file exists

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
          _buildAIAssistantButton(context),
        ],
      ),
    );
  }

  Widget _buildAIAssistantButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.chat, color: Colors.white),
        label: const Text(
          'Ask Finney AI for any help',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Chatbot()),
          );
        },
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
                  url: "https://youtu.be/3m3-lMdIlJw?si=LJMRj1273-hjIwMZ",
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
                  title: "Budgeting for Beginners; Learn 50-30-20 Rule",
                  url: "https://youtu.be/HQzoZfc3GwQ?si=SOQDM3sDXQBNdkOh",
                ),

                Resource(
                  type: ResourceType.article,
                  title: "Journal: NerdWallet: Budgeting 101",
                  url:
                      "https://www.nerdwallet.com/au/personal-finance/how-to-budget",
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
                  title: "Investing basics by Prof Dave",
                  url: "https://youtu.be/qIw-yFC-HNU?si=xoqGmxGuv1jZzyHH",
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
                  title: "Financial Safety Tips for Mobile Banking",
                  url: "https://youtu.be/F5l2BucBfKY?si=Ksbi-NEHQXze3a0E",
                ),
                Resource(
                  type: ResourceType.video,
                  title: "Guide to Financial Security",
                  url: "https://www.youtube.com/watch?v=3m3-lMdIlJw",
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

  Future<void> launchURL(BuildContext context, String url) async {
    try {
      // Convert YouTube URLs to proper format if needed
      String processedUrl = url;
      if (url.contains('youtube.com/watch') || url.contains('youtu.be')) {
        final videoId = RegExp(
          r'(?:youtube.com/watch?v=|youtu.be/)([a-zA-Z0-9-]+)',
        ).firstMatch(url)?.group(1);
        if (videoId != null) {
          processedUrl = 'https://youtube.com/watch?v=$videoId';
        }
      }

      final uri = Uri.parse(processedUrl);
      if (!await canLaunchUrl(uri)) {
        throw Exception('Could not launch $url');
      }
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );
    } catch (e) {
      debugPrint('Error launching URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open link: ${e.toString()}')),
      );
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
                    onTap: () => launchURL(context, resource.url),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Chatbot()),
          );
        },
        icon: const Icon(Icons.chat),
        label: const Text('AI Assistant'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
