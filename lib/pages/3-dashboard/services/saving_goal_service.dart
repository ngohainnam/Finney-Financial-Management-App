import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finney/pages/3-dashboard/models/saving_goal_model.dart';

class SavingGoalService {
  final CollectionReference _goals = FirebaseFirestore.instance.collection(
    'savingGoals',
  );

  Future<void> addGoal(SavingGoal goal) {
    return _goals.doc(goal.id).set(goal.toMap());
  }

  Future<void> updateGoal(SavingGoal goal) {
    return _goals.doc(goal.id).update(goal.toMap());
  }

  Future<void> deleteGoal(String id) {
    return _goals.doc(id).delete();
  }

  Stream<List<SavingGoal>> getGoals() {
    return _goals.orderBy('createdAt', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map((doc) => SavingGoal.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
