import 'package:hive/hive.dart';

part 'quiz_result_model.g.dart';

@HiveType(typeId: 3) // Changed to a unique ID to avoid Hive conflict
class QuizResult extends HiveObject {
  @HiveField(0)
  final int score;

  @HiveField(1)
  final int totalQuestions;

  @HiveField(2)
  final DateTime timestamp;

  QuizResult({
    required this.score,
    required this.totalQuestions,
    required this.timestamp,
  });
}
