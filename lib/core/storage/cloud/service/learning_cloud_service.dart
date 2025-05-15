import 'package:flutter/foundation.dart';
import '../firebase_storage_service.dart';
import '../../local/models/quiz/quiz_result_model.dart';

class LearningCloudService {
  final FirebaseStorageService _storage;
  final String _progressCollection = 'learning_progress';
  final String _quizResultCollection = 'quiz_results';
  
  LearningCloudService(this._storage);
  
  // Learning progress methods
  
  // Get progress for a specific lesson
  Future<Map<String, bool>> getLessonProgress(String lessonKey) async {
    try {
      final document = await _storage.getDocument(_progressCollection, lessonKey);
      return document != null 
        ? Map<String, bool>.from(document['progress'] ?? {})
        : {};
    } catch (e) {
      debugPrint('Error getting lesson progress: $e');
      return {};
    }
  }
  
  // Mark a video as completed
  Future<void> markVideoCompleted(String lessonKey, int videoIndex) async {
    try {
      final currentProgress = await getLessonProgress(lessonKey);
      currentProgress[videoIndex.toString()] = true;
      
      await _storage.setDocument(
        _progressCollection,
        lessonKey,
        {'progress': currentProgress},
        merge: true,
      );
    } catch (e) {
      debugPrint('Error marking video as completed: $e');
      rethrow;
    }
  }
  
  // Check if a video is completed
  Future<bool> isVideoCompleted(String lessonKey, int videoIndex) async {
    try {
      final progress = await getLessonProgress(lessonKey);
      return progress[videoIndex.toString()] ?? false;
    } catch (e) {
      debugPrint('Error checking if video is completed: $e');
      return false;
    }
  }
  
  // Get the count of completed videos in a lesson
  Future<int> getCompletedCount(String lessonKey, int totalVideos) async {
    try {
      final progress = await getLessonProgress(lessonKey);
      return List.generate(totalVideos, (i) => i)
          .where((index) => progress[index.toString()] == true)
          .length;
    } catch (e) {
      debugPrint('Error getting completed count: $e');
      return 0;
    }
  }
  
  // Check if all videos in a lesson are completed
  Future<bool> isLessonCompleted(String lessonKey, int totalVideos) async {
    try {
      final completed = await getCompletedCount(lessonKey, totalVideos);
      return completed == totalVideos;
    } catch (e) {
      debugPrint('Error checking if lesson is completed: $e');
      return false;
    }
  }
  
  // Stream progress for a specific lesson
  Stream<Map<String, bool>> streamLessonProgress(String lessonKey) {
    try {
      return _storage.streamDocument(_progressCollection, lessonKey)
        .map((data) => data != null 
          ? Map<String, bool>.from(data['progress'] ?? {})
          : {});
    } catch (e) {
      debugPrint('Error streaming lesson progress: $e');
      return Stream.value({});
    }
  }
  
  // Quiz results methods
  
  // Save a quiz result
  Future<void> saveQuizResult(QuizResult result) async {
    try {
      final resultMap = {
        'score': result.score,
        'totalQuestions': result.totalQuestions,
        'timestamp': result.timestamp.toIso8601String(),
      };
      
      await _storage.addDocument(_quizResultCollection, resultMap);
    } catch (e) {
      debugPrint('Error saving quiz result: $e');
      rethrow;
    }
  }
  
  // Get all quiz results
  Future<List<QuizResult>> getAllQuizResults() async {
    try {
      final documentsData = await _storage.getCollection(_quizResultCollection);
      
      return documentsData.map((data) => QuizResult(
        score: data['score'] ?? 0,
        totalQuestions: data['totalQuestions'] ?? 0,
        timestamp: DateTime.parse(data['timestamp'] ?? DateTime.now().toIso8601String()),
      )).toList();
    } catch (e) {
      debugPrint('Error getting all quiz results: $e');
      return [];
    }
  }
  
  // Get quiz summary statistics
  Future<Map<String, dynamic>> getQuizSummary() async {
    try {
      final results = await getAllQuizResults();
      
      if (results.isEmpty) {
        return {'total': 0, 'average': 0.0, 'last': null};
      }
      
      int totalAttempts = results.length;
      double totalScore = results.fold(0.0, (sum, result) {
        return sum + (result.score / result.totalQuestions);
      });
      DateTime latestAttempt = results
          .map((result) => result.timestamp)
          .reduce((a, b) => a.isAfter(b) ? a : b);
      
      return {
        'total': totalAttempts,
        'average': (totalScore / totalAttempts) * 100,
        'last': latestAttempt.toIso8601String(),
      };
    } catch (e) {
      debugPrint('Error getting quiz summary: $e');
      return {'total': 0, 'average': 0.0, 'last': null};
    }
  }
  
  // Clear all quiz results
  Future<void> clearQuizResults() async {
    try {
      await _storage.clearCollection(_quizResultCollection);
    } catch (e) {
      debugPrint('Error clearing quiz results: $e');
      rethrow;
    }
  }
}