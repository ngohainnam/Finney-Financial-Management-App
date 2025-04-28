import 'package:flutter/material.dart';
import 'package:finney/pages/3-dashboard/models/saving_goal_model.dart';
import 'package:finney/pages/3-dashboard/saving/add_saving/saving_goal_service.dart';
import 'package:finney/pages/3-dashboard/saving/add_saving/add_edit_goal_page.dart';
import 'package:finney/pages/3-dashboard/widgets/goal_card.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/localization/locales.dart';

// Color constants
const _successColor = Color(0xFF4CAF50);
const _successDark = Color(0xFF4CAF50);
const _errorColor = Color(0xFFF44336);
const _infoColor = Color(0xFF2196F3);

class SavingGoalPage extends StatefulWidget {
  const SavingGoalPage({super.key});

  @override
  SavingGoalPageState createState() => SavingGoalPageState();
}

class SavingGoalPageState extends State<SavingGoalPage> {
  final SavingGoalService _goalService = SavingGoalService();

  void _showSuccessMessage(String message) {
    _showSnackbar(message, _successColor, Icons.check_circle);
  }

  void _showErrorMessage(String message) {
    _showSnackbar(message, _errorColor, Icons.error);
  }

  void _showInfoMessage(String message) {
    _showSnackbar(message, _infoColor, Icons.info);
  }

  void _showSnackbar(String message, Color color, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
        elevation: 6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleData.mySavingGoals.getString(context),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ElevatedButton.icon(
              onPressed: _navigateToAddGoal,
              icon: const Icon(Icons.add_circle_outline, size: 20),
              label: Text(
                LocaleData.newGoal.getString(context),
                style: TextStyle(fontSize: 14)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _successDark,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(17.5),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ],
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded, size: 28),
            onPressed: _showSavingsInfo,
          ),
        ],
      ),
      body: StreamBuilder<List<SavingGoal>>(
        stream: _goalService.getGoals(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(
                    LocaleData.loadingGoals.getString(context),
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.savings_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    LocaleData.noSavingGoals.getString(context),
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _navigateToAddGoal,
                    icon: const Icon(Icons.add_circle_outline),
                    label: Text(LocaleData.createFirstGoal.getString(context)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          final goals = snapshot.data!;

          return Column(
            children: [
              // Progress Card
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _buildTotalSavingsProgress(goals),
                  ),
                ),
              ),

              // Goals List
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshGoals,
                  color: _infoColor,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: goals.length,
                    itemBuilder:
                        (context, index) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GoalCard(
                            goal: goals[index],
                            onTap: () => _navigateToEditGoal(goals[index]),
                            onAddSavings:
                                (amount) => _addToSavings(goals[index], amount),
                            onDelete: () => _deleteGoal(goals[index]),
                          ),
                        ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTotalSavingsProgress(List<SavingGoal> goals) {
    final totalTarget = goals.fold(0.0, (sum, goal) => sum + goal.targetAmount);
    final totalSaved = goals.fold(0.0, (sum, goal) => sum + goal.savedAmount);
    final progress = totalTarget > 0 ? totalSaved / totalTarget : 0;
    final percentage = (progress * 100).toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.bar_chart_rounded, color: _infoColor, size: 24),
            const SizedBox(width: 8),
            Text(
              LocaleData.totalSavingsProgress.getString(context),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        LinearProgressIndicator(
          value: progress.toDouble(),
          minHeight: 12,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(_successColor),
          borderRadius: BorderRadius.circular(6),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              LocaleData.percentComplete.getString(context).replaceFirst(
                '%s',
                percentage,
              ),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _successDark,
              ),
            ),
            Text(
              LocaleData.savingsOfTarget.getString(context).replaceFirst(
                '%s',
                totalSaved.toStringAsFixed(2),
              ).replaceFirst(
                '%s',
                totalTarget.toStringAsFixed(2),
              ),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _refreshGoals() async {
    _showInfoMessage(LocaleData.goalsRefreshed.getString(context));
    setState(() {});
  }

  void _navigateToAddGoal() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => AddEditGoalPage(
              onGoalSaved: (SavingGoal goal) {
                _showSuccessMessage(LocaleData.goalCreated.getString(context).replaceFirst('%s', goal.title),);
              },
            ),
      ),
    );
  }

  void _navigateToEditGoal(SavingGoal goal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => AddEditGoalPage(
              existingGoal: goal,
              onGoalSaved: (SavingGoal updatedGoal) {
                _showSuccessMessage(LocaleData.goalUpdated.getString(context).replaceFirst('%s', updatedGoal.title),);
              },
              onGoalDeleted: () {
                _showErrorMessage(LocaleData.goalWasDeleted.getString(context));
              },
            ),
      ),
    );
  }

  Future<void> _addToSavings(SavingGoal goal, double amount) async {
    if (amount <= 0) {
      _showErrorMessage(LocaleData.amountGreaterThanZero.getString(context));
      return;
    }
    try {
      await _goalService.addToSavings(goal.id, amount);
      _showSuccessMessage(
        LocaleData.addedToSavings.getString(context)
        .replaceFirst('%s', amount.toStringAsFixed(2))
        .replaceFirst('%s', goal.title),
      );
    } catch (e) {
      _showErrorMessage(LocaleData.couldNotAddSavings.getString(context));
    }
  }

  Future<void> _deleteGoal(SavingGoal goal) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: _errorColor),
                const SizedBox(width: 12),
                Text(LocaleData.deleteGoalQuestion.getString(context)),
              ],
            ),
            content: Text(LocaleData.confirmDeleteGoalPermanent.getString(context).replaceFirst(
              '%s',
              goal.title,
            ),),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(LocaleData.cancel.getString(context)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: _errorColor),
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  LocaleData.delete.getString(context),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        await _goalService.deleteGoal(goal.id);
        _showSuccessMessage(LocaleData.goalDeleted.getString(context).replaceFirst('%s', goal.title),);
      } catch (e) {
        _showErrorMessage(LocaleData.couldNotDeleteGoal.getString(context));
      }
    }
  }

  void _showSavingsInfo() {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(Icons.savings_rounded, size: 32, color: _infoColor),
                      const SizedBox(width: 12),
                      Text(
                        LocaleData.aboutSavingGoals.getString(context),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _infoColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildInfoTip(
                    Icons.track_changes_rounded,
                    LocaleData.trackProgress.getString(context),
                    LocaleData.trackProgressDescription.getString(context),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoTip(
                    Icons.attach_money_rounded,
                    LocaleData.addMoneyAnytime.getString(context),
                    LocaleData.addMoneyAnytimeDescription.getString(context),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoTip(
                    Icons.calendar_today_rounded,
                    LocaleData.setTargetDates.getString(context),
                    LocaleData.setTargetDatesDescription.getString(context),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _infoColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        LocaleData.gotIt.getString(context),
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

  Widget _buildInfoTip(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: _infoColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
