import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finney/pages/3-dashboard/models/saving_goal_model.dart';

class SavingGoalService {
  final CollectionReference _goalsCollection = FirebaseFirestore.instance
      .collection('goals');

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

  // Add amount to savedAmount field
  Future<void> addToSavings(String goalId, double amount) async {
    await _goalsCollection.doc(goalId).update({
      'savedAmount': FieldValue.increment(amount),
    });
  }
}
