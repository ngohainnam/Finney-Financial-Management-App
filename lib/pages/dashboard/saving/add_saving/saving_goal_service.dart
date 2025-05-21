import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finney/pages/dashboard/models/saving_goal_model.dart';
import 'package:finney/pages/dashboard/models/transaction_model.dart';
import 'package:finney/pages/dashboard/transaction/transaction_services.dart';
import 'package:flutter/foundation.dart';

class SavingGoalService {
  final CollectionReference _goalsCollection = FirebaseFirestore.instance
      .collection('goals');
  final TransactionService _transactionService = TransactionService();

  // Add or update a goal (uses set with merge for both operations)
  Future<void> saveGoal(SavingGoal goal) async {
    await _goalsCollection.doc(goal.id).set(goal.toMap());
  }

  // Update specific fields of a goal
  Future<void> updateGoalFields({
    required String goalId,
    required Map<String, dynamic> fields,
  }) async {
    await _goalsCollection.doc(goalId).update(fields);
  }

  // Delete a goal
  Future<void> deleteGoal(String goalId) async {
    await _goalsCollection.doc(goalId).delete();
  }

  // Get all goals ordered by creation date (newest first)
  Stream<List<SavingGoal>> getGoals() {
    return _goalsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) =>
                        SavingGoal.fromMap(doc.data() as Map<String, dynamic>),
                  )
                  .toList(),
        );
  }

  // Get a single goal by ID
  Future<SavingGoal?> getGoal(String goalId) async {
    final doc = await _goalsCollection.doc(goalId).get();
    return doc.exists
        ? SavingGoal.fromMap(doc.data() as Map<String, dynamic>)
        : null;
  }

  // Get goals that are not yet completed
  Stream<List<SavingGoal>> getActiveGoals() {
    return _goalsCollection
        .where('savedAmount', isLessThan: FieldPath.documentId)
        .orderBy('savedAmount')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) =>
                        SavingGoal.fromMap(doc.data() as Map<String, dynamic>),
                  )
                  .toList(),
        );
  }

  // Get current balance from transactions
  Future<double> getCurrentBalance() async {
    final transactions = await _transactionService.getTransactions().first;
    return transactions.fold<double>(0.0, (total, transaction) => total + transaction.amount);
  }

  // Add amount to savedAmount field with balance check
  Future<bool> addToSavings(String goalId, double amount) async {
    try {
      // Get current balance
      final currentBalance = await getCurrentBalance();

      // Check if there's enough balance
      if (currentBalance < amount) {
        return false; // Not enough balance
      }

      // Get the goal document
      final goalDoc = await _goalsCollection.doc(goalId).get();
      final goal = SavingGoal.fromMap(goalDoc.data() as Map<String, dynamic>);

      // Check if amount exceeds remaining target
      final remainingAmount = goal.targetAmount - goal.savedAmount;
      if (amount > remainingAmount) {
        throw Exception('amount_exceeds_target'); // Throw specific exception
      }

      // Create a transaction to deduct from balance
      final transaction = TransactionModel(
        name: 'Savings Transfer',
        category: 'Savings',
        amount: -amount, // Negative amount for expense
        date: DateTime.now(),
        description: 'Transfer to savings goal',
      );

      // Add the transaction first
      await _transactionService.addTransaction(transaction);

      // Update the savings goal
      await _goalsCollection.doc(goalId).update({
        'savedAmount': FieldValue.increment(amount),
      });

      return true; // Success
    } catch (e) {
      debugPrint('Error adding to savings: $e');
      if (e.toString().contains('amount_exceeds_target')) {
        rethrow;
      }
      return false; // Failed for other reasons
    }
  }
}
