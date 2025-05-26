import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:finney/pages/5-learn/financial_learn/learn_progress.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:flutter_localization/flutter_localization.dart' hide getString;




class BudgetReminderEduPage extends StatefulWidget {
  const BudgetReminderEduPage({super.key});

  @override
  State<BudgetReminderEduPage> createState() => _BudgetReminderEduPageState();
}

class _BudgetReminderEduPageState extends State<BudgetReminderEduPage> {
  final String lessonKey = 'budget_reminder_edu';

  final Color cardColor = Color(0xFFDCEDC8);

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
        title: Text(
          LocaleData.tourBudgetTitle.getString(context),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            decoration: BoxDecoration(
              color: cardColor,
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
                Text(
                  LocaleData.tourBudgetDesc.getString(context),
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
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
                      _completed ? Colors.green[300] : Colors.green,
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
