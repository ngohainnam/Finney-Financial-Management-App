import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finney/pages/3-dashboard/models/saving_goal_model.dart';
//import 'package:finney/pages/3-dashboard/transaction/add_saving/saving_goal_page.dart';

class GoalCard extends StatelessWidget {
  final SavingGoal goal;
  final VoidCallback onTap;

  const GoalCard({super.key, required this.goal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final progress = goal.currentAmount / goal.targetAmount;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    goal.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: onTap,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress > 1 ? 1 : progress,
                backgroundColor: Colors.grey[200],
                color: progress >= 1 ? Colors.green : Colors.blue,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Saved: ${currencyFormat.format(goal.currentAmount)}',
                    style: TextStyle(
                      color: progress >= 1 ? Colors.green : Colors.blue,
                    ),
                  ),
                  Text(
                    'Target: ${currencyFormat.format(goal.targetAmount)}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Target date: ${DateFormat('dd/MM/yyyy').format(goal.targetDate)}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
