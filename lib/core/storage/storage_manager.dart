import 'package:finney/core/network/connectivity_service.dart';
import 'package:finney/core/storage/cloud/service/chat_cloud_service.dart';
import 'package:finney/core/storage/cloud/service/user_cloud_service.dart';
import 'package:finney/core/storage/cloud/service/transaction_cloud_service.dart';
import 'package:finney/core/storage/cloud/service/learning_cloud_service.dart';

/// StorageManager is a singleton class that manages all storage services
/// and provides a unified access point to them.
class StorageManager {
  // Singleton instance
  static final StorageManager _instance = StorageManager._internal();
  factory StorageManager() => _instance;
  
  StorageManager._internal();
  
  // Core services
  late final ConnectivityService connectivityService;
  
  // Cloud services
  late final ChatCloudService chatCloudService;
  late final UserCloudService userCloudService;
  late final TransactionCloudService transactionService;
  late final LearningCloudService learningService;
  
  bool _initialized = false;
  
  /// Initialize all services
  Future<void> initialize() async {
    if (_initialized) return;
    
    // Initialize core services
    connectivityService = ConnectivityService();
    
    // Initialize cloud services with connectivity checks
    chatCloudService = ChatCloudService(
      connectivityService: connectivityService
    );
    
    userCloudService = UserCloudService(
      connectivityService: connectivityService
    );
    
    transactionService = TransactionCloudService(
      connectivityService: connectivityService
    );
    
    learningService = LearningCloudService(
      connectivityService: connectivityService
    );
    
    _initialized = true;
  }
  
  /// Check if we're connected to the internet
  bool get isConnected => connectivityService.isConnected;
  
  /// Stream of connectivity status changes
  Stream<bool> get connectionStatus => connectivityService.connectionStatus;
}