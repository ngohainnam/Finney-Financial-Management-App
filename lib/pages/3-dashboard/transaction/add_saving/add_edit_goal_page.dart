import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finney/pages/3-dashboard/models/saving_goal_model.dart';
import 'package:finney/pages/3-dashboard/transaction/add_saving/saving_goal_page.dart';
import 'package:intl/intl.dart';

class AddEditGoalPage extends StatefulWidget {
  final SavingGoal? existingGoal;
  final VoidCallback? onGoalSaved;
  final VoidCallback? onGoalDeleted;

  const AddEditGoalPage({
    Key? key,
    this.existingGoal,
    this.onGoalSaved,
    this.onGoalDeleted, // Add this
  }) : super(key: key);

  @override
  _AddEditGoalPageState createState() => _AddEditGoalPageState();
}

class _AddEditGoalPageState extends State<AddEditGoalPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 30));

  @override
  void initState() {
    super.initState();
    if (widget.existingGoal != null) {
      _titleController.text = widget.existingGoal!.title;
      _targetAmountController.text =
          widget.existingGoal!.targetAmount.toString();
      _descriptionController.text = widget.existingGoal!.description ?? '';
      _selectedDate = widget.existingGoal!.targetDate;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetAmountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // First, add this method to your _AddEditGoalPageState class
  Future<void> _deleteGoal() async {
    if (widget.existingGoal == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Goal'),
            content: const Text('Are you sure you want to delete this goal?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        await FirebaseFirestore.instance
            .collection('goals')
            .doc(widget.existingGoal!.id)
            .delete();

        if (widget.onGoalDeleted != null) {
          widget.onGoalDeleted!();
        }

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Goal deleted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to delete goal: $e')));
      }
    }
  }

  Future<void> _saveGoal() async {
    if (_formKey.currentState!.validate()) {
      try {
        final goal = SavingGoal(
          id:
              widget.existingGoal?.id ??
              FirebaseFirestore.instance.collection('goals').doc().id,
          title: _titleController.text,
          targetAmount: double.parse(_targetAmountController.text),
          savedAmount:
              widget.existingGoal?.savedAmount ??
              0.0, // Keep existing saved amount or default to 0
          targetDate: _selectedDate,
          description:
              _descriptionController.text.isNotEmpty
                  ? _descriptionController.text
                  : null,
          createdAt: widget.existingGoal?.createdAt ?? DateTime.now(),
        );

        await FirebaseFirestore.instance
            .collection('goals')
            .doc(goal.id)
            .set(goal.toMap());

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Goal "${goal.title}" created successfully!'),
            duration: const Duration(seconds: 2),
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        // Navigate back and notify parent
        if (widget.onGoalSaved != null) {
          widget.onGoalSaved!();
        }
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingGoal == null ? 'Create Goal' : 'Edit Goal'),
        actions: [
          if (widget.existingGoal != null) // Only show delete when editing
            IconButton(icon: const Icon(Icons.delete), onPressed: _deleteGoal),
          IconButton(icon: const Icon(Icons.save), onPressed: _saveGoal),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Goal Title',
                  hintText: 'e.g. New Laptop',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _targetAmountController,
                decoration: const InputDecoration(
                  labelText: 'Target Amount',
                  prefixText: '\$',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Target Date'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('dd/MM/yyyy').format(_selectedDate)),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  hintText: 'Notes about your goal',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveGoal,
                child: const Text('Save Goal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
