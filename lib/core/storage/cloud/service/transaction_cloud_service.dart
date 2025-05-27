import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finney/core/storage/cloud/models/transaction_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finney/core/network/connectivity_service.dart';

class TransactionCloudService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ConnectivityService _connectivityService;
  
  // Constructor that accepts connectivity service
  TransactionCloudService({
    required ConnectivityService connectivityService,
  }) : _connectivityService = connectivityService;
  
  // Check internet connectivity
  Future<void> _checkConnectivity() async {
    if (!_connectivityService.isConnected) {
      throw Exception('No internet connection available. Please check your connection and try again.');
    }
  }

  // Get the current user's transactions collection reference
  CollectionReference get _transactionsCollection {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found');
    }
    return _firestore.collection('users').doc(user.uid).collection('transactions');
  }

  // Add a new transaction
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await _checkConnectivity();
      
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      await _transactionsCollection.add(transaction.toMap());
    } catch (e) {
      debugPrint('Error adding transaction: $e');
      rethrow;
    }
  }

  // Get all transactions for the current user
  Stream<List<TransactionModel>> getTransactions() {
    try {
      if (!_connectivityService.isConnected) {
        return Stream.error('No internet connection available.');
      }
      
      return _transactionsCollection
          .orderBy('date', descending: true)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return TransactionModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      debugPrint('Error getting transactions stream: $e');
      return Stream.error(e);
    }
  }

  // Get current month's income
  Future<double> getCurrentMonthIncome() async {
    try {
      await _checkConnectivity();
      
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      DateTime now = DateTime.now();
      DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
      DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .where('date', isGreaterThanOrEqualTo: firstDayOfMonth)
          .where('date', isLessThanOrEqualTo: lastDayOfMonth)
          .where('amount', isGreaterThan: 0)
          .get();

      return snapshot.docs.fold<double>(0.0, (incomeSum, doc) {
        final data = doc.data() as Map<String, dynamic>;
        return incomeSum + (data['amount'] as num).toDouble();
      });
    } catch (e) {
      debugPrint('Error getting current month income: $e');
      rethrow;
    }
  }

  // Get current month's expenses
  Future<double> getCurrentMonthExpenses() async {
    try {
      await _checkConnectivity();
      
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      DateTime now = DateTime.now();
      DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
      DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .where('date', isGreaterThanOrEqualTo: firstDayOfMonth)
          .where('date', isLessThanOrEqualTo: lastDayOfMonth)
          .where('amount', isLessThan: 0)
          .get();

      return snapshot.docs.fold<double>(0.0, (expenseSum, doc) {
        final data = doc.data() as Map<String, dynamic>;
        return expenseSum + (data['amount'] as num).abs().toDouble();
      });
    } catch (e) {
      debugPrint('Error getting current month expenses: $e');
      rethrow;
    }
  }

  // Get weekly expenses
  Future<List<WeeklyExpense>> getWeeklyExpenses() async {
    try {
      await _checkConnectivity();
      
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      DateTime now = DateTime.now();
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      DateTime endOfWeek = startOfWeek.add(const Duration(days: 6));

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .where('date', isGreaterThanOrEqualTo: startOfWeek)
          .where('date', isLessThanOrEqualTo: endOfWeek)
          .where('amount', isLessThan: 0)
          .get();

      List<String> dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      Map<String, double> dayTotals = {for (var day in dayNames) day: 0.0};

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        DateTime txDate = (data['date'] as Timestamp).toDate();
        String dayName = dayNames[txDate.weekday - 1];
        dayTotals[dayName] = (dayTotals[dayName] ?? 0) + (data['amount'] as num).abs().toDouble();
      }

      return dayNames
          .map((day) => WeeklyExpense(day, dayTotals[day] ?? 0.0))
          .toList();
    } catch (e) {
      debugPrint('Error getting weekly expenses: $e');
      rethrow;
    }
  }

  // Get category expenses
  Future<List<CategoryExpense>> getCategoryExpenses() async {
    try {
      await _checkConnectivity();
      
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      DateTime now = DateTime.now();
      DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
      DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('transactions')
          .where('date', isGreaterThanOrEqualTo: firstDayOfMonth)
          .where('date', isLessThanOrEqualTo: lastDayOfMonth)
          .where('amount', isLessThan: 0)
          .get();

      Map<String, double> categoryTotals = {};

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        String category = data['category'];
        double amount = (data['amount'] as num).abs().toDouble();

        categoryTotals[category] = (categoryTotals[category] ?? 0) + amount;
      }

      return categoryTotals.entries
          .map((entry) => CategoryExpense(entry.key, entry.value))
          .toList();
    } catch (e) {
      debugPrint('Error getting category expenses: $e');
      rethrow;
    }
  }

  // Delete a transaction
  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _checkConnectivity();
      await _transactionsCollection.doc(transactionId).delete();
    } catch (e) {
      debugPrint('Error deleting transaction: $e');
      rethrow;
    }
  }

  // Update a transaction
  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      await _checkConnectivity();
      
      if (transaction.id == null) {
        throw ArgumentError('Transaction must have an ID to be updated');
      }

      await _transactionsCollection.doc(transaction.id).update(transaction.toMap());
    } catch (e) {
      debugPrint('Error updating transaction: $e');
      rethrow;
    }
  }

  // Get monthly expenses for the last 6 months
  Future<List<MonthlyExpense>> getMonthlyExpenses() async {
    try {
      await _checkConnectivity();
      
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      DateTime now = DateTime.now();
      List<MonthlyExpense> monthlyExpenses = [];

      for (int i = 0; i < 6; i++) {
        DateTime firstDayOfMonth = DateTime(now.year, now.month - i, 1);
        DateTime lastDayOfMonth = DateTime(now.year, now.month - i + 1, 0, 23, 59, 59);

        QuerySnapshot snapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('transactions')
            .where('date', isGreaterThanOrEqualTo: firstDayOfMonth)
            .where('date', isLessThanOrEqualTo: lastDayOfMonth)
            .where('amount', isLessThan: 0)
            .get();

        double totalExpense = snapshot.docs.fold<double>(0.0, (total, doc) {
          final data = doc.data() as Map<String, dynamic>;
          return total + (data['amount'] as num).abs().toDouble();
        });

        String monthName = DateFormat('MMM').format(firstDayOfMonth);
        monthlyExpenses.add(MonthlyExpense(month: monthName, amount: totalExpense));
      }

      return monthlyExpenses.reversed.toList();
    } catch (e) {
      debugPrint('Error getting monthly expenses: $e');
      rethrow;
    }
  }
  
  // Get all transactions (for use by RAG service)
  Future<List<TransactionModel>> getAllTransactions() async {
    try {
      await _checkConnectivity();
      
      QuerySnapshot snapshot = await _transactionsCollection
          .orderBy('date', descending: true)
          .get();
          
      return snapshot.docs.map((doc) {
        return TransactionModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      debugPrint('Error getting all transactions: $e');
      rethrow;
    }
  }
  
  // Get transaction by ID
  Future<TransactionModel?> getTransaction(String id) async {
    try {
      await _checkConnectivity();
      
      if (id.isEmpty) {
        throw ArgumentError('Transaction ID cannot be empty');
      }
      
      DocumentSnapshot doc = await _transactionsCollection.doc(id).get();
      
      if (!doc.exists) {
        return null;
      }
      
      return TransactionModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error getting transaction: $e');
      rethrow;
    }
  }
}