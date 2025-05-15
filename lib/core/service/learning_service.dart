import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../network/connectivity_service.dart';
import '../storage/local/service/learning_local_service.dart';
import '../storage/cloud/service/learning_cloud_service.dart';
import '../storage/local/models/quiz/quiz_result_model.dart';

class LearningService {
  final LearningLocalService _localService;
  final LearningCloudService _cloudService;
  final ConnectivityService _connectivityService;
  final Uuid _uuid = Uuid();
  
  LearningService({
    required LearningLocalService localService,
    required LearningCloudService cloudService,
    required ConnectivityService connectivityService,
  }) : 
    _localService = localService,
    _cloudService = cloudService,
    _connectivityService = connectivityService;

  // ===== Learning Progress Methods =====
  
  // Get progress for a specific lesson
  Future<Map<String, bool>> getLessonProgress(String lessonKey) async {
    try {
      if (_connectivityService.isConnected) {
        // Online: Get progress from cloud
        return await _cloudService.getLessonProgress(lessonKey);
      } else {
        // Offline: Get progress from local storage
        return {}; // Implement local method to match cloud service
      }
    } catch (e) {
      debugPrint('Error getting lesson progress: $e');
      return {};
    }
  }
  
  // Mark a video as completed
  Future<void> markVideoCompleted(String lessonKey, int videoIndex) async {
    // Always save locally first
    await _localService.markVideoCompleted(lessonKey, videoIndex);
    
    if (_connectivityService.isConnected) {
      try {
        // If online, also save to cloud
        await _cloudService.markVideoCompleted(lessonKey, videoIndex);
      } catch (e) {
        // If cloud save fails, mark for future sync
        await _markProgressForSync(lessonKey, videoIndex);
        debugPrint('Video completion saved locally and marked for sync: $e');
      }
    } else {
      // If offline, mark for future sync
      await _markProgressForSync(lessonKey, videoIndex);
    }
  }
  
  // Check if a video is completed
  Future<bool> isVideoCompleted(String lessonKey, int videoIndex) async {
    try {
      if (_connectivityService.isConnected) {
        // Try cloud first when online
        return await _cloudService.isVideoCompleted(lessonKey, videoIndex);
      }
    } catch (e) {
      debugPrint('Error checking video completion from cloud: $e');
    }
    
    // Fallback to local
    return await _localService.isVideoCompleted(lessonKey, videoIndex);
  }
  
  // Get the count of completed videos in a lesson
  Future<int> getCompletedCount(String lessonKey, int totalVideos) async {
    try {
      if (_connectivityService.isConnected) {
        // Try cloud first when online
        return await _cloudService.getCompletedCount(lessonKey, totalVideos);
      }
    } catch (e) {
      debugPrint('Error getting completed count from cloud: $e');
    }
    
    // Fallback to local
    return await _localService.getCompletedCount(lessonKey, totalVideos);
  }
  
  // Check if all videos in a lesson are completed
  Future<bool> isLessonCompleted(String lessonKey, int totalVideos) async {
    try {
      if (_connectivityService.isConnected) {
        // Try cloud first when online
        return await _cloudService.isLessonCompleted(lessonKey, totalVideos);
      }
    } catch (e) {
      debugPrint('Error checking lesson completion from cloud: $e');
    }
    
    // Fallback to local
    return await _localService.isLessonCompleted(lessonKey, totalVideos);
  }
  
  // ===== Quiz Results Methods =====
  
  // Save a quiz result
  Future<void> saveQuizResult(QuizResult result) async {
    // Always save locally first
    await _localService.saveQuizResult(result);
    
    if (_connectivityService.isConnected) {
      try {
        // If online, also save to cloud
        await _cloudService.saveQuizResult(result);
      } catch (e) {
        // If cloud save fails, mark for future sync
        await _markQuizResultForSync(result);
        debugPrint('Quiz result saved locally and marked for sync: $e');
      }
    } else {
      // If offline, mark for future sync
      await _markQuizResultForSync(result);
    }
  }
  
