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
  String? incomeRange;

  @HiveField(4)
  String? ageGroup;

  @HiveField(5)
  String? financialGoals;

  @HiveField(6)
  double currentBalance;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.incomeRange,
    this.ageGroup,
    this.financialGoals,
    this.currentBalance = 0.0,
  });
}