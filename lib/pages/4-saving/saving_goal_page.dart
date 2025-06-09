import 'package:flutter/material.dart';
import 'package:finney/core/storage/cloud/models/saving_goal_model.dart';
import 'package:finney/core/storage/cloud/service/saving_goal_service.dart';
import 'package:finney/pages/4-saving/add_edit_goal_page.dart';
import 'package:finney/pages/3-dashboard/widgets/goal_card.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:finney/shared/widgets/common/snack_bar.dart';
import 'package:finney/shared/widgets/common/settings_notifier.dart';

class SavingGoalPage extends StatefulWidget {
  const SavingGoalPage({super.key});

  @override
  State<SavingGoalPage> createState() => _SavingGoalPageState();
}

class _SavingGoalPageState extends State<SavingGoalPage> {
  final SavingGoalService _goalService = SavingGoalService();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: SettingsNotifier().textSizeNotifier,
      builder: (context, textSize, child) {
        double textScaleFactor;
        switch (textSize) {
          case 'Small':
            textScaleFactor = 0.8;
            break;
          case 'Large':
            textScaleFactor = 1.2;
            break;
          default:
            textScaleFactor = 1.0;
        }
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScaleFactor),
          ),
          child: Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              title: Text(
                LocaleData.mySavingGoals.getString(context),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                ElevatedButton.icon(
                  onPressed: _navigateToAddGoal,
                  icon: const Icon(Icons.add_circle_outline, size: 20),
                  label: Text(
                    LocaleData.newGoal.getString(context),
                    style: const TextStyle(fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
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
            body: StreamBuilder<List<SavingGoal>>(
              stream: _goalService.getGoals(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
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
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _refreshGoals,
                        color: AppColors.primary,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: goals.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: GoalCard(
                              goal: goals[index],
                              onTap: () => _navigateToEditGoal(goals[index]),
                              onAddSavings: (amount) => _addToSavings(goals[index], amount),
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
          ),
        );
      },
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
            Icon(Icons.bar_chart_rounded, color: AppColors.primary, size: 24),
            const SizedBox(width: 8),
            Text(
              LocaleData.totalSavingsProgress.getString(context),
              style: const TextStyle(
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
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
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
                color: Colors.green,
              ),
            ),
            Text(
              LocaleData.savingsOfTarget.getString(context).replaceFirst(
                '%s',
                '৳${totalSaved.toStringAsFixed(2)}',
              ).replaceFirst(
                '%s',
                '৳${totalTarget.toStringAsFixed(2)}',
              ),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _refreshGoals() async {
    AppSnackBar.showInfo(
      context,
      message: LocaleData.goalsRefreshed.getString(context),
    );
    setState(() {});
  }

  void _navigateToAddGoal() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditGoalPage(
          onGoalSaved: (SavingGoal goal) {
            setState(() {});
            AppSnackBar.showSuccess(
              context,
              message: LocaleData.goalCreated.getString(context).replaceFirst('%s', goal.title),
            );
          },
        ),
      ),
    );
  }

  void _navigateToEditGoal(SavingGoal goal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddEditGoalPage(
          existingGoal: goal,
          onGoalSaved: (SavingGoal updatedGoal) {
            setState(() {});
            AppSnackBar.showSuccess(
              context,
              message: LocaleData.goalUpdated.getString(context).replaceFirst('%s', updatedGoal.title),
            );
          },
          onGoalDeleted: () {
            setState(() {});
            AppSnackBar.showError(
              context,
              message: LocaleData.goalWasDeleted.getString(context),
            );
          },
        ),
      ),
    );
  }

  Future<void> _addToSavings(SavingGoal goal, double amount) async {
    final success = await _goalService.addToSavings(goal.id, amount, context);
    if (success) {
      setState(() {});
      AppSnackBar.showSuccess(
        context,
        message: LocaleData.addedToSavings.getString(context)
            .replaceFirst('%s', amount.toString())
            .replaceFirst('%s', goal.title),
      );
    }
  }

  Future<void> _deleteGoal(SavingGoal goal) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
            const SizedBox(width: 12),
            Text(LocaleData.deleteGoalQuestion.getString(context)),
          ],
        ),
        content: Text(LocaleData.confirmDeleteGoalPermanent.getString(context).replaceFirst(
          '%s',
          goal.title,
        )),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(LocaleData.cancel.getString(context)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              LocaleData.delete.getString(context),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _goalService.deleteGoal(goal.id);
        setState(() {});
        AppSnackBar.showSuccess(
          context,
          message: LocaleData.goalDeleted.getString(context).replaceFirst('%s', goal.title),
        );
      } catch (e) {
        AppSnackBar.showError(
          context,
          message: LocaleData.couldNotDeleteGoal.getString(context),
        );
      }
    }
  }

  void _showSavingsInfo() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
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
                  Icon(Icons.savings_rounded, size: 32, color: AppColors.categoryFood),
                  const SizedBox(width: 12),
                  Text(
                    LocaleData.aboutSavingGoals.getString(context),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.categoryFood,
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
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Got It",
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
        Icon(icon, size: 24, color: AppColors.primary),
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