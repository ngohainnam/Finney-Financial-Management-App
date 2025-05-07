import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'learn_progress.dart';

class HowToUseApp extends StatefulWidget {
  const HowToUseApp({super.key});

  @override
  State<HowToUseApp> createState() => _HowToUseAppState();
}

class _HowToUseAppState extends State<HowToUseApp> {
  final String lessonKey = 'how_to_use_app';

  final String shortDescription =
      'এই ভিডিওতে ফিনি অ্যাপের মূল ফিচারগুলোর সংক্ষিপ্ত পরিচিতি দেখানো হয়েছে — যেমন খরচ রেকর্ড, সেভিংস, কুইজ এবং চ্যাটবট।';

  final String fullDescription = '''
🔹 Expense Recording – প্রতিদিনের খরচ কীভাবে রেকর্ড করতে হয়
🔹 Dashboard Summary – সাম্প্রতিক খরচ, সেভিংস ও রিমাইন্ডার দেখতে কোথায় যাবেন
🔹 Learn Section – বাংলা ভিডিও দিয়ে সহজে ফাইন্যান্স শেখা যায় কীভাবে
🔹 Saving Goals – নিজের লক্ষ্য অনুযায়ী সেভিংস সেট ও ট্র্যাক করা
🔹 Budget Reminders – বাজেটের বাইরে না যেতে স্মার্ট রিমাইন্ডার ব্যবহার
🔹 AI Chatbot – বাজেট ও খরচ বিষয়ক প্রশ্নের সহজ উত্তর
🔹 Quiz Section – শেখা বিষয়গুলো কুইজের মাধ্যমে যাচাই
🔹 History & Reports – খরচের রিপোর্ট ও হিস্ট্রি দেখা
🔹 Firebase Sync – ডেটা ক্লাউডে সেভ থাকে — ডিভাইস পাল্টালেও হারায় না
🔹 Accessibility Features – যারা ডিজিটালে নতুন, তাদের জন্য সহজ ইন্টারফেস ও বড় ফন্ট
''';

  final String videoId = 'REPLACE_THIS_ID'; // Replace with actual video ID later

  final Color contentColor = Color(0xFFE3F2FD); // Soft blue

  late YoutubePlayerController _controller;
  bool _completed = false;
  bool _showFull = false;

  @override
  void initState() {
    super.initState();
    _completed = LearnProgress.isVideoCompleted(lessonKey, 0);

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(autoPlay: false),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _markCompleted() async {
    await LearnProgress.markVideoCompleted(lessonKey, 0);
    setState(() {
      _completed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'How to Use the App',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
        ),
        iconTheme: const IconThemeData(color: Colors.blueAccent),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: contentColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                YoutubePlayer(controller: _controller),
                const SizedBox(height: 12),
                const Text(
                  'App Walkthrough',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  shortDescription,
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                ),
                const SizedBox(height: 8),
                if (_showFull)
                  Text(
                    fullDescription,
                    style: const TextStyle(color: Colors.black87, fontSize: 13),
                  ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showFull = !_showFull;
                    });
                  },
                  child: Text(
                    _showFull ? 'কম দেখান' : 'আরও দেখুন',
                    style: const TextStyle(color: Colors.blueAccent),
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: _completed ? null : _markCompleted,
                    icon: const Icon(LucideIcons.check),
                    label: Text(_completed ? 'Completed' : 'Mark as Done'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _completed ? Colors.green[300] : Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
