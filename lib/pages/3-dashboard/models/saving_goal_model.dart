import 'package:cloud_firestore/cloud_firestore.dart';

class SavingGoal {
  final String id;
  final String title;
  final double targetAmount;
  final double savedAmount;
  final DateTime targetDate;
  final String? description;
  final DateTime createdAt;

  SavingGoal({
    required String id,
    required String title,
    required double targetAmount,
    required double savedAmount,
    required DateTime targetDate,
    String? description,
    required DateTime createdAt,
  }) : this.id = id,
       this.title = title,
       this.targetAmount = targetAmount,
       this.savedAmount = savedAmount,
       this.targetDate = targetDate,
       this.description = description,
       this.createdAt = createdAt;

  // Helper getters
  double get progressPercentage => (savedAmount / targetAmount) * 100;
  bool get isCompleted => savedAmount >= targetAmount;
  int get daysRemaining => targetDate.difference(DateTime.now()).inDays;

  // CopyWith method for immutability
  SavingGoal copyWith({
    String? id,
    String? title,
    double? targetAmount,
    double? savedAmount,
    DateTime? targetDate,
    String? description,
    DateTime? createdAt,
  }) {
    return SavingGoal(
      id: id ?? this.id,
      title: title ?? this.title,
      targetAmount: targetAmount ?? this.targetAmount,
      savedAmount: savedAmount ?? this.savedAmount,
      targetDate: targetDate ?? this.targetDate,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'targetAmount': targetAmount,
      'savedAmount': savedAmount,
      'targetDate': Timestamp.fromDate(targetDate),
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create from Firestore data
  factory SavingGoal.fromMap(Map<String, dynamic> map) {
    return SavingGoal(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      targetAmount: (map['targetAmount'] ?? 0).toDouble(),
      savedAmount: (map['savedAmount'] ?? 0).toDouble(),
      targetDate: (map['targetDate'] as Timestamp).toDate(),
      description: map['description'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
