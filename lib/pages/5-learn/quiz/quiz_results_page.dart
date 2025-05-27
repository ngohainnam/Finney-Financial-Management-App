import 'package:flutter/material.dart';
import '../../../core/storage/storage_manager.dart';
import '../../../core/storage/cloud/models/learning_model.dart';
import 'package:intl/intl.dart';

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
        _error = "Failed to load quiz results. Please try again.";
        _isLoading = false;
      });
      debugPrint('Error loading quiz results: $e');
    }
  }

  void _confirmReset(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Reset Results"),
        content: const Text("Are you sure you want to clear all quiz results?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Reset"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await StorageManager().learningService.clearQuizResults();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Quiz results have been cleared"))
        );
        _loadResults(); // Reload the empty list
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"))
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
    if (percent >= 0.8) return "🏆 Great Job!";
    if (percent >= 0.5) return "👍 Good Effort";
    return "🔄 Try Again";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("Quiz Results"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadResults,
            tooltip: "Refresh",
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
            onPressed: () => _confirmReset(context),
            tooltip: "Clear All Results",
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
              : _results.isEmpty
                  ? const Center(
                      child: Text(
                        "No quiz results found.",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _results.length,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      itemBuilder: (context, index) {
                        final result = _results[index];
                        final percent = result.score / result.totalQuestions;
                        final formattedDate =
                            DateFormat('MMM dd, yyyy – hh:mm a').format(result.timestamp.toLocal());

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
                                "Score: ${result.score} / ${result.totalQuestions}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                "Accuracy: ${result.percentageScore.toStringAsFixed(1)}%",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Date: $formattedDate",
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