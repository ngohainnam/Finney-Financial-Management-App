import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../network/connectivity_service.dart';
import '../storage_manager.dart';

class SyncManager {
  final ConnectivityService _connectivityService;
  final StorageManager _storageManager;
  StreamSubscription<bool>? _connectivitySubscription;
  bool _syncInProgress = false;

  SyncManager(this._connectivityService, this._storageManager) {
    _initSyncListener();
  }

  void _initSyncListener() {
    _connectivitySubscription = _connectivityService.connectionStatus.listen((isConnected) {
      if (isConnected && !_syncInProgress) {
        syncAllData();
      }
    });
  }

  Future<void> syncAllData() async {
    if (_syncInProgress) return;
    
    _syncInProgress = true;
    debugPrint('Starting synchronization process...');
    
    try {
      await Future.wait([
        _storageManager.transactionService.syncPendingTransactions(),
        _storageManager.learningService.syncPendingProgress(),
      ]);
      debugPrint('Synchronization complete');
    } catch (e) {
      debugPrint('Error during synchronization: $e');
    } finally {
      _syncInProgress = false;
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
  }
}