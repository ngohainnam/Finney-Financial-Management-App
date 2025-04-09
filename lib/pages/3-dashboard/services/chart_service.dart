import 'package:finney/pages/3-dashboard/models/transaction_model.dart';

class ChartService {
  List<WeeklyExpense> updateWeeklyExpenses({
    required TransactionModel transaction,
    required List<WeeklyExpense> currentWeeklyExpenses,
    bool isDelete = false,
  }) {
    // Skip income transactions
    if (transaction.isIncome) return currentWeeklyExpenses;

    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final dayIndex = transaction.date.weekday - 1;

    final updatedWeeklyExpenses = List<WeeklyExpense>.from(currentWeeklyExpenses);
    final currentDayExpense = updatedWeeklyExpenses[dayIndex];

    // Calculate new amount based on whether we're adding or deleting
    final amountChange = transaction.amount.abs() * (isDelete ? -1 : 1);
    final newAmount = currentDayExpense.amount + amountChange;

    updatedWeeklyExpenses[dayIndex] = WeeklyExpense(
      dayNames[dayIndex],
      newAmount >= 0 ? newAmount : 0, // Prevent negative amounts
    );

    return updatedWeeklyExpenses;
  }

  List<CategoryExpense> updateCategoryExpenses({
    required TransactionModel transaction,
    required List<CategoryExpense> currentCategoryExpenses,
    bool isDelete = false,
  }) {
    // Skip income transactions
    if (transaction.isIncome) return currentCategoryExpenses;

    final updatedCategoryExpenses = List<CategoryExpense>.from(currentCategoryExpenses);
    final existingCategoryIndex = updatedCategoryExpenses.indexWhere(
      (expense) => expense.name == transaction.category
    );

    if (existingCategoryIndex != -1) {
      final existingCategory = updatedCategoryExpenses[existingCategoryIndex];
      
      // Calculate new amount based on whether we're adding or deleting
      final amountChange = transaction.amount.abs() * (isDelete ? -1 : 1);
      final newAmount = existingCategory.amount + amountChange;

      if (newAmount <= 0) {
        // Remove category if amount becomes zero or negative
        updatedCategoryExpenses.removeAt(existingCategoryIndex);
      } else {
        // Update category with new amount
        updatedCategoryExpenses[existingCategoryIndex] = CategoryExpense(
          existingCategory.name,
          newAmount
        );
      }
    } else if (!isDelete) {
      // Only add new category if we're not deleting
      updatedCategoryExpenses.add(CategoryExpense(
        transaction.category,
        transaction.amount.abs()
      ));
    }

    return updatedCategoryExpenses;
  }
}