import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:finney/pages/learn/learn_progress.dart';

class SettingsEduPage extends StatefulWidget {
  const SettingsEduPage({super.key});

  @override
  State<SettingsEduPage> createState() => _SettingsEduPageState();
}

class _SettingsEduPageState extends State<SettingsEduPage> {
  final String lessonKey = 'settings_edu';
  final Color cardColor = Color(0xFFB39DDB);

  late YoutubePlayerController _controller;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'dQw4w9WgXcQ',
      flags: const YoutubePlayerFlags(autoPlay: false),
    );
    _completed = LearnProgress.isVideoCompleted(lessonKey, 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _markAsDone() async {
    await LearnProgress.markVideoCompleted(lessonKey, 0);
    setState(() => _completed = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Settings', style: TextStyle(color: Colors.blueAccent)),
        iconTheme: const IconThemeData(color: Colors.blueAccent),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                YoutubePlayer(controller: _controller),
                const SizedBox(height: 12),
                const Text(
                  'Customizing Settings',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Learn how to update language, notifications, and other app settings to personalize your experience.',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: _completed ? null : _markAsDone,
                    icon: const Icon(Icons.check),
                    label: Text(_completed ? 'Completed' : 'Mark as Done'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _completed ? Colors.green[300] : Colors.blueAccent,
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