  // Get all quiz results
  Future<List<QuizResult>> getAllQuizResults() async {
    try {
      if (_connectivityService.isConnected) {
        // Online: Get results from cloud
        return await _cloudService.getAllQuizResults();
      } else {
        // Offline: Get results from local storage
        return await _localService.getAllQuizResults();
      }
    } catch (e) {
      debugPrint('Error getting quiz results: $e');
      // Fallback to local if cloud fails
      return await _localService.getAllQuizResults();
    }
  }
  
  // Get quiz summary statistics
  Future<Map<String, dynamic>> getQuizSummary() async {
    try {
      if (_connectivityService.isConnected) {
        // Online: Get summary from cloud
        return await _cloudService.getQuizSummary();
      } else {
        // Offline: Get summary from local storage
        return await _localService.getQuizSummary();
      }
    } catch (e) {
      debugPrint('Error getting quiz summary: $e');
      // Fallback to local if cloud fails
      return await _localService.getQuizSummary();
    }
  }
  
  // Clear all quiz results
  Future<void> clearQuizResults() async {
    // Clear locally first
    await _localService.clearAllQuizResults();
    
    if (_connectivityService.isConnected) {
      try {
        // If online, also clear cloud
        await _cloudService.clearQuizResults();
      } catch (e) {
        // If cloud clear fails, mark for future sync
        await _markClearQuizResultsForSync();
        debugPrint('Quiz results cleared locally and marked for sync clearance: $e');
      }
    } else {
      // If offline, mark for future clearance
      await _markClearQuizResultsForSync();
    }
  }
  
  // ===== Synchronization Methods =====
  
  // Mark video progress for future synchronization
  Future<void> _markProgressForSync(String lessonKey, int videoIndex) async {
    final pendingBox = await Hive.openBox('pendingUploads');
    final key = 'video_progress_${lessonKey}_$videoIndex';
    
    await pendingBox.put(key, {
      'type': 'video_progress',
      'lessonKey': lessonKey,
      'videoIndex': videoIndex,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  // Mark a quiz result for future synchronization
  Future<void> _markQuizResultForSync(QuizResult result) async {
    final pendingBox = await Hive.openBox('pendingUploads');
    final resultId = _uuid.v4();
    
    await pendingBox.put('quiz_result_$resultId', {
      'type': 'quiz_result',
      'score': result.score,
      'totalQuestions': result.totalQuestions,
      'timestamp': result.timestamp.toIso8601String(),
    });
  }
  
  // Mark quiz results clearance for future synchronization
  Future<void> _markClearQuizResultsForSync() async {
    final pendingBox = await Hive.openBox('pendingUploads');
    
    await pendingBox.put('clear_quiz_results', {
      'type': 'clear_quiz_results',
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  // Synchronize pending learning data to the cloud
  Future<void> syncPendingProgress() async {
    if (!_connectivityService.isConnected) return;
    
    final pendingBox = await Hive.openBox('pendingUploads');
    final pendingKeys = pendingBox.keys.where((key) => 
        key is String && (
          key.toString().startsWith('video_progress_') || 
          key.toString().startsWith('quiz_result_') || 
          key.toString() == 'clear_quiz_results'
        )
    );
    
    for (var key in pendingKeys) {
      final operation = pendingBox.get(key);
      
      try {
        if (key.toString().startsWith('video_progress_')) {
          final lessonKey = operation['lessonKey'];
          final videoIndex = operation['videoIndex'];
          await _cloudService.markVideoCompleted(lessonKey, videoIndex);
        } else if (key.toString().startsWith('quiz_result_')) {
          final quizResult = QuizResult(
            score: operation['score'],
            totalQuestions: operation['totalQuestions'],
            timestamp: DateTime.parse(operation['timestamp']),
          );
          await _cloudService.saveQuizResult(quizResult);
        } else if (key.toString() == 'clear_quiz_results') {
          await _cloudService.clearQuizResults();
        }
        
        // Remove from pending operations after successful sync
        await pendingBox.delete(key);
      } catch (e) {
        debugPrint('Error syncing learning operation $key: $e');
        // Leave in pendingBox to try again later
      }
    }
  }
}