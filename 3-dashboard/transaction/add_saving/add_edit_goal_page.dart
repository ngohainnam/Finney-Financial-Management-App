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
        final goal = SavingGoal(
          id:
              widget.existingGoal?.id ??
              FirebaseFirestore.instance.collection('goals').doc().id,
          title: _titleController.text,
          targetAmount: double.parse(_targetAmountController.text),
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

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  widget.existingGoal == null
                      ? 'Goal "${goal.title}" created!'
                      : 'Goal "${goal.title}" updated!',
                ),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );

        if (widget.onGoalSaved != null) {
          widget.onGoalSaved!(goal);
        }

        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                const Text('Error saving goal'),
              ],
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingGoal == null ? 'Create New Goal' : 'Edit Your Goal',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.grey[50],
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount Section
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey[200]!),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.monetization_on,
                            color: Colors.deepPurple,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'TARGET AMOUNT (AUD)',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _targetAmountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: const Text(
                              '\$ ',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          border: InputBorder.none,
                          hintText: '0.00',
                          hintStyle: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[400],
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
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
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Goal Name Section
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey[200]!),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.flag, color: Colors.deepPurple, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'GOAL NAME',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'e.g. Vacation, New Car, Emergency Fund',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Please enter a goal name'
                                    : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Target Date Section
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey[200]!),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Colors.deepPurple,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'TARGET DATE',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('dd/MM/yyyy').format(_selectedDate),
                              style: const TextStyle(fontSize: 18),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Description Section
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey[200]!),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.description,
                            color: Colors.deepPurple,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'DESCRIPTION (OPTIONAL)',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Add notes about your goal...',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveGoal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.save, color: Colors.white),
                      const SizedBox(width: 8),
                      const Text(
                        'SAVE GOAL',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
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
