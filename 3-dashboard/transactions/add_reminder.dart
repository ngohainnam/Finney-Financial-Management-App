import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddReminderScreen extends StatefulWidget {
  final Function? onReminderAdded;

  const AddReminderScreen({
    super.key,
    this.onReminderAdded,
  });

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Reminder'),
      ),
      body: const Center(
        child: Text('Add Reminder Screen - Placeholder'),
      ),
    );
  }
}