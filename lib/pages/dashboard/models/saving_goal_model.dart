import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'saving_goal_model.g.dart';

@HiveType(typeId: 4)
class SavingGoal extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final double targetAmount;

  @HiveField(3)
  double savedAmount;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final DateTime targetDate;

  @HiveField(6)
  final String? description;

  @HiveField(7)
  bool isSynced;

  @HiveField(8)
  String? syncError;

  SavingGoal({
    required this.id,
    required this.title,
    required this.targetAmount,
    this.savedAmount = 0.0,
    required this.createdAt,
    required this.targetDate,
    this.description,
    this.isSynced = false,
    this.syncError,
  });

  // Helper getters
  double get progressPercentage => (savedAmount / targetAmount) * 100;
  bool get isCompleted => savedAmount >= targetAmount;
  int get daysRemaining => targetDate.difference(DateTime.now()).inDays;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'targetAmount': targetAmount,
      'savedAmount': savedAmount,
      'createdAt': createdAt,
      'targetDate': targetDate,
      'description': description ?? '',
      'isSynced': isSynced,
      'syncError': syncError,
    };
  }

  factory SavingGoal.fromMap(String docId, Map<String, dynamic> map) {
    return SavingGoal(
      id: docId,
      title: map['title'] ?? '',
      targetAmount: (map['targetAmount'] ?? 0.0).toDouble(),
      savedAmount: (map['savedAmount'] ?? 0.0).toDouble(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      targetDate: (map['targetDate'] as Timestamp).toDate(),
      description: map['description'],
      isSynced: map['isSynced'] ?? false,
      syncError: map['syncError'],
    );
  }

  SavingGoal copyWith({
    String? id,
    String? title,
    double? targetAmount,
    double? savedAmount,
    DateTime? createdAt,
    DateTime? targetDate,
    String? description,
    bool? isSynced,
    String? syncError,
  }) {
    return SavingGoal(
      id: id ?? this.id,
      title: title ?? this.title,
      targetAmount: targetAmount ?? this.targetAmount,
      savedAmount: savedAmount ?? this.savedAmount,
      createdAt: createdAt ?? this.createdAt,
      targetDate: targetDate ?? this.targetDate,
      description: description ?? this.description,
      isSynced: isSynced ?? this.isSynced,
      syncError: syncError ?? this.syncError,
    );
  }
}
