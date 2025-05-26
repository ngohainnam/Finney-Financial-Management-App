import 'package:finney/shared/localization/locales.dart';
import 'package:finney/pages/5-learn/string_extension.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/storage/storage_manager.dart';
import '../../../core/storage/cloud/models/learning_model.dart';

class QuizResultsPage extends StatefulWidget {
  const QuizResultsPage({super.key});

  @override
  State<QuizResultsPage> createState() => _QuizResultsPageState();
}

class _QuizResultsPageState extends State<QuizResultsPage> {
  List<QuizResult> _results = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final results = await StorageManager().learningService.getAllQuizResults();

      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = LocaleData.quizLoadError.getString(context);
        _isLoading = false;
      });
    }
  }

  void _confirmReset(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(LocaleData.quizReset.getString(context)),
        content: Text(LocaleData.quizResetConfirm.getString(context)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(LocaleData.cancel.getString(context)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(LocaleData.reset.getString(context)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await StorageManager().learningService.clearQuizResults();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleData.quizResetSuccess.getString(context))),
        );
        _loadResults();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${LocaleData.error.getString(context)}: $e")),
        );
      }
    }
  }

  Color _getCardColor(double percent) {
    if (percent >= 0.8) return Colors.green.shade50;
    if (percent >= 0.5) return Colors.yellow.shade50;
    return Colors.red.shade50;
  }

  String _getMessage(double percent) {
    if (percent >= 0.8) return LocaleData.greatJob.getString(context);
    if (percent >= 0.5) return LocaleData.goodEffort.getString(context);
    return LocaleData.tryAgain.getString(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: Text(LocaleData.quizResults.getString(context)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadResults,
            tooltip: LocaleData.refresh.getString(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
            onPressed: () => _confirmReset(context),
            tooltip: LocaleData.clearAllResults.getString(context),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
        child: Text(_error!, style: const TextStyle(color: Colors.red)),
      )
          : _results.isEmpty
          ? Center(
        child: Text(
          LocaleData.quizNoResults.getString(context),
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      )
          : ListView.builder(
        itemCount: _results.length,
        padding: const EdgeInsets.symmetric(vertical: 16),
        itemBuilder: (context, index) {
          final result = _results[index];
          final percent = result.score / result.totalQuestions;
          final formattedDate = DateFormat(
            'MMM dd, yyyy – hh:mm a',
          ).format(result.timestamp.toLocal());

          final bgColor = _getCardColor(percent);
          final message = _getMessage(percent);

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${LocaleData.score.getString(context)}: ${result.score} / ${result.totalQuestions}",
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                Text(
                  "${LocaleData.accuracy.getString(context)}: ${result.percentageScore.toStringAsFixed(1)}%",
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  "${LocaleData.date.getString(context)}: $formattedDate",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
