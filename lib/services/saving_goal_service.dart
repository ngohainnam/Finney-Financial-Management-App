import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finney/models/saving_goal_model.dart';

class SavingGoalService {
  final CollectionReference _goals = FirebaseFirestore.instance.collection(
    'savingGoals',
  );

  Future<void> addGoal(SavingGoal goal) {
    return _goals.doc(goal.id).set(goal.toMap());
  }

  Stream<List<SavingGoal>> getGoals() {
    return _goals.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => SavingGoal.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
