import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddSavingsGoalScreen extends StatefulWidget {
  final Function? onSavingsGoalAdded;

  const AddSavingsGoalScreen({
    super.key,
    this.onSavingsGoalAdded,
  });

  @override
  State<AddSavingsGoalScreen> createState() => _AddSavingsGoalScreenState();
}

class _AddSavingsGoalScreenState extends State<AddSavingsGoalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Savings Goal'),
      ),
      body: const Center(
        child: Text('Add Savings Goal Screen - Placeholder'),
      ),
    );
  }
}