import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finney/models/saving_goal_model.dart';
import 'package:finney/services/saving_goal_service.dart';

class SavingGoalsListPage extends StatelessWidget {
  final SavingGoalService _goalService = SavingGoalService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saving Goals'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/add-saving-goal'),
          ),
        ],
      ),
      body: StreamBuilder<List<SavingGoal>>(
        stream: _goalService.getGoals(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final goals = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: goals.length,
            itemBuilder: (context, index) {
              final goal = goals[index];
              return _buildGoalCard(goal);
            },
          );
        },
      ),
    );
  }

  Widget _buildGoalCard(SavingGoal goal) {
    final progress = goal.savedAmount / goal.targetAmount;
    final percent = (progress * 100).toStringAsFixed(0);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              goal.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              color: Colors.blue,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Target: AUS ${goal.targetAmount.toStringAsFixed(2)}'),
                Text('$percent% complete'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Saved: AUS ${goal.savedAmount.toStringAsFixed(2)}'),
                Text(
                  'Goal by: ${DateFormat('dd/MM/yyyy').format(goal.targetDate)}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
