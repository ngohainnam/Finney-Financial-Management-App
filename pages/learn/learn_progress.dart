import 'package:hive_flutter/hive_flutter.dart';

class LearnProgress {
  static final _box = Hive.box('learning_progress');


  static Future<void> markVideoCompleted(String lessonKey, int videoIndex) async {
    final data = Map<String, bool>.from(_box.get(lessonKey, defaultValue: {}));
    data[videoIndex.toString()] = true;
    await _box.put(lessonKey, data);
  }


  static bool isVideoCompleted(String lessonKey, int videoIndex) {
    final data = Map<String, bool>.from(_box.get(lessonKey, defaultValue: {}));
    return data[videoIndex.toString()] ?? false;
  }


  static int getCompletedCount(String lessonKey, int totalVideos) {
    final data = Map<String, bool>.from(_box.get(lessonKey, defaultValue: {}));
    return List.generate(totalVideos, (i) => i)
        .where((index) => data[index.toString()] == true)
        .length;
  }


  static bool isLessonCompleted(String lessonKey, int totalVideos) {
    return getCompletedCount(lessonKey, totalVideos) == totalVideos;
  }


  static void resetAll(List<String> lessonKeys) {
    for (final key in lessonKeys) {
      _box.delete(key);
    }
  }
}
