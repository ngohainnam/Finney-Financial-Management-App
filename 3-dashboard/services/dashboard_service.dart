import 'package:finney/services/transaction_services.dart' as services;
import 'package:finney/pages/3-dashboard/models/transaction_data.dart';


class DashboardService {
  final services.TransactionService _transactionService = services.TransactionService();

  Future<DashboardData> loadDashboardData() async {
    final results = await Future.wait([
      _transactionService.getCurrentMonthIncome(),
      _transactionService.getCurrentMonthExpenses(),
      _transactionService.getWeeklyExpenses(),
      _transactionService.getCategoryExpenses(),
    ]);

    final monthlyIncome = results[0] as double;
    final monthlyExpenses = results[1] as double;
    final weeklyExpensesData = results[2] as List<dynamic>;
    final categoryExpensesData = results[3] as List<dynamic>;

    // Convert data
    final weeklyExpenses = weeklyExpensesData.map((data) =>
        WeeklyExpense(data.day, data.amount)
    ).toList();

    final categoryExpenses = categoryExpensesData.map((data) =>
        CategoryExpense(data.name, data.amount, data.color, data.icon)
    ).toList();

    return DashboardData(
      monthlyIncome: monthlyIncome,
      monthlyExpenses: monthlyExpenses,
      weeklyExpenses: weeklyExpenses,
      categoryExpenses: categoryExpenses,
    );
  }
}