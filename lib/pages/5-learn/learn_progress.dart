import 'package:hive_flutter/hive_flutter.dart';

class LearnProgress {
  static final _box = Hive.box('learning_progress');

  // Mark a specific video in a lesson as completed
  static Future<void> markVideoCompleted(String lessonKey, int videoIndex) async {
    final data = Map<String, bool>.from(_box.get(lessonKey, defaultValue: {}));
    data[videoIndex.toString()] = true;
    await _box.put(lessonKey, data);
  }

  // Check if a specific video is completed
  static bool isVideoCompleted(String lessonKey, int videoIndex) {
    final data = Map<String, bool>.from(_box.get(lessonKey, defaultValue: {}));
    return data[videoIndex.toString()] ?? false;
  }

  // Count how many videos in this lesson are completed
  static int getCompletedCount(String lessonKey, int totalVideos) {
    final data = Map<String, bool>.from(_box.get(lessonKey, defaultValue: {}));
    return List.generate(totalVideos, (i) => i)
        .where((index) => data[index.toString()] == true)
        .length;
  }

  // Check if the entire lesson is completed
  static bool isLessonCompleted(String lessonKey, int totalVideos) {
    return getCompletedCount(lessonKey, totalVideos) == totalVideos;
  }
}
