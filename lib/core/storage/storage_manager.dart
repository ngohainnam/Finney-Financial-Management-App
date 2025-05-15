import 'package:finney/core/service/chat_service.dart';
import 'package:finney/core/service/learning_service.dart';
import 'package:finney/core/service/transaction_service.dart';
import 'package:finney/core/storage/cloud/service/learning_cloud_service.dart';
import 'package:finney/core/storage/cloud/service/transaction_storage_service.dart';
import 'package:finney/core/storage/local/models/quiz/quiz_result_model.dart';
import 'package:finney/core/storage/local/models/transaction/transaction_model.dart';
import 'package:finney/core/storage/local/models/user/user_model.dart';
import 'package:finney/core/storage/local/service/learning_local_service.dart';
import 'package:finney/core/storage/local/service/transaction_local_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../network/connectivity_service.dart';
import 'local/hive_storage_service.dart';
import 'cloud/firebase_storage_service.dart';

class StorageManager {
  static final StorageManager _instance = StorageManager._internal();
  factory StorageManager() => _instance;
  
  StorageManager._internal();
  
  late HiveStorageService hiveStorage;
  late FirebaseStorageService firebaseStorage;
  late ConnectivityService connectivityService;
  
  late ChatService chatService;
  late TransactionService transactionService;
  late LearningService learningService;
  
  bool _initialized = false;
  
  Future<void> initialize() async {
    if (_initialized) return;
    
    // Initialize network connectivity
    connectivityService = ConnectivityService();
    
    // Initialize Hive if not already done
    try {
      await Hive.initFlutter();
    } catch (e) {
      // Hive already initialized, ignore
    }
    
    // Register adapters
    _registerAdapters();
    
    // Initialize storage services
    hiveStorage = HiveStorageService();
    await hiveStorage.init();
    
    firebaseStorage = FirebaseStorageService();
    
    // Open boxes
    await _openBoxes();
    
    // Initialize ChatService (cloud storage only)
    chatService = ChatService(
      cloudService: ChatCloudService(), // No parameter needed
      connectivityService: connectivityService
    );
    
    transactionService = TransactionService(
      localService: TransactionLocalService(hiveStorage),
      cloudService: TransactionCloudService(firebaseStorage),
      connectivityService: connectivityService
    );
    
    learningService = LearningService(
      localService: LearningLocalService(hiveStorage),
      cloudService: LearningCloudService(firebaseStorage),
      connectivityService: connectivityService
    );
    
    _initialized = true;
  }
  
  void _registerAdapters() {
    // Register all Hive adapters here
    final adapters = {
      0: () => Hive.registerAdapter(UserModelAdapter()),
      1: () => Hive.registerAdapter(TransactionModelAdapter()),
      2: () => Hive.registerAdapter(QuizResultAdapter()),
    };
    
    // Register each adapter only if not already registered
    adapters.forEach((typeId, registerFn) {
      if (!Hive.isAdapterRegistered(typeId)) {
        registerFn();
      }
    });
  }
  
  Future<void> _openBoxes() async {
    // Open all required boxes
    try {
      // User data
      if (!Hive.isBoxOpen('userBox')) {
        await Hive.openBox<UserModel>('userBox');
      }
      
      // Transactions
      if (!Hive.isBoxOpen('transactions')) {
        await Hive.openBox<TransactionModel>('transactions');
      }
      
      // Learning & quiz
      if (!Hive.isBoxOpen('learning_progress')) {
        await Hive.openBox('learning_progress');
      }
      if (!Hive.isBoxOpen('quiz_results')) {
        await Hive.openBox<QuizResult>('quiz_results');
      }
      
      // Settings
      if (!Hive.isBoxOpen('appSettings')) {
        await Hive.openBox('appSettings');
      }
      if (!Hive.isBoxOpen('settings')) {
        await Hive.openBox('settings');
      }
      
      // Pending operations for sync
      if (!Hive.isBoxOpen('pendingTransactions')) {
        await Hive.openBox('pendingTransactions');
      }
      if (!Hive.isBoxOpen('pendingProgress')) {
        await Hive.openBox('pendingProgress');
      }
    } catch (e) {
      debugPrint('Error opening Hive boxes: $e');
    }
  }
}