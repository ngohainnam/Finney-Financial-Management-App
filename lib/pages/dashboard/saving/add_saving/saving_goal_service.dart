import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finney/pages/dashboard/models/saving_goal_model.dart';
import 'package:finney/pages/dashboard/models/transaction_model.dart';
import 'package:finney/pages/dashboard/transaction/transaction_services.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SavingGoalService {
  final CollectionReference _goalsCollection = FirebaseFirestore.instance
      .collection('goals');
  final TransactionService _transactionService = TransactionService();
  late Box<SavingGoal> _goalsBox;
  bool _isInitialized = false;

  Future<void> init() async {
    if (!_isInitialized) {
      _goalsBox = await Hive.openBox<SavingGoal>('saving_goals');
      _isInitialized = true;
    }
  }

  // Add or update a goal
  Future<void> saveGoal(SavingGoal goal) async {
    await init();
    
    try {
      await _goalsCollection.doc(goal.id).set(goal.toMap());
      await _goalsBox.put(goal.id, goal);
    } catch (e) {
      debugPrint('Error saving goal: $e');
      rethrow;
    }
  }

  // Update specific fields of a goal
  Future<void> updateGoalFields({
    required String goalId,
    required Map<String, dynamic> fields,
  }) async {
    await init();
    
    try {
      await _goalsCollection.doc(goalId).update(fields);
      final goal = _goalsBox.get(goalId);
      if (goal != null) {
        final updatedGoal = goal.copyWith(
          savedAmount: fields['savedAmount'] ?? goal.savedAmount,
        );
        await _goalsBox.put(goalId, updatedGoal);
      }
    } catch (e) {
      debugPrint('Error updating goal fields: $e');
      rethrow;
    }
  }

  // Delete a goal
  Future<void> deleteGoal(String goalId) async {
    await init();
    
    try {
      await _goalsCollection.doc(goalId).delete();
      await _goalsBox.delete(goalId);
    } catch (e) {
      debugPrint('Error deleting goal: $e');
      rethrow;
    }
  }

  // Get all goals ordered by creation date (newest first)
  Stream<List<SavingGoal>> getGoals() async* {
    await init();
    
    try {
      await for (final snapshot in _goalsCollection
          .orderBy('createdAt', descending: true)
          .snapshots()) {
        final goals = snapshot.docs.map((doc) {
          final goal = SavingGoal.fromMap(doc.id, doc.data() as Map<String, dynamic>);
          _goalsBox.put(doc.id, goal);
          return goal;
        }).toList();
        yield goals;
      }
    } catch (e) {
      debugPrint('Error getting goals: $e');
      yield _goalsBox.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
  }

  // Get a single goal by ID
  Future<SavingGoal?> getGoal(String goalId) async {
    await init();
    
    try {
      final doc = await _goalsCollection.doc(goalId).get();
      if (doc.exists) {
        final goal = SavingGoal.fromMap(doc.id, doc.data() as Map<String, dynamic>);
        await _goalsBox.put(doc.id, goal);
        return goal;
      }
    } catch (e) {
      debugPrint('Error getting goal: $e');
      return _goalsBox.get(goalId);
    }
    return null;
  }

  // Get goals that are not yet completed
  Stream<List<SavingGoal>> getActiveGoals() async* {
    await init();
    
    try {
      await for (final snapshot in _goalsCollection
          .where('savedAmount', isLessThan: 'targetAmount')
          .orderBy('savedAmount')
          .orderBy('createdAt', descending: true)
          .snapshots()) {
        final goals = snapshot.docs.map((doc) {
          final goal = SavingGoal.fromMap(doc.id, doc.data() as Map<String, dynamic>);
          _goalsBox.put(doc.id, goal);
          return goal;
        }).toList();
        yield goals;
      }
    } catch (e) {
      debugPrint('Error getting active goals: $e');
      yield _goalsBox.values
          .where((goal) => goal.savedAmount < goal.targetAmount)
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
  }

  // Add amount to savedAmount field with balance check
  Future<bool> addToSavings(String goalId, double amount) async {
    await init();
    
    try {
      // Get current balance
      final currentBalance = await _transactionService.getCurrentBalance();

      // Check if there's enough balance
      if (currentBalance < amount) {
        return false;
      }

      // Get the goal
      final goal = _goalsBox.get(goalId);
      if (goal == null) return false;

      // Check if amount exceeds remaining target
      final remainingAmount = goal.targetAmount - goal.savedAmount;
      if (amount > remainingAmount) {
        throw Exception('amount_exceeds_target');
      }

      // Create a transaction to deduct from balance
      final transaction = TransactionModel(
        name: 'Savings Transfer',
        category: 'Savings',
        amount: -amount,
        date: DateTime.now(),
        description: 'Transfer to savings goal',
      );

      // Add the transaction
      await _transactionService.addTransaction(transaction);

      // Update the savings goal
      await _goalsCollection.doc(goalId).update({
        'savedAmount': FieldValue.increment(amount),
      });

      final updatedGoal = goal.copyWith(
        savedAmount: goal.savedAmount + amount,
      );
      await _goalsBox.put(goalId, updatedGoal);

      return true;
    } catch (e) {
      debugPrint('Error adding to savings: $e');
      if (e.toString().contains('amount_exceeds_target')) {
        rethrow;
      }
      return false;
    }
  }
}
