import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:finney/pages/3-dashboard/utils/category.dart';
import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 2)
class TransactionModel extends HiveObject {
  @HiveField(0)
  String? id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String category;
  
  @HiveField(3)
  final double amount;
  
  @HiveField(4)
  final DateTime date;
  
  @HiveField(5)
  final String? description;

  TransactionModel({
    this.id,
    required this.name,
    required this.category,
    required this.amount,
    required this.date,
    this.description,
  });

  // UI helper getters
  IconData get icon => CategoryUtils.getIconForCategory(category);
  Color get iconColor => CategoryUtils.getColorForCategory(category);
  bool get isIncome => amount > 0;

  // Database operations
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'amount': amount,
      'date': date,
      'description': description ?? '',
    };
  }

  factory TransactionModel.fromMap(String docId, Map<String, dynamic> map) {
    return TransactionModel(
      id: docId,
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      date: (map['date'] is Timestamp) 
          ? (map['date'] as Timestamp).toDate()
          : map['date'] ?? DateTime.now(),
      description: map['description'],
    );
  }

  TransactionModel copyWith({
    String? id,
    String? name,
    String? category,
    double? amount,
    DateTime? date,
    String? description,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }
}

// Analytics helper classes
class WeeklyExpense {
  final String day;
  final double amount;

  const WeeklyExpense(this.day, this.amount);
}

class CategoryExpense {
  final String name;
  final double amount;
  final Color color;
  final IconData icon;

  CategoryExpense(this.name, this.amount)
      : color = CategoryUtils.getColorForCategory(name),
        icon = CategoryUtils.getIconForCategory(name);

  get category => null;
}

class MonthlyExpense {
  final String month;
  final double amount;

  MonthlyExpense({
    required this.month,
    required this.amount,
  });
}
