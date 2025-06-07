import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finney/shared/widgets/common/snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finney/core/storage/cloud/models/saving_goal_model.dart';
import 'package:finney/core/storage/cloud/models/transaction_model.dart';
import 'package:finney/core/storage/cloud/service/transaction_cloud_service.dart';
import 'package:finney/core/storage/storage_manager.dart';
import 'package:flutter/material.dart';

class SavingGoalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final TransactionCloudService _transactionService;

  SavingGoalService() {
    _transactionService = StorageManager().transactionService;
  }

  CollectionReference get _goalsCollection {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return _firestore.collection('users').doc(user.uid).collection('goals');
  }

  // Add or update a goal (uses set for both operations)
  Future<void> saveGoal(SavingGoal goal) async {
    try {
      await _goalsCollection.doc(goal.id).set(goal.toMap());
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
    try {
      await _goalsCollection.doc(goalId).update(fields);
    } catch (e) {
      debugPrint('Error updating goal fields: $e');
      rethrow;
    }
  }

  // Delete a goal
  Future<void> deleteGoal(String goalId) async {
    try {
      await _goalsCollection.doc(goalId).delete();
    } catch (e) {
      debugPrint('Error deleting goal: $e');
      rethrow;
    }
  }

  // Get all goals ordered by creation date (newest first)
  Stream<List<SavingGoal>> getGoals() {
    try {
      return _goalsCollection
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => SavingGoal.fromMap(doc.data() as Map<String, dynamic>))
                .toList(),
          );
    } catch (e) {
      debugPrint('Error getting goals: $e');
      return Stream.value([]);
    }
  }

  // Get a single goal by ID
  Future<SavingGoal?> getGoal(String goalId) async {
    try {
      final doc = await _goalsCollection.doc(goalId).get();
      return doc.exists
          ? SavingGoal.fromMap(doc.data() as Map<String, dynamic>)
          : null;
    } catch (e) {
      debugPrint('Error getting goal: $e');
      return null;
    }
  }

  // Get only active goals (not completed)
  Stream<List<SavingGoal>> getActiveGoals() {
    try {
      return _goalsCollection
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map(
            (snapshot) => snapshot.docs
                .map((doc) => SavingGoal.fromMap(doc.data() as Map<String, dynamic>))
                .where((goal) => goal.savedAmount < goal.targetAmount)
                .toList(),
          );
    } catch (e) {
      debugPrint('Error getting active goals: $e');
      return Stream.value([]);
    }
  }

  // Get current balance from transactions
  Future<double> getCurrentBalance() async {
    try {
      final transactions = await _transactionService.getAllTransactions();
      return transactions.fold<double>(0.0, (total, transaction) => total + transaction.amount);
    } catch (e) {
      debugPrint('Error calculating current balance: $e');
      return 0.0;
    }
  }

  // Add amount to savedAmount field with balance check
  Future<bool> addToSavings(String goalId, double amount, BuildContext context) async {
    try {
      final currentBalance = await getCurrentBalance();

      if (currentBalance < amount) {
        if (context.mounted) {
          AppSnackBar.showError(
            context,
            message: 'Not enough balance to save this amount',
          );
        }
        return false;
      }

      final goalDoc = await _goalsCollection.doc(goalId).get();
      if (!goalDoc.exists) {
        if (context.mounted) {
          AppSnackBar.showError(
            context,
            message: 'Savings goal not found',
          );
        }
        return false;
      }

      final goal = SavingGoal.fromMap(goalDoc.data() as Map<String, dynamic>);
      final remainingAmount = goal.targetAmount - goal.savedAmount;
      if (amount > remainingAmount) {
        if (context.mounted) {
          AppSnackBar.showError(
            context,
            message: 'Amount exceeds remaining target. Maximum you can add is ${remainingAmount.toStringAsFixed(2)}',
          );
        }
        return false;
      }

      final transaction = TransactionModel(
        category: 'Savings',
        amount: -amount,
        date: DateTime.now(),
        description: 'Transfer to savings goal',
      );

      await _transactionService.addTransaction(transaction);

      await _goalsCollection.doc(goalId).update({
        'savedAmount': FieldValue.increment(amount),
        'lastContribution': DateTime.now().toIso8601String(),
      });

      if (context.mounted) {
        AppSnackBar.showSuccess(
          context,
          message: 'Successfully added to savings goal',
        );
      }

      return true;
    } catch (e) {
      debugPrint('Error adding to savings: $e');
      if (context.mounted) {
        AppSnackBar.showError(
          context,
          message: 'Failed to add to savings: ${e.toString()}',
        );
      }
      return false;
    }
  }

  // Check if a goal is completed
  Future<bool> isGoalCompleted(String goalId) async {
    try {
      final goal = await getGoal(goalId);
      if (goal == null) return false;
      return goal.savedAmount >= goal.targetAmount;
    } catch (e) {
      debugPrint('Error checking goal completion: $e');
      return false;
    }
  }

  // Complete a goal and return funds to balance
  Future<bool> completeGoal(String goalId, BuildContext context) async {
    try {
      final goal = await getGoal(goalId);
      if (goal == null) {
        if (context.mounted) {
          AppSnackBar.showError(context, message: 'Goal not found');
        }
        return false;
      }

      final transaction = TransactionModel(
        category: 'Savings',
        amount: goal.savedAmount,
        date: DateTime.now(),
        description: 'Completed savings goal',
      );

      await _transactionService.addTransaction(transaction);

      await _goalsCollection.doc(goalId).update({
        'isCompleted': true,
        'completedAt': DateTime.now().toIso8601String(),
      });

      if (context.mounted) {
        AppSnackBar.showSuccess(
          context,
          message: 'Congratulations! Savings goal completed!',
        );
      }

      return true;
    } catch (e) {
      debugPrint('Error completing goal: $e');
      if (context.mounted) {
        AppSnackBar.showError(
          context,
          message: 'Failed to complete goal: ${e.toString()}',
        );
      }
      return false;
    }
  }
}