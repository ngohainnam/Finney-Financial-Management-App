import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:finney/pages/5-learn/financial_learn/learn_progress.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:flutter_localization/flutter_localization.dart';

class SavingMoneyEasy extends StatefulWidget {
  const SavingMoneyEasy({super.key});

  @override
  State<SavingMoneyEasy> createState() => _SavingMoneyEasyState();
}

class _SavingMoneyEasyState extends State<SavingMoneyEasy> {
  final String lessonKey = 'saving_money_easy';

  late List<YoutubePlayerController> _controllers;
  late List<bool> _completed;
  late List<Map<String, String>> _steps;

  final Color contentColor = Color(0xFFE1D5F0);

  @override
  void initState() {
    super.initState();
    _steps = [];
    _completed = [];
    _controllers = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _steps = [
      {
        'title': LocaleData.savingMoneyVideo1Title.getString(context),
        'description': LocaleData.savingMoneyVideo1Subtitle.getString(context),
        'videoId': 'owUZhBRgZso',
      },
      {
        'title': LocaleData.savingMoneyVideo2Title.getString(context),
        'description': LocaleData.savingMoneyVideo2Subtitle.getString(context),
        'videoId': 'BooMNcGZELQ',
      },
    ];

    _completed = List.generate(_steps.length, (_) => false);

    _controllers = _steps.map((step) {
      return YoutubePlayerController(
        initialVideoId: step['videoId']!,
        flags: const YoutubePlayerFlags(autoPlay: false),
      );
    }).toList();

    _loadCompletionStatus();
    setState(() {}); // optional UI refresh
  }

  Future<void> _loadCompletionStatus() async {
    for (int i = 0; i < _steps.length; i++) {
      final done = await LearnProgress.isVideoCompleted(lessonKey, i);
      if (mounted) {
        setState(() {
          _completed[i] = done;
        });
      }
    }
  }

  void _markStepCompleted(int index) async {
    await LearnProgress.markVideoCompleted(lessonKey, index);
    setState(() {
      _completed[index] = true;
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          LocaleData.savingMoneyEasy.getString(context),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.blueAccent),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, __) => const SizedBox(height: 24),
        itemCount: _steps.length,
        itemBuilder: (context, index) {
          final step = _steps[index];
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
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: _completed[index]
                        ? null
                        : () => _markStepCompleted(index),
                    icon: const Icon(LucideIcons.check),
                    label: Text(
                      _completed[index]
                          ? LocaleData.completed.getString(context)
                          : LocaleData.tourMarkDone.getString(context),
                    ),
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
