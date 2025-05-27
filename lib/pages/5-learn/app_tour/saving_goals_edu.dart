import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:finney/pages/5-learn/financial_learn/learn_progress.dart';

class SavingGoalsEduPage extends StatefulWidget {
  const SavingGoalsEduPage({super.key});

  @override
  State<SavingGoalsEduPage> createState() => _SavingGoalsEduPageState();
}

class _SavingGoalsEduPageState extends State<SavingGoalsEduPage> {
  final String lessonKey = 'saving_goals_edu';
  final Color cardColor = Color(0xFFC5CAE9); 

  final String title = 'Setting Up Saving Goals';
  final String description =
      'Learn how to set, track, and achieve your personal savings goals using the app’s built-in features.';

  late YoutubePlayerController _controller;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'dQw4w9WgXcQ',
      flags: const YoutubePlayerFlags(autoPlay: false),
    );
    _loadCompletionStatus();
  }

  Future<void> _loadCompletionStatus() async {
    final isCompleted = await LearnProgress.isVideoCompleted(lessonKey, 0);
    if (mounted) {
      setState(() {
        _completed = isCompleted;
      });
    }
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
        title: const Text('Saving Goals', style: TextStyle(color: Colors.blueAccent)),
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
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Text(description, style: const TextStyle(fontSize: 14, color: Colors.black54)),
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
