import 'package:finney/core/storage/cloud/models/learning_model.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finney/core/network/connectivity_service.dart';
class LearningCloudService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ConnectivityService _connectivityService;
  
  final String _progressCollection = 'learning_progress';
  final String _quizResultCollection = 'quiz_results';
  
  // Constructor that accepts connectivity service
  LearningCloudService({
    required ConnectivityService connectivityService,
    // This parameter is just for compatibility with StorageManager
    dynamic cloudService,
  }) : _connectivityService = connectivityService;
  
  // Check internet connectivity
  Future<void> _checkConnectivity() async {
    if (!_connectivityService.isConnected) {
      throw Exception('No internet connection available. Please check your connection and try again.');
    }
  }
  
  // Get user-specific collection reference
  CollectionReference _getUserCollection(String collection) {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found');
    }
    return _firestore.collection('users').doc(user.uid).collection(collection);
  }
  
  // Learning progress methods
  
  // Get progress for a specific lesson
  Future<Map<String, bool>> getLessonProgress(String lessonKey) async {
    try {
      await _checkConnectivity();
      
      final document = await _getUserCollection(_progressCollection).doc(lessonKey).get();
      if (!document.exists) {
        return {};
      }
      final data = document.data() as Map<String, dynamic>?;
      return data != null 
        ? Map<String, bool>.from(data['progress'] ?? {})
        : {};
    } catch (e) {
      debugPrint('Error getting lesson progress: $e');
      return {};
    }
  }
  
  // Mark a video as completed
  Future<void> markVideoCompleted(String lessonKey, int videoIndex) async {
    try {
      await _checkConnectivity();
      
      final currentProgress = await getLessonProgress(lessonKey);
      currentProgress[videoIndex.toString()] = true;
      
      await _getUserCollection(_progressCollection).doc(lessonKey).set(
        {'progress': currentProgress},
        SetOptions(merge: true),
      );
    } catch (e) {
      debugPrint('Error marking video as completed: $e');
      rethrow;
    }
  }
  
  // Check if a video is completed
  Future<bool> isVideoCompleted(String lessonKey, int videoIndex) async {
    try {
      await _checkConnectivity();
      
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
      await _checkConnectivity();
      
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
      await _checkConnectivity();
      
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
      if (!_connectivityService.isConnected) {
        return Stream.error('No internet connection available.');
      }
      
      return _getUserCollection(_progressCollection).doc(lessonKey)
        .snapshots()
        .map((doc) {
          if (!doc.exists) {
            return {};
          }
          final data = doc.data() as Map<String, dynamic>?;
          return data != null 
            ? Map<String, bool>.from(data['progress'] ?? {})
            : {};
        });
    } catch (e) {
      debugPrint('Error streaming lesson progress: $e');
      return Stream.value({});
    }
  }

    // Reset progress for multiple lessons
  Future<void> resetAllLessons(List<String> lessonKeys) async {
    await _checkConnectivity();
    
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');
      
      // Use a batch write for efficiency
      final batch = _firestore.batch();
      
      for (final key in lessonKeys) {
        final docRef = _firestore
            .collection('users')
            .doc(user.uid)
            .collection(_progressCollection)
            .doc(key);
            
        batch.set(docRef, {'progress': {}});
      }
      
      await batch.commit();
    } catch (e) {
      debugPrint('Error resetting lesson progress: $e');
      rethrow;
    }
  }
  
  // Quiz results methods
  
  // Save a quiz result
  Future<void> saveQuizResult(QuizResult result) async {
    try {
      await _checkConnectivity();
      
      await _getUserCollection(_quizResultCollection).add(result.toMap());
    } catch (e) {
      debugPrint('Error saving quiz result: $e');
      rethrow;
    }
  }
  
  // Get all quiz results
  Future<List<QuizResult>> getAllQuizResults() async {
    try {
      await _checkConnectivity();
      
      final snapshot = await _getUserCollection(_quizResultCollection)
          .orderBy('timestamp', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        return QuizResult.fromMap(
          doc.id, 
          doc.data() as Map<String, dynamic>
        );
      }).toList();
    } catch (e) {
      debugPrint('Error getting all quiz results: $e');
      return [];
    }
  }
  
  // Get quiz summary statistics
  Future<Map<String, dynamic>> getQuizSummary() async {
    try {
      await _checkConnectivity();
      
      final results = await getAllQuizResults();
      
      if (results.isEmpty) {
        return {'total': 0, 'average': 0.0, 'last': null};
      }
      
      int totalAttempts = results.length;
      double totalScore = results.fold(0.0, (accumulator, result) {
        return accumulator + result.percentageScore;
      });
      DateTime latestAttempt = results
          .map((result) => result.timestamp)
          .reduce((a, b) => a.isAfter(b) ? a : b);
      
      return {
        'total': totalAttempts,
        'average': totalScore / totalAttempts,
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
      await _checkConnectivity();
      
      // Get all documents and delete them in a batch
      final snapshot = await _getUserCollection(_quizResultCollection).get();
      
      // Use a batched write for better performance
      final batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
    } catch (e) {
      debugPrint('Error clearing quiz results: $e');
      rethrow;
    }
  }
  
  // Get a quiz result by ID
  Future<QuizResult?> getQuizResult(String id) async {
    try {
      await _checkConnectivity();
      
      final doc = await _getUserCollection(_quizResultCollection).doc(id).get();
      
      if (!doc.exists) {
        return null;
      }
      
      return QuizResult.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error getting quiz result: $e');
      return null;
    }
  }
  
  // Delete a specific quiz result
  Future<void> deleteQuizResult(String id) async {
    try {
      await _checkConnectivity();
      
      await _getUserCollection(_quizResultCollection).doc(id).delete();
    } catch (e) {
      debugPrint('Error deleting quiz result: $e');
      rethrow;
    }
  }
  
  // Stream all quiz results
  Stream<List<QuizResult>> streamQuizResults() {
    try {
      if (!_connectivityService.isConnected) {
        return Stream.error('No internet connection available.');
      }
      
      return _getUserCollection(_quizResultCollection)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs.map((doc) {
              return QuizResult.fromMap(
                doc.id, 
                doc.data() as Map<String, dynamic>
              );
            }).toList();
          });
    } catch (e) {
      debugPrint('Error streaming quiz results: $e');
      return Stream.value([]);
    }
  }
  
  // Get recent quiz results (limited number)
  Future<List<QuizResult>> getRecentQuizResults(int limit) async {
    try {
      await _checkConnectivity();
      
      final snapshot = await _getUserCollection(_quizResultCollection)
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();
      
      return snapshot.docs.map((doc) {
        return QuizResult.fromMap(
          doc.id, 
          doc.data() as Map<String, dynamic>
        );
      }).toList();
    } catch (e) {
      debugPrint('Error getting recent quiz results: $e');
      return [];
    }
  }
}