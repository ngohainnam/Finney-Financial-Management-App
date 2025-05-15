import 'package:finney/core/network/connectivity_service.dart';
import 'package:finney/core/storage/cloud/service/transaction_storage_service.dart';
import 'package:finney/core/storage/local/models/transaction/transaction_model.dart';
import 'package:finney/core/storage/local/service/transaction_local_service.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class TransactionService {
  final TransactionLocalService _localService;
  final TransactionCloudService _cloudService;
  final ConnectivityService _connectivityService;
  final Uuid _uuid = Uuid();
  
  TransactionService({
    required TransactionLocalService localService,
    required TransactionCloudService cloudService,
    required ConnectivityService connectivityService,
  }) : 
    _localService = localService,
    _cloudService = cloudService,
    _connectivityService = connectivityService;

  // Get all transactions (combines cloud and local if needed)
  Future<List<TransactionModel>> getAllTransactions() async {
    try {
      if (_connectivityService.isConnected) {
        // Online: Get transactions from cloud
        final cloudTransactions = await _cloudService.getAllTransactions();
        return cloudTransactions;
      } else {
        // Offline: Get transactions from local storage
        return _localService.getAllTransactions();
      }
    } catch (e) {
      debugPrint('Error getting transactions: $e');
      // Fallback to local if cloud fails
      return _localService.getAllTransactions();
    }
  }
  
  // Stream transactions for live updates
  Stream<List<TransactionModel>> getTransactions({
    DateTime? startDate,
    DateTime? endDate,
    String? category,
  }) {
    if (_connectivityService.isConnected) {
      try {
        // Use cloud streaming when online
        return _cloudService.streamTransactions(
          startDate: startDate,
          endDate: endDate, 
          category: category
        );
      } catch (e) {
        debugPrint('Error streaming transactions from cloud: $e');
      }
    }
    
    // Fallback to local (no true streaming, just a future converted to stream)
    return Stream.fromFuture(_localService.getAllTransactions());
  }
  
  // Add a new transaction
  Future<void> addTransaction(TransactionModel transaction) async {
    final transactionId = _uuid.v4(); // Generate a unique ID
    transaction.id = transactionId;
    
    // Always save locally first for quick access
    await _localService.saveTransaction(transaction);
    
    if (_connectivityService.isConnected) {
      try {
        // If online, also save to cloud
        await _cloudService.addTransaction(transaction);
      } catch (e) {
        // If cloud save fails, mark for future sync
        await _markTransactionForSync(transaction);
        debugPrint('Transaction saved locally and marked for sync: $e');
      }
    } else {
      // If offline, mark for future sync
      await _markTransactionForSync(transaction);
    }
  }
  
  // Update an existing transaction
  Future<void> updateTransaction(TransactionModel transaction) async {
    if (transaction.id == null) {
      throw Exception('Cannot update a transaction without an ID');
    }
    
    // Always save locally first for quick access
    await _localService.saveTransaction(transaction);
    
    if (_connectivityService.isConnected) {
      try {
        // If online, also update in cloud
        await _cloudService.updateTransaction(transaction);
      } catch (e) {
        // If cloud save fails, mark for future sync
        await _markTransactionForSync(transaction, isUpdate: true);
        debugPrint('Transaction updated locally and marked for sync: $e');
      }
    } else {
      // If offline, mark for future sync
      await _markTransactionForSync(transaction, isUpdate: true);
    }
  }
  
  // Delete a transaction
  Future<void> deleteTransaction(TransactionModel transaction) async {
    if (transaction.id == null) return;
    
    // Delete locally first
    await _localService.deleteTransaction(transaction.id!);
    
    if (_connectivityService.isConnected) {
      try {
        // If online, also delete from cloud
        await _cloudService.deleteTransaction(transaction.id!);
      } catch (e) {
        // If cloud delete fails, mark for future sync
        await _markTransactionForDeletion(transaction.id!);
        debugPrint('Transaction deleted locally and marked for sync deletion: $e');
      }
    } else {
      // If offline, mark for future deletion
      await _markTransactionForDeletion(transaction.id!);
    }
  }
  
  // Get transaction by ID
  Future<TransactionModel?> getTransaction(String id) async {
    try {
      if (_connectivityService.isConnected) {
        // Try cloud first when online
        final transactions = await _cloudService.getFilteredTransactions();
        final found = transactions.firstWhere((t) => t.id == id, orElse: () => throw Exception('Not found'));
        return found;
      }
    } catch (e) {
      debugPrint('Error getting transaction from cloud: $e');
    }
    
    // Fallback to local
    return _localService.getTransaction(id);
  }
  
  // Get current month's income
  Future<double> getCurrentMonthIncome() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    
    final transactions = await getAllTransactions();
    
    return transactions
      .where((tx) => tx.amount > 0)
      .where((tx) => tx.date.isAfter(startOfMonth) && tx.date.isBefore(endOfMonth))
      .fold<double>(0.0, (sum, tx) => sum + tx.amount);
  }
  
  // Get current month's expenses
  Future<double> getCurrentMonthExpenses() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    
    final transactions = await getAllTransactions();
    
    return transactions
      .where((tx) => tx.amount < 0)
      .where((tx) => tx.date.isAfter(startOfMonth) && tx.date.isBefore(endOfMonth))
      .fold<double>(0.0, (sum, tx) => sum + tx.amount.abs());
  }
  
  // Get spending by category
  Future<Map<String, double>> getCategoryExpenses() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    
    final transactions = await getAllTransactions();
    final expenses = transactions
      .where((tx) => tx.amount < 0)
      .where((tx) => tx.date.isAfter(startOfMonth) && tx.date.isBefore(endOfMonth));
    
    final categoryMap = <String, double>{};
    
    for (var expense in expenses) {
      final category = expense.category;
      categoryMap[category] = (categoryMap[category] ?? 0) + expense.amount.abs();
    }
    
    return categoryMap;
  }
  
  // Mark a transaction for future synchronization
  Future<void> _markTransactionForSync(TransactionModel transaction, {bool isUpdate = false}) async {
    final pendingBox = await Hive.openBox('pendingUploads');
    final opType = isUpdate ? 'update_transaction' : 'add_transaction';
    
    await pendingBox.put('${opType}_${transaction.id}', {
      'id': transaction.id,
      'type': opType,
      'data': transaction.toMap(),
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  // Mark a transaction for future deletion
  Future<void> _markTransactionForDeletion(String transactionId) async {
    final pendingBox = await Hive.openBox('pendingUploads');
    
    await pendingBox.put('delete_transaction_$transactionId', {
      'id': transactionId,
      'type': 'delete_transaction',
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
  
  // Synchronize pending transactions to the cloud
  Future<void> syncPendingTransactions() async {
    if (!_connectivityService.isConnected) return;
    
    final pendingBox = await Hive.openBox('pendingUploads');
    final pendingKeys = pendingBox.keys.where((key) => 
        key is String && (
          key.toString().startsWith('add_transaction_') || 
          key.toString().startsWith('update_transaction_') || 
          key.toString().startsWith('delete_transaction_')
        )
    );
    
    for (var key in pendingKeys) {
      final operation = pendingBox.get(key);
      
      try {
        if (key.toString().startsWith('delete_transaction_')) {
          final transactionId = operation['id'];
          await _cloudService.deleteTransaction(transactionId);
        } else if (key.toString().startsWith('add_transaction_') || 
                   key.toString().startsWith('update_transaction_')) {
          // Extract transaction data
          final transactionId = operation['id'];
          final transactionData = Map<String, dynamic>.from(operation['data']);
          
          // Check if this transaction already exists in cloud (for adds)
          final exists = await _transactionExistsInCloud(transactionId);
          
          if (key.toString().startsWith('update_transaction_') || !exists) {
            // For updates, we always update
            // For adds, we only add if doesn't exist yet
            final transaction = TransactionModel(
              id: transactionId,
              name: transactionData['name'] ?? '',
              category: transactionData['category'] ?? '',
              amount: (transactionData['amount'] ?? 0.0).toDouble(),
              date: DateTime.parse(transactionData['date'] ?? DateTime.now().toIso8601String()),
              description: transactionData['description'],
            );
            
            if (key.toString().startsWith('update_transaction_')) {
              await _cloudService.updateTransaction(transaction);
            } else {
              await _cloudService.addTransaction(transaction);
            }
          }
        }
        
        // Remove from pending operations after successful sync
        await pendingBox.delete(key);
      } catch (e) {
        debugPrint('Error syncing transaction operation $key: $e');
        // Leave in pendingBox to try again later
      }
    }
  }
  
  // Check if a transaction exists in the cloud to avoid duplicates
  Future<bool> _transactionExistsInCloud(String transactionId) async {
    try {
      final transactions = await _cloudService.getAllTransactions();
      return transactions.any((tx) => tx.id == transactionId);
    } catch (e) {
      debugPrint('Error checking transaction existence: $e');
      return false;
    }
  }
}