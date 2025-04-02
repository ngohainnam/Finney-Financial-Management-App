import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finney/pages/3-dashboard/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
      // Get current user
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      // Add to Firestore
      await _transactionsCollection.add(transaction.toMap());


      var box = await Hive.openBox<TransactionModel>('transactions');
      await box.add(transaction);

    } catch (e) {
      debugPrint('Error adding transaction: $e');
      rethrow;
    }
  }

  // Get all transactions for the current user
  Stream<List<TransactionModel>> getTransactions() {
    return _transactionsCollection
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return TransactionModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  // Get current month's income
  Future<double> getCurrentMonthIncome() async {
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
  }

  // Get current month's expenses
  Future<double> getCurrentMonthExpenses() async {
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
  }

  // Get weekly expenses
  Future<List<WeeklyExpenseData>> getWeeklyExpenses() async {
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
    Map<String, double> dayTotals = { for (var day in dayNames) day : 0.0 };

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      DateTime txDate = (data['date'] as Timestamp).toDate();
      String dayName = dayNames[txDate.weekday - 1];
      dayTotals[dayName] = (dayTotals[dayName] ?? 0) + (data['amount'] as num).abs().toDouble();
    }

    return dayNames.map((day) => WeeklyExpenseData(day, dayTotals[day] ?? 0.0)).toList();
  }

  // Get category expenses
  Future<List<CategoryExpenseData>> getCategoryExpenses() async {
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

    return categoryTotals.entries.map((entry) {
      CategoryInfo info = getCategoryInfo(entry.key);
      return CategoryExpenseData(
          entry.key,
          entry.value,
          info.color,
          info.icon
      );
    }).toList();
  }

  // Delete a transaction
  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _transactionsCollection.doc(transactionId).delete();
    } catch (e) {
      debugPrint('Error deleting transaction: $e');
      rethrow;
    }
  }

  // Update a transaction
  Future<void> updateTransaction(TransactionModel transaction) async {
    if (transaction.id == null) {
      throw ArgumentError('Transaction must have an ID to be updated');
    }

    try {
      await _transactionsCollection.doc(transaction.id).update(transaction.toMap());
    } catch (e) {
      debugPrint('Error updating transaction: $e');
      rethrow;
    }
  }

  // Helper to map category to icon and color
  CategoryInfo getCategoryInfo(String category) {
    switch (category) {
      case 'Shopping':
        return CategoryInfo(const Color(0xFFFF9800), Icons.shopping_bag);
      case 'Food':
        return CategoryInfo(const Color(0xFF2196F3), Icons.restaurant);
      case 'Entertainment':
        return CategoryInfo(const Color(0xFFE91E63), Icons.movie);
      case 'Transport':
        return CategoryInfo(const Color(0xFF4CAF50), Icons.directions_car);
      case 'Health':
        return CategoryInfo(const Color(0xFFF44336), Icons.medical_services);
      case 'Utilities':
        return CategoryInfo(const Color(0xFF9C27B0), Icons.phone);
      default:
        return CategoryInfo(const Color(0xFF9E9E9E), Icons.category_outlined);
    }
  }
}

class WeeklyExpenseData {
  final String day;
  final double amount;

  WeeklyExpenseData(this.day, this.amount);
}

class CategoryExpenseData {
  final String name;
  final double amount;
  final Color color;
  final IconData icon;

  CategoryExpenseData(this.name, this.amount, this.color, this.icon);
}

class CategoryInfo {
  final Color color;
  final IconData icon;

  CategoryInfo(this.color, this.icon);
}