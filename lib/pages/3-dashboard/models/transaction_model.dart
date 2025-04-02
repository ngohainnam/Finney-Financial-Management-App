import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TransactionModel {
  final String? id;
  final String name;
  final String category;
  final double amount;
  final DateTime date;
  final String? description;

  TransactionModel({
    this.id,
    required this.name,
    required this.category,
    required this.amount,
    required this.date,
    this.description,
  });

  // Convert TransactionModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'category': category,
      'amount': amount,
      'date': date,
      'description': description ?? '',
    };
  }

  // Create TransactionModel from Firestore document
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

  // For displaying transactions in the UI, similar to the original Transaction class
  TransactionItemDisplay toDisplayItem() {
    IconData icon;
    Color color;

    // Determine icon and color based on category
    switch (category) {
      case 'Shopping':
        icon = Icons.shopping_bag;
        color = const Color(0xFFFF9800);
        break;
      case 'Food':
        icon = Icons.restaurant;
        color = const Color(0xFF2196F3);
        break;
      case 'Entertainment':
        icon = Icons.movie;
        color = const Color(0xFFE91E63);
        break;
      case 'Transport':
        icon = Icons.directions_car;
        color = const Color(0xFF4CAF50);
        break;
      case 'Health':
        icon = Icons.medical_services;
        color = const Color(0xFFF44336);
        break;
      case 'Utilities':
        icon = Icons.phone;
        color = const Color(0xFF9C27B0);
        break;
      case 'Income':
        icon = Icons.account_balance_wallet;
        color = Colors.green;
        break;
      default:
        icon = Icons.category_outlined;
        color = const Color(0xFF9E9E9E);
    }

    return TransactionItemDisplay(
      id: id ?? '',
      name: name,
      category: category,
      amount: amount,
      date: date,
      icon: icon,
      iconColor: color,
    );
  }
}

// Display class for UI that matches the original Transaction class structure
class TransactionItemDisplay {
  final String id;
  final String name;
  final String category;
  final double amount;
  final DateTime date;
  final IconData icon;
  final Color iconColor;

  const TransactionItemDisplay({
    required this.id,
    required this.name,
    required this.category,
    required this.amount,
    required this.date,
    required this.icon,
    required this.iconColor,
  });
}