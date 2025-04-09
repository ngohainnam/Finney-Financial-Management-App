import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finney/pages/3-dashboard/models/saving_goal_model.dart';
import 'package:finney/pages/3-dashboard/services/saving_goal_service.dart';
import 'package:finney/pages/3-dashboard/transaction/add_saving/saving_goal_page.dart';

class AddEditGoalPage extends StatefulWidget {
  final SavingGoal? existingGoal;

  const AddEditGoalPage({super.key, this.existingGoal});

  @override
  State<AddEditGoalPage> createState() => _AddEditGoalPageState();
}

class _AddEditGoalPageState extends State<AddEditGoalPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _targetDate = DateTime.now();
  final SavingGoalService _goalService = SavingGoalService();

  @override
  void initState() {
    super.initState();
    if (widget.existingGoal != null) {
      _nameController.text = widget.existingGoal!.name;
      _descriptionController.text = widget.existingGoal!.description ?? '';
      _amountController.text = widget.existingGoal!.targetAmount.toString();
      _targetDate = widget.existingGoal!.targetDate;
    } else {
      _amountController.text = '0.00';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: Text(widget.existingGoal == null ? 'Create Goal' : 'Edit Goal'),
        actions:
            widget.existingGoal != null
                ? [
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: _deleteGoal,
                  ),
                ]
                : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Budget Selector
              DropdownButtonFormField<String>(
                value: 'Budget 1',
                decoration: const InputDecoration(
                  labelText: 'Budget',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Budget 1', child: Text('Budget 1')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 24),

              // Amount Field
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'AUS',
                  prefixText: '\$',
                  border: OutlineInputBorder(),
                ),
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
              const SizedBox(height: 24),

              // Goal Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Saving Goal Name',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Enter goal name'
                            : null,
              ),
              const SizedBox(height: 16),

              // Target Date
              const Text(
                'Finished in date',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 12),
                      Text(DateFormat('dd/MM/yyyy').format(_targetDate)),
                      if (_isToday(_targetDate)) ...[
                        const SizedBox(width: 8),
                        const Text('Today'),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Description
              const Text(
                'Description',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Enter description',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveGoal,
        child: const Icon(Icons.check),
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _targetDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _targetDate = picked);
    }
  }

  Future<void> _saveGoal() async {
    if (_formKey.currentState!.validate()) {
      final goal = SavingGoal(
        id:
            widget.existingGoal?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        targetAmount: double.parse(_amountController.text),
        currentAmount: widget.existingGoal?.currentAmount ?? 0,
        targetDate: _targetDate,
        description:
            _descriptionController.text.isEmpty
                ? null
                : _descriptionController.text,
        createdAt: widget.existingGoal?.createdAt ?? DateTime.now(),
      );

      if (widget.existingGoal == null) {
        await _goalService.addGoal(goal);
      } else {
        await _goalService.updateGoal(goal);
      }

      Navigator.pop(context);
    }
  }

  Future<void> _deleteGoal() async {
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

    if (confirmed == true && widget.existingGoal != null) {
      await _goalService.deleteGoal(widget.existingGoal!.id);
      Navigator.pop(context);
    }
  }
}
