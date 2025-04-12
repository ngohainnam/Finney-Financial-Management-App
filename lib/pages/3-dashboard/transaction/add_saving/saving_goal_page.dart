import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finney/pages/3-dashboard/models/saving_goal_model.dart';
import 'package:finney/pages/3-dashboard/services/saving_goal_service.dart';
import 'package:finney/pages/3-dashboard/transaction/add_saving/add_edit_goal_page.dart';
import 'package:finney/pages/3-dashboard/widgets/goal_card.dart';

// Enhanced color scheme
const _successColor = Color(0xFF4CAF50); // Green 500
const _successDark = Color(0xFF388E3C); // Green 700
const _errorColor = Color(0xFFF44336); // Red 500
const _errorDark = Color(0xFFD32F2F); // Red 700
const _infoColor = Color(0xFF2196F3); // Blue 500
const _warningColor = Color(0xFFFFC107); // Amber 500

class SavingGoalPage extends StatelessWidget {
  final SavingGoalService _goalService = SavingGoalService();

  // Helper method for success messages
  void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: _successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
        elevation: 6,
      ),
    );
  }

  // Helper method for error messages
  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: _errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
        elevation: 6,
      ),
    );
  }

  // Helper method for info messages
  void _showInfoMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: _infoColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
        elevation: 6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saving Goals'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showSavingsInfo(context),
          ),
        ],
      ),
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

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildTotalSavingsProgress(goals),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => _refreshGoals(context),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: goals.length,
                    itemBuilder:
                        (context, index) => GoalCard(
                          goal: goals[index],
                          onTap:
                              () => _navigateToEditGoal(context, goals[index]),
                          onAddSavings:
                              (amount) =>
                                  _addToSavings(context, goals[index], amount),
                          onDelete: () => _deleteGoal(context, goals[index]),
                        ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddGoal(context),
        icon: const Icon(Icons.add),
        label: const Text('Create Goal'),
        backgroundColor: _successColor,
      ),
    );
  }

  // Builds the total savings progress bar
  Widget _buildTotalSavingsProgress(List<SavingGoal> goals) {
    final totalTarget = goals.fold<double>(
      0,
      (sum, goal) => sum + goal.targetAmount,
    );
    final totalSaved = goals.fold<double>(
      0,
      (sum, goal) => sum + goal.savedAmount,
    );

    final progress = totalTarget > 0 ? totalSaved / totalTarget : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Total Savings Progress',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress.toDouble(),
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(_successColor),
        ),
        const SizedBox(height: 8),
        Text(
          '\$${totalSaved.toStringAsFixed(2)} saved of \$${totalTarget.toStringAsFixed(2)}',
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Future<void> _addToSavings(
    BuildContext context,
    SavingGoal goal,
    double amount,
  ) async {
    if (amount <= 0) {
      _showErrorMessage(context, 'Please enter a valid amount');
      return;
    }

    try {
      await _goalService.addToSavings(goal.id, amount);
      _showSuccessMessage(
        context,
        '\$${amount.toStringAsFixed(2)} added to ${goal.title}',
      );
    } catch (e) {
      _showErrorMessage(context, 'Failed to add savings: ${e.toString()}');
    }
  }

  Future<void> _deleteGoal(BuildContext context, SavingGoal goal) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              'Delete Goal',
              style: TextStyle(color: _errorDark),
            ),
            content: Text('Are you sure you want to delete "${goal.title}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: _errorColor),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        await _goalService.deleteGoal(goal.id);
        _showErrorMessage(context, '"${goal.title}" deleted successfully');
      } catch (e) {
        _showErrorMessage(context, 'Failed to delete goal: ${e.toString()}');
      }
    }
  }

  Future<void> _refreshGoals(BuildContext context) async {
    try {
      _showInfoMessage(context, 'Goals refreshed');
    } catch (e) {
      _showErrorMessage(context, 'Error refreshing goals: ${e.toString()}');
    }
  }

  void _navigateToAddGoal(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => AddEditGoalPage(
              onGoalSaved: () {
                _showSuccessMessage(context, 'Goal created successfully! 🎉');
                _refreshGoals(context);
              },
            ),
      ),
    );
  }

  void _navigateToEditGoal(BuildContext context, SavingGoal goal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => AddEditGoalPage(
              existingGoal: goal,
              onGoalSaved: () {
                _showSuccessMessage(context, 'Goal updated successfully!');
                _refreshGoals(context);
              },
              onGoalDeleted: () {
                _showErrorMessage(context, 'Goal deleted successfully');
                _refreshGoals(context);
              },
            ),
      ),
    );
  }

  void _showSavingsInfo(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text(
              'About Saving Goals',
              style: TextStyle(color: _infoColor),
            ),
            content: const Text(
              'Track your savings progress by creating goals.\n'
              'Add money to your goals whenever you save.\n'
              'Reach your targets by the specified dates!',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK', style: TextStyle(color: _infoColor)),
              ),
            ],
          ),
    );
  }
}
