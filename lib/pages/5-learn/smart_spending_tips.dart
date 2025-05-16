import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'learn_progress.dart';

class SmartSpendingTips extends StatefulWidget {
  const SmartSpendingTips({super.key});

  @override
  State<SmartSpendingTips> createState() => _SmartSpendingTipsState();
}

class _SmartSpendingTipsState extends State<SmartSpendingTips> {
  final String lessonKey = 'smart_spending_tips';

  final List<Map<String, String>> steps = [
    {
      'title': 'Manage, Grow, Invest & Protect Money',
      'description':
          'No matter how much you earn, if you manage it well, grow it, invest it, and protect it, your future will be secure.',
      'videoId': 'Vwb07EXFgfA',
    },
    {
      'title': 'Smart Investment: Buy Land',
      'description':
          'Land is a safe and profitable investment. Check papers and location before you buy. It’s more flexible than flats or crypto.',
      'videoId': 'f-FMn43hR34',
    },
  ];

  final Color contentColor = Color(0xFFE0E7FA);

  late List<YoutubePlayerController> _controllers;
  late List<bool> _completed;

  @override
  void initState() {
    super.initState();

    _completed = List.generate(
      steps.length,
      (index) => LearnProgress.isVideoCompleted(lessonKey, index),
    );

    _controllers = steps.map((step) {
      return YoutubePlayerController(
        initialVideoId: step['videoId']!,
        flags: const YoutubePlayerFlags(autoPlay: false),
      );
    }).toList();
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _markStepCompleted(int index) async {
    await LearnProgress.markVideoCompleted(lessonKey, index);
    setState(() {
      _completed[index] = true;
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
          'Smart Spending Tips',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
        ),
        iconTheme: const IconThemeData(color: Colors.blueAccent),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, __) => const SizedBox(height: 24),
        itemCount: steps.length,
        itemBuilder: (context, index) {
          final step = steps[index];
          return Container(
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
                YoutubePlayer(controller: _controllers[index]),
                const SizedBox(height: 12),
                Text(
                  step['title']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  step['description']!,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: _completed[index]
                        ? null
                        : () => _markStepCompleted(index),
                    icon: const Icon(LucideIcons.check),
                    label: Text(_completed[index] ? 'Completed' : 'Mark as Done'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _completed[index]
                          ? Colors.green[300]
                          : Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
