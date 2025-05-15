import 'package:hive/hive.dart';

import '../hive_storage_service.dart';
import '../models/quiz/quiz_result_model.dart';

class LearningLocalService {
  final HiveStorageService _storage;
  final String _progressBoxName = 'learning_progress';
  final String _quizResultsBoxName = 'quiz_results';

  LearningLocalService(this._storage);

  Future<void> init() async {
    await _storage.getValue('init', boxName: _progressBoxName);
    await _storage.getValue('init', boxName: _quizResultsBoxName);
  }

  // Learning progress methods
  Future<void> markVideoCompleted(String lessonKey, int videoIndex) async {
    final data = Map<String, bool>.from(
      await _storage.getValue(lessonKey, boxName: _progressBoxName) ?? {});
    data[videoIndex.toString()] = true;
    await _storage.setValue(lessonKey, data, boxName: _progressBoxName);
  }

  Future<bool> isVideoCompleted(String lessonKey, int videoIndex) async {
    final data = Map<String, bool>.from(
      await _storage.getValue(lessonKey, boxName: _progressBoxName) ?? {});
    return data[videoIndex.toString()] ?? false;
  }

  Future<int> getCompletedCount(String lessonKey, int totalVideos) async {
    final data = Map<String, bool>.from(
      await _storage.getValue(lessonKey, boxName: _progressBoxName) ?? {});
    return List.generate(totalVideos, (i) => i)
        .where((index) => data[index.toString()] == true)
        .length;
  }

  Future<bool> isLessonCompleted(String lessonKey, int totalVideos) async {
    final completed = await getCompletedCount(lessonKey, totalVideos);
    return completed == totalVideos;
  }

  // Quiz results methods
  Future<void> saveQuizResult(QuizResult result) async {
    final box = Hive.box<QuizResult>(_quizResultsBoxName);
    await box.add(result);
  }

  Future<List<QuizResult>> getAllQuizResults() async {
    final box = Hive.box<QuizResult>(_quizResultsBoxName);
    return box.values.toList();
  }

  Future<void> clearAllQuizResults() async {
    await _storage.clear(boxName: _quizResultsBoxName);
  }
  
  Future<Map<String, dynamic>> getQuizSummary() async {
    final box = Hive.box<QuizResult>(_quizResultsBoxName);
    if (box.isEmpty) return {'total': 0, 'average': 0.0, 'last': null};

    int totalAttempts = box.length;
    double avgScore = 0;
    DateTime? last;

    for (int i = 0; i < box.length; i++) {
      final result = box.getAt(i);
      if (result != null) {
        avgScore += result.score / result.totalQuestions;
        if (last == null || result.timestamp.isAfter(last)) {
          last = result.timestamp;
        }
      }
    }

    return {
      'total': totalAttempts,
      'average': (avgScore / totalAttempts) * 100,
      'last': last,
    };
  }
}