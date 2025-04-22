import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finney/pages/3-dashboard/models/saving_goal_model.dart';

class AddEditGoalPage extends StatefulWidget {
  final SavingGoal? existingGoal;
  final Function(SavingGoal)? onGoalSaved;
  final VoidCallback? onGoalDeleted;

  const AddEditGoalPage({
    super.key,
    this.existingGoal,
    this.onGoalSaved,
    this.onGoalDeleted,
  });

  @override
  State<AddEditGoalPage> createState() => _AddEditGoalPageState();
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

  Future<void> _saveGoal() async {
    if (_formKey.currentState!.validate()) {
      try {
        final amount = double.tryParse(_targetAmountController.text);
        if (amount == null || amount <= 0) {
          _showErrorMessage('Please enter a valid positive amount');
          return;
        }

        final goal = SavingGoal(
          id:
              widget.existingGoal?.id ??
              FirebaseFirestore.instance.collection('goals').doc().id,
          title: _titleController.text,
          targetAmount: amount,
          savedAmount: widget.existingGoal?.savedAmount ?? 0.0,
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

        _showSuccessMessage(
          widget.existingGoal == null
              ? 'Goal "${goal.title}" created!'
              : 'Goal "${goal.title}" updated!',
        );

        if (widget.onGoalSaved != null) {
          widget.onGoalSaved!(goal);
        }

        Navigator.of(context).pop();
      } catch (e) {
        _showErrorMessage('Error saving goal. Please try again.');
      }
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingGoal == null ? 'Add Saving Goal' : 'Edit Saving Goal',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount Field
              // Replace the Amount Field section with this:
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '\$',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _targetAmountController,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4CAF50),
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        hintText: '0.00',
                        hintStyle: TextStyle(
                          color: Color(0xFF4CAF50),
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        final amount = double.tryParse(value);
                        if (amount == null) {
                          return 'Please enter a valid number';
                        }
                        if (amount <= 0) {
                          return 'Please enter a positive amount';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Goal Name Field
              const Text(
                'Saving Goal Purpose',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'e.g. Saving for new Car...',
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(15),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Please enter a saving goal name'
                            : null,
              ),
              const SizedBox(height: 20),

              // Date Field
              const Text(
                'Target Date',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('EEEE').format(_selectedDate),
                        style: const TextStyle(
                          color: Color(0xFF424242),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy').format(_selectedDate),
                        style: const TextStyle(
                          color: Color(0xFF424242),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Description Field
              const Text(
                'Description',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Enter description (optional)',
                  hintStyle: const TextStyle(
                    color: Color(0xFFBDBDBD),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(15),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 40),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveGoal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'SAVE GOAL',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
