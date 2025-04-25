import 'package:finney/components/time_selector.dart';
import 'package:finney/pages/3-dashboard/models/transaction_model.dart';
import 'package:finney/pages/3-dashboard/utils/category.dart';
import 'package:flutter/material.dart';

// Add TransactionType enum
enum TransactionType {
  expense,
  income,
  all
}

// Model for period expenses (for bar chart)
class PeriodExpense {
  final String period;
  final double amount;

  PeriodExpense({
    required this.period,
    required this.amount,
  });
}

// Model for category expenses (for pie chart)
class CategoryExpense {
  final String name;
  final double amount;
  final Color color;

  CategoryExpense({
    required this.name,
    required this.amount,
    required this.color,
  });
}

// Enum for chart interval (used for bar charts)
enum ChartInterval {
  week,  // Show days in a week
  month, // Show days in a month
  year,  // Show months in a year
}

class ChartService {
  // Filter transactions by time range
  List<TransactionModel> filterTransactionsByTimeRange(
    List<TransactionModel> transactions,
    TimeRangeData timeRange,
  ) {
    return transactions.where((transaction) {
      return transaction.date.isAfter(timeRange.startDate) &&
          transaction.date.isBefore(timeRange.endDate.add(const Duration(days: 1)));
    }).toList();
  }
  
  // Helper method to filter by transaction type
  List<TransactionModel> filterByTransactionType(
    List<TransactionModel> transactions,
    TransactionType type, 
  ) {
    if (type == TransactionType.all) return transactions;
    
    return transactions.where((transaction) {
      if (type == TransactionType.income) {
        return transaction.amount > 0;
      } else {
        return transaction.amount < 0;
      }
    }).toList();
  }

  // Get data for bar chart
  List<PeriodExpense> getPeriodExpenses(
    List<TransactionModel> transactions,
    TimeRangeData timeRange,
    ChartInterval interval, {
    TransactionType transactionType = TransactionType.expense,
  }) {
    if (transactions.isEmpty) return [];

    // Filter transactions by the time range
    final filteredTransactions = filterTransactionsByTimeRange(
      transactions,
      timeRange,
    );
    
    // Filter by transaction type
    final typeFilteredTransactions = filterByTransactionType(
      filteredTransactions,
      transactionType,
    );

    if (typeFilteredTransactions.isEmpty) return [];

    // Group transactions based on the selected interval
    final Map<String, double> periodMap = {};
    
    for (var transaction in typeFilteredTransactions) {
      final periodKey = _getPeriodKey(transaction.date, interval);
      
      final amount = transactionType == TransactionType.expense
          ? transaction.amount.abs() 
          : transaction.amount;
          
      periodMap[periodKey] = (periodMap[periodKey] ?? 0) + amount;
    }

    // Generate the list of all periods in the time range
    final allPeriods = _generateAllPeriods(
      timeRange.startDate,
      timeRange.endDate,
      interval,
    );

    // Map the data to PeriodExpense objects, ensuring all periods are included
    return allPeriods.map((period) {
      return PeriodExpense(
        period: period,
        amount: periodMap[period] ?? 0.0,
      );
    }).toList();
  }

  // Get category expenses for pie chart - updated to support income
  List<CategoryExpense> getCategoryExpenses(
    List<TransactionModel> transactions,
    TimeRangeData timeRange, {
    TransactionType transactionType = TransactionType.expense,
  }) {
    // Filter transactions by the time range
    final filteredTransactions = filterTransactionsByTimeRange(
      transactions,
      timeRange,
    );
    
    // Filter by transaction type
    final typeFilteredTransactions = filterByTransactionType(
      filteredTransactions,
      transactionType,
    );

    if (typeFilteredTransactions.isEmpty) return [];

    // Group expenses by category
    final Map<String, double> categoryMap = {};
    final Map<String, Color> categoryColorMap = {};
    
    for (var transaction in typeFilteredTransactions) {
      final category = transaction.category;
      final amount = transactionType == TransactionType.expense
          ? transaction.amount.abs() // For expenses, use absolute value
          : transaction.amount;      // For income, use positive value
      
      categoryMap[category] = (categoryMap[category] ?? 0) + amount;
      categoryColorMap[category] = CategoryUtils.getColorForCategory(category);
    }

    // Convert to list of CategoryExpense objects
    return categoryMap.entries.map((entry) {
      return CategoryExpense(
        name: entry.key,
        amount: entry.value,
        color: categoryColorMap[entry.key] ?? Colors.grey,
      );
    }).toList()
      // Sort by amount (descending)
      ..sort((a, b) => b.amount.compareTo(a.amount));
  }
  
  // Helper method to map time range to chart interval
  ChartInterval getIntervalForTimeRange(TimeRangeData timeRange) {
    switch (timeRange.range) {
      case TimeRange.week:
        return ChartInterval.week;
      case TimeRange.month:
        return ChartInterval.month;
      case TimeRange.year:
      case TimeRange.allTime:
        return ChartInterval.year;
    }
  }
  
  // Helper to convert CategoryExpense to map for the pie chart
  List<Map<String, dynamic>> convertCategoryExpensesToMap(List<CategoryExpense> expenses) {
    return expenses.map((item) => {
      'name': item.name,
      'amount': item.amount,
      'color': item.color,
    }).toList();
  }

  String _getPeriodKey(DateTime date, ChartInterval interval) {
    switch (interval) {
      case ChartInterval.week:
        return _getWeekdayName(date.weekday);
        
      case ChartInterval.month:
        return date.day.toString();
        
      case ChartInterval.year:
        return _getMonthName(date.month);
    }
  }

  List<String> _generateAllPeriods(
    DateTime startDate,
    DateTime endDate,
    ChartInterval interval,
  ) {
    switch (interval) {
      case ChartInterval.week:
        // For a week, show weekdays
        return List.generate(7, (i) => _getWeekdayName(i + 1));
      
      case ChartInterval.month:
        // For a month, show days (1-31)
        final daysInMonth = DateTime(startDate.year, startDate.month + 1, 0).day;
        return List.generate(daysInMonth, (i) => (i + 1).toString());
      
      case ChartInterval.year:
        // For a year, show months (Jan-Dec)
        return List.generate(12, (i) => _getMonthName(i + 1));
    }
  }

  String _getWeekdayName(int weekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  double calculateTotalIncome(List<TransactionModel> transactions) {
    return transactions
        .where((transaction) => transaction.amount > 0)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  double calculateTotalExpenses(List<TransactionModel> transactions) {
    return transactions
        .where((transaction) => transaction.amount < 0)
        .fold(0.0, (sum, transaction) => sum + transaction.amount.abs());
  }

  double calculateBalance(List<TransactionModel> transactions) {
    return transactions.fold(
        0.0, (sum, transaction) => sum + transaction.amount);
  }
}