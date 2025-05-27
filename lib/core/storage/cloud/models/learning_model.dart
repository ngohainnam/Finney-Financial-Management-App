import 'package:cloud_firestore/cloud_firestore.dart';

class QuizResult {
  final String? id;
  final int score;
  final int totalQuestions;
  final DateTime timestamp;

  QuizResult({
    this.id,
    required this.score,
    required this.totalQuestions,
    required this.timestamp,
  });

  // Create a copy with some fields updated
  QuizResult copyWith({
    String? id,
    int? score,
    int? totalQuestions,
    DateTime? timestamp,
  }) {
    return QuizResult(
      id: id ?? this.id,
      score: score ?? this.score,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      timestamp: timestamp ?? this.timestamp,
    );
  }
  
  // Convert to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'score': score,
      'totalQuestions': totalQuestions,
      'timestamp': timestamp,
    };
  }
  
  // Create from a Firestore document
  static QuizResult fromMap(String docId, Map<String, dynamic> map) {
    return QuizResult(
      id: docId,
      score: map['score'] ?? 0,
      totalQuestions: map['totalQuestions'] ?? 0,
      timestamp: (map['timestamp'] is Timestamp) 
          ? (map['timestamp'] as Timestamp).toDate() 
          : DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }
  
  // Calculate percentage score
  double get percentageScore {
    if (totalQuestions == 0) return 0.0;
    return (score / totalQuestions) * 100;
  }
  
  @override
  String toString() {
    return 'QuizResult(id: $id, score: $score, totalQuestions: $totalQuestions, timestamp: $timestamp)';
  }
}

class LessonProgress {
  final String lessonKey;
  final Map<String, bool> progress;
  
  LessonProgress({
    required this.lessonKey,
    required this.progress,
  });
  
  // Convert to a map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'lessonKey': lessonKey,
      'progress': progress,
    };
  }
  
  // Create from a Firestore document
  static LessonProgress fromMap(Map<String, dynamic> map) {
    return LessonProgress(
      lessonKey: map['lessonKey'] ?? '',
      progress: Map<String, bool>.from(map['progress'] ?? {}),
    );
  }
  
  // Check if a specific video is completed
  bool isVideoCompleted(int videoIndex) {
    return progress[videoIndex.toString()] ?? false;
  }
  
  // Get completed count
  int getCompletedCount(int totalVideos) {
    return List.generate(totalVideos, (i) => i)
        .where((index) => progress[index.toString()] == true)
        .length;
  }
  
  // Check if all videos are completed
  bool isCompleted(int totalVideos) {
    return getCompletedCount(totalVideos) == totalVideos;
  }
}