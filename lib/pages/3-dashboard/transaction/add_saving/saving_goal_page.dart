import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finney/pages/3-dashboard/models/saving_goal_model.dart';
import 'package:finney/pages/3-dashboard/services/saving_goal_service.dart';
import 'package:finney/pages/3-dashboard/transaction/add_saving/add_edit_goal_page.dart';
import 'package:finney/pages/3-dashboard/widgets/goal_card.dart';

class SavingGoalPage extends StatelessWidget {
  final SavingGoalService _goalService = SavingGoalService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saving Goals'), centerTitle: true),
      body: StreamBuilder<List<SavingGoal>>(
        stream: _goalService.getGoals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No saving goals yet'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _navigateToAddGoal(context),
                    child: const Text('Create Goal'),
                  ),
                ],
              ),
            );
          }

          final goals = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: goals.length,
            itemBuilder:
                (context, index) => GoalCard(
                  goal: goals[index],
                  onTap: () => _navigateToEditGoal(context, goals[index]),
                ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddGoal(context),
        icon: const Icon(Icons.add),
        label: const Text('Create Goal'),
      ),
    );
  }

  void _navigateToAddGoal(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddEditGoalPage()),
    );
  }

  void _navigateToEditGoal(BuildContext context, SavingGoal goal) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditGoalPage(existingGoal: goal)),
    );
  }
}
