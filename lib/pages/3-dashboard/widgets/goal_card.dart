import 'package:flutter/material.dart';
import 'package:finney/core/storage/cloud/models/saving_goal_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/shared/localization/locales.dart';

class GoalCard extends StatelessWidget {
  final SavingGoal goal;
  final VoidCallback onTap;
  final Function(double) onAddSavings;
  final VoidCallback onDelete;

  const GoalCard({
    super.key,
    required this.goal,
    required this.onTap,
    required this.onAddSavings,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final daysRemaining = goal.daysRemaining;
    final isOverdue = daysRemaining < 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      goal.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      if (goal.isCompleted)
                        const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 20,
                        ),
                      IconButton(
                        icon: const Icon(Icons.delete, size: 20),
                        color: Colors.red,
                        onPressed: () => _showDeleteConfirmation(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: goal.progressPercentage / 100,
                minHeight: 10,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  goal.isCompleted ? Colors.green : Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    LocaleData.savedAmount.getString(context).replaceFirst(
                      '%s',
                      '৳${goal.savedAmount.toStringAsFixed(2)}',
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    LocaleData.targetAmount.getString(context).replaceFirst(
                      '%s',
                      '৳${goal.targetAmount.toStringAsFixed(2)}',
                    ),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                LocaleData.percentCompleted.getString(context).replaceFirst(
                  '%s',
                  goal.progressPercentage.toStringAsFixed(1),
                ),
                style: TextStyle(
                  color: goal.isCompleted ? Colors.green : Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${LocaleData.targetDate.getString(context).replaceFirst(
                  '%s',
                  DateFormat('dd/MM/yyyy').format(goal.targetDate),
                )} '
                '(${isOverdue
                    ? LocaleData.daysOverdue.getString(context).replaceFirst('%d', daysRemaining.abs().toString())
                    : LocaleData.daysLeft.getString(context).replaceFirst('%d', daysRemaining.toString())})',
                style: TextStyle(color: isOverdue ? Colors.red : null),
              ),
              if (goal.description?.isNotEmpty ?? false) ...[
                const SizedBox(height: 8),
                Text(
                  goal.description!,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showAddSavingsDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(LocaleData.addSavings.getString(context)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddSavingsDialog(BuildContext context) {
    final amountController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(LocaleData.addToSavings.getString(context)),
            content: Form(
              key: formKey,
              child: TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: LocaleData.amount.getString(context),
                  prefixText: '৳',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return LocaleData.pleaseEnterAmount.getString(context);
                  }
                  final amount = double.tryParse(value);
                  if (amount == null) {
                    return LocaleData.pleaseEnterValidNumber.getString(context);
                  }
                  if (amount <= 0) {
                    return LocaleData.amountMustBePositive.getString(context);
                  }
                  // Check if amount exceeds remaining target
                  final remainingAmount = goal.targetAmount - goal.savedAmount;
                  if (amount > remainingAmount) {
                    return LocaleData.amountExceedsTarget.getString(context)
                        .replaceFirst('%s', '৳${remainingAmount.toStringAsFixed(2)}');
                  }
                  return null;
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(LocaleData.cancel.getString(context)),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final amount = double.parse(amountController.text);
                    Navigator.pop(context);
                    onAddSavings(amount);
                  }
                },
                child: Text(LocaleData.add.getString(context)),
              ),
            ],
          ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(LocaleData.deleteGoal.getString(context)),
            content: Text(
              LocaleData.confirmDeleteGoal.getString(context).replaceFirst('%s', goal.title),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(LocaleData.cancel.getString(context)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                  onDelete();
                },
                child: Text(LocaleData.delete.getString(context)),
              ),
            ],
          ),
    );
  }
}
