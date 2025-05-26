import 'package:finney/core/storage/storage_manager.dart';
import 'package:finney/core/storage/cloud/service/learning_cloud_service.dart';

class LearnProgress {
  static final LearningCloudService _learningService = StorageManager().learningService;

  static Future<void> markVideoCompleted(String lessonKey, int videoIndex) async {
    await _learningService.markVideoCompleted(lessonKey, videoIndex);
  }

  static Future<bool> isVideoCompleted(String lessonKey, int videoIndex) async {
    return await _learningService.isVideoCompleted(lessonKey, videoIndex);
  }

  static Future<int> getCompletedCount(String lessonKey, int totalVideos) async {
    return await _learningService.getCompletedCount(lessonKey, totalVideos);
  }

  static Future<bool> isLessonCompleted(String lessonKey, int totalVideos) async {
    return await _learningService.isLessonCompleted(lessonKey, totalVideos);
  }

  static Future<void> resetAll(List<String> lessonKeys) async {
    await _learningService.resetAllLessons(lessonKeys);
  }

  static Stream<Map<String, bool>> streamLessonProgress(String lessonKey) {
    return _learningService.streamLessonProgress(lessonKey);
  }
}
