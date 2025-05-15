import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String uid;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String incomeRange;

  @HiveField(4)
  final String ageGroup;

  @HiveField(5)
  final String financialGoals;

  @HiveField(6)
  final double currentBalance;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.incomeRange = '',
    this.ageGroup = '',
    this.financialGoals = '',
    this.currentBalance = 0.0,
  });

  // Create a UserModel from a Map (for Firestore)
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      incomeRange: data['incomeRange'] ?? '',
      ageGroup: data['ageGroup'] ?? '',
      financialGoals: data['financialGoals'] ?? '',
      currentBalance: (data['currentBalance'] ?? 0.0).toDouble(),
    );
  }
  
  // Convert UserModel to a Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': uid,
      'name': name,
      'email': email,
      'incomeRange': incomeRange,
      'ageGroup': ageGroup,
      'financialGoals': financialGoals,
      'currentBalance': currentBalance,
    };
  }
}