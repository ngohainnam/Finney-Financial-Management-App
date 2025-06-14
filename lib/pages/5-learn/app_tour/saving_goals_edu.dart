import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:finney/pages/5-learn/financial_learn/learn_progress.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/shared/localization/locales.dart';

class SavingGoalsEduPage extends StatefulWidget {
  const SavingGoalsEduPage({super.key});

  @override
  State<SavingGoalsEduPage> createState() => _SavingGoalsEduPageState();
}

class _SavingGoalsEduPageState extends State<SavingGoalsEduPage> {
  final String lessonKey = 'saving_goals_edu';
  final Color cardColor = Color(0xFFC5CAE9);

  final String videoId = '426pPV2zVzs';

  late YoutubePlayerController _controller;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(autoPlay: false),
    );
    _loadCompletionStatus();
  }

  void _loadCompletionStatus() async {
    final isDone = await LearnProgress.isVideoCompleted(lessonKey, 0);
    if (mounted) {
      setState(() => _completed = isDone);
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
        title: Text(
          LocaleData.savingGoals.getString(context),
          style: const TextStyle(color: Colors.blueAccent),
        ),
        iconTheme: const IconThemeData(color: Colors.blueAccent),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 5),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                YoutubePlayer(controller: _controller),
                const SizedBox(height: 12),
                Text(
                  LocaleData.savingGoalheading.getString(context),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  LocaleData.savingGoalSubtitled.getString(context),
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: _completed ? null : _markAsDone,
                    icon: const Icon(Icons.check),
                    label: Text(
                      _completed
                          ? LocaleData.completed.getString(context)
                          : LocaleData.tourMarkDone.getString(context),
                    ),
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
