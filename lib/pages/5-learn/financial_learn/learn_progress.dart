import 'package:finney/core/storage/storage_manager.dart';
import 'package:finney/core/storage/cloud/service/learning_cloud_service.dart';

/// LearnProgress class that uses cloud storage instead of local Hive storage
class LearnProgress {
  // Get the singleton instance of LearningCloudService
  static final LearningCloudService _learningService = 
      StorageManager().learningService;

  /// Mark a video as completed
  static Future<void> markVideoCompleted(String lessonKey, int videoIndex) async {
    await _learningService.markVideoCompleted(lessonKey, videoIndex);
  }

  /// Check if a video is completed
  static Future<bool> isVideoCompleted(String lessonKey, int videoIndex) async {
    return await _learningService.isVideoCompleted(lessonKey, videoIndex);
  }

  /// Get the count of completed videos for a lesson
  static Future<int> getCompletedCount(String lessonKey, int totalVideos) async {
    return await _learningService.getCompletedCount(lessonKey, totalVideos);
  }

  /// Check if an entire lesson is completed
  static Future<bool> isLessonCompleted(String lessonKey, int totalVideos) async {
    return await _learningService.isLessonCompleted(lessonKey, totalVideos);
  }

  /// Reset all progress for specified lessons
  static Future<void> resetAll(List<String> lessonKeys) async {
    await _learningService.resetAllLessons(lessonKeys);
  }

  /// Get a stream of lesson progress updates
  static Stream<Map<String, bool>> streamLessonProgress(String lessonKey) {
    return _learningService.streamLessonProgress(lessonKey);
  }
}