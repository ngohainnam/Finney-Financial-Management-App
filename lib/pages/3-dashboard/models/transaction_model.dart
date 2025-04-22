import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:finney/pages/3-dashboard/utils/category.dart';

class TransactionModel {
  final String? id;
  final String name;
  final String category;
  final double amount;
  final DateTime date;
  final String? description;

  const TransactionModel({
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
      date: (map['date'] as Timestamp).toDate(),
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
}

class MonthlyExpense {
  final String month;
  final double amount;

  MonthlyExpense({
    required this.month,
    required this.amount,
  });
}
