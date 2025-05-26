import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:finney/shared/localization/locales.dart';

class QuizResult {
  final int score;
  final int totalQuestions;
  final DateTime timestamp;

  QuizResult({
    required this.score,
    required this.totalQuestions,
    required this.timestamp,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      score: json['score'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'totalQuestions': totalQuestions,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
