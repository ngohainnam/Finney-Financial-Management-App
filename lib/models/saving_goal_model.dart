import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SavingGoal {
  final String id;
  final String name;
  final double targetAmount;
  final double savedAmount;
  final DateTime targetDate;
  final String description;

  SavingGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.savedAmount,
    required this.targetDate,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'targetAmount': targetAmount,
      'savedAmount': savedAmount,
      'targetDate': targetDate.toIso8601String(),
      'description': description,
    };
  }

  factory SavingGoal.fromMap(Map<String, dynamic> map) {
    return SavingGoal(
      id: map['id'],
      name: map['name'],
      targetAmount: map['targetAmount'],
      savedAmount: map['savedAmount'],
      targetDate: DateTime.parse(map['targetDate']),
      description: map['description'],
    );
  }
}
