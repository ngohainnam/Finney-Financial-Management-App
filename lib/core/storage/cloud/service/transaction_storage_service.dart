import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finney/core/storage/local/models/transaction/transaction_model.dart';
import '../firebase_storage_service.dart';

class TransactionCloudService {
  final FirebaseStorageService _storage;
  final String _collection = 'transactions';
  
  TransactionCloudService(this._storage);
  
  // Get all transactions
  Future<List<TransactionModel>> getAllTransactions() async {
    final documentsData = await _storage.getCollection(_collection);
    
    return documentsData.map((data) {
      return TransactionModel.fromMap(data['id'] as String, data);
    }).toList();
  }
  
  // Get transactions filtered by date range and/or category
  Future<List<TransactionModel>> getFilteredTransactions({
    DateTime? startDate,
    DateTime? endDate,
    String? category,
    String? transactionType,  // Income or expense
  }) async {
    // We need to build the query here and then use it with a public method of FirebaseStorageService
    return _storage.queryCollection(
      _collection,
      queryBuilder: (ref) {
        Query query = ref.orderBy('date', descending: true);
        
        if (startDate != null) {
          query = query.where('date', isGreaterThanOrEqualTo: startDate.toIso8601String());
        }
        
        if (endDate != null) {
          query = query.where('date', isLessThanOrEqualTo: endDate.toIso8601String());
        }
        
        if (category != null && category.isNotEmpty) {
          query = query.where('category', isEqualTo: category);
        }
        
        // Filter by transaction type based on amount sign, if specified
        if (transactionType != null && transactionType.isNotEmpty) {
          if (transactionType == 'income') {
            query = query.where('amount', isGreaterThan: 0);
          } else if (transactionType == 'expense') {
            query = query.where('amount', isLessThan: 0);
          }
        }
        
        return query;
      }
    ).then((documents) => documents.map((data) => 
      TransactionModel.fromMap(data['id'] as String, data)
    ).toList());
  }
  
  // Stream transactions for real-time updates
  Stream<List<TransactionModel>> streamTransactions({
    DateTime? startDate,
    DateTime? endDate,
    String? category,
    String? transactionType,  // Income or expense
  }) {
    return _storage.streamCollection(
      _collection,
      queryBuilder: (ref) {
        Query query = ref.orderBy('date', descending: true);
        
        if (startDate != null) {
          query = query.where('date', isGreaterThanOrEqualTo: startDate.toIso8601String());
        }
        
        if (endDate != null) {
          query = query.where('date', isLessThanOrEqualTo: endDate.toIso8601String());
        }
        
        if (category != null && category.isNotEmpty) {
          query = query.where('category', isEqualTo: category);
        }
        
        // Filter by transaction type based on amount sign, if specified
        if (transactionType != null && transactionType.isNotEmpty) {
          if (transactionType == 'income') {
            query = query.where('amount', isGreaterThan: 0);
          } else if (transactionType == 'expense') {
            query = query.where('amount', isLessThan: 0);
          }
        }
        
        return query;
      },
    ).map((documents) => documents.map(
      (data) => TransactionModel.fromMap(data['id'] as String, data)
    ).toList());
  }
  
  // Add a new transaction
  Future<String> addTransaction(TransactionModel transaction) async {
    final docId = await _storage.addDocument(_collection, transaction.toMap());
    return docId;
  }
  
  // Update an existing transaction
  Future<void> updateTransaction(TransactionModel transaction) async {
    if (transaction.id == null) throw Exception('Transaction ID is required for update');
    
    await _storage.updateDocument(
      _collection,
      transaction.id!,
      transaction.toMap(),
    );
  }
  
  // Delete a transaction
  Future<void> deleteTransaction(String transactionId) async {
    await _storage.deleteDocument(_collection, transactionId);
  }
  
  // Get transaction summary (totals by type)
  Future<Map<String, double>> getTransactionSummary({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final transactions = await getFilteredTransactions(
      startDate: startDate,
      endDate: endDate,
    );
    
    double income = 0;
    double expense = 0;
    
    for (var transaction in transactions) {
      if (transaction.amount > 0) {
        income += transaction.amount;
      } else if (transaction.amount < 0) {
        expense += transaction.amount.abs();  // Use abs() to make expense positive
      }
    }
    
    return {
      'income': income,
      'expense': expense,
      'balance': income - expense,
    };
  }
  
  // Get spending by category
  Future<Map<String, double>> getSpendingByCategory({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final transactions = await getFilteredTransactions(
      startDate: startDate,
      endDate: endDate,
      transactionType: 'expense',  // Only expenses (negative amounts)
    );
    
    final categoryMap = <String, double>{};
    
    for (var transaction in transactions) {
      final category = transaction.category;
      final currentAmount = categoryMap[category] ?? 0;
      categoryMap[category] = currentAmount + transaction.amount.abs();  // Use abs() to make values positive
    }
    
    return categoryMap;
  }
}