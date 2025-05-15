import 'package:hive/hive.dart';

import '../hive_storage_service.dart';
import '../models/transaction/transaction_model.dart';

class TransactionLocalService {
  final HiveStorageService _storage;
  final String _boxName = 'transactions';

  TransactionLocalService(this._storage);

  Future<void> init() async {
    await _storage.getValue('init', boxName: _boxName);
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    final box = Hive.box<TransactionModel>(_boxName);
    return box.values.toList();
  }

  Future<void> saveTransaction(TransactionModel transaction) async {
    final box = Hive.box<TransactionModel>(_boxName);
    if (transaction.id == null) {
      // For new transactions, generate ID
      String id = DateTime.now().millisecondsSinceEpoch.toString();
      transaction.id = id;
      await box.put(id, transaction);
    } else {
      // Update existing transaction
      await box.put(transaction.id, transaction);
    }
  }

  Future<void> deleteTransaction(String transactionId) async {
    await _storage.removeValue(transactionId, boxName: _boxName);
  }

  Future<void> clearAllTransactions() async {
    await _storage.clear(boxName: _boxName);
  }
  
  Future<TransactionModel?> getTransaction(String id) async {
    return await _storage.getValue<TransactionModel>(id, boxName: _boxName);
  }
  
  Future<List<TransactionModel>> getRecentTransactions(int count) async {
    final box = Hive.box<TransactionModel>(_boxName);
    final allTransactions = box.values.toList();
    
    // Sort by date descending
    allTransactions.sort((a, b) => b.date.compareTo(a.date));
    
    // Return only the requested number or all if less
    return allTransactions.take(count).toList();
  }
}