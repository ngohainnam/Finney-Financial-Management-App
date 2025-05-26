import 'package:finney/pages/7-insights/components/time_selector.dart';
import 'package:finney/core/storage/cloud/models/transaction_model.dart';
import 'package:finney/shared/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/shared/localization/locales.dart';

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

enum ChartInterval {
  week, 
  month,
  year,
}

class ChartService {
  List<TransactionModel> filterTransactionsByTimeRange(
    List<TransactionModel> transactions,
    TimeRangeData timeRange,
  ) {
    return transactions.where((transaction) {
      return transaction.date.isAfter(timeRange.startDate) &&
          transaction.date.isBefore(timeRange.endDate.add(const Duration(days: 1)));
    }).toList();
  }
  
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

  List<PeriodExpense> getPeriodExpenses(
  List<TransactionModel> transactions,
  TimeRangeData timeRange,
  ChartInterval interval,
  BuildContext context, {
  TransactionType transactionType = TransactionType.expense,
}) {
  if (transactions.isEmpty) return [];

  final filteredTransactions = filterTransactionsByTimeRange(
    transactions,
    timeRange,
  );
  final typeFilteredTransactions = filterByTransactionType(
    filteredTransactions,
    transactionType,
  );

  if (typeFilteredTransactions.isEmpty) return [];

  final Map<String, double> periodMap = {};
  for (var transaction in typeFilteredTransactions) {
    final periodKey = _getPeriodKey(transaction.date, interval, context);
    final amount = transactionType == TransactionType.expense
        ? transaction.amount.abs()
        : transaction.amount;
    periodMap[periodKey] = (periodMap[periodKey] ?? 0) + amount;
  }

  final allPeriods = _generateAllPeriods(
    timeRange.startDate,
    timeRange.endDate,
    interval,
    context,
  );

  return allPeriods.map((period) {
    return PeriodExpense(
      period: period,
      amount: periodMap[period] ?? 0.0,
    );
  }).toList();
  }
  List<CategoryExpense> getCategoryExpenses(
    List<TransactionModel> transactions,
    TimeRangeData timeRange, {
    TransactionType transactionType = TransactionType.expense,
  }) {

    final filteredTransactions = filterTransactionsByTimeRange(
      transactions,
      timeRange,
    );
    
    final typeFilteredTransactions = filterByTransactionType(
      filteredTransactions,
      transactionType,
    );

    if (typeFilteredTransactions.isEmpty) return [];

    final Map<String, double> categoryMap = {};
    final Map<String, Color> categoryColorMap = {};
    
    for (var transaction in typeFilteredTransactions) {
      final category = transaction.category;
      final amount = transactionType == TransactionType.expense
          ? transaction.amount.abs() 
          : transaction.amount;
      
      categoryMap[category] = (categoryMap[category] ?? 0) + amount;
      categoryColorMap[category] = CategoryUtils.getColorForCategory(category);
    }

    return categoryMap.entries.map((entry) {
      return CategoryExpense(
        name: entry.key,
        amount: entry.value,
        color: categoryColorMap[entry.key] ?? Colors.grey,
      );
    }).toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));
  }
  
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
  
  List<Map<String, dynamic>> convertCategoryExpensesToMap(List<CategoryExpense> expenses) {
    return expenses.map((item) => {
      'name': item.name,
      'amount': item.amount,
      'color': item.color,
    }).toList();
  }

  String _getPeriodKey(DateTime date, ChartInterval interval, BuildContext context) {
  switch (interval) {
    case ChartInterval.week:
      return _getWeekdayName(date.weekday, context);
    case ChartInterval.month:
      return date.day.toString();
    case ChartInterval.year:
      return _getMonthName(date.month, context);
  }
  }

  List<String> _generateAllPeriods(
  DateTime startDate,
  DateTime endDate,
  ChartInterval interval,
  BuildContext context,
) {
  switch (interval) {
    case ChartInterval.week:
      return List.generate(7, (i) => _getWeekdayName(i + 1, context));
    case ChartInterval.month:
      final daysInMonth = DateTime(startDate.year, startDate.month + 1, 0).day;
      return List.generate(daysInMonth, (i) => (i + 1).toString());
    case ChartInterval.year:
      return List.generate(12, (i) => _getMonthName(i + 1, context));
  }
  }

  String _getWeekdayName(int weekday, BuildContext context) {
  const weekdayKeys = [
    LocaleData.mon,
    LocaleData.tue,
    LocaleData.wed,
    LocaleData.thu,
    LocaleData.fri,
    LocaleData.sat,
    LocaleData.sun,
  ];
  return weekdayKeys[weekday - 1].getString(context);
  }

  String _getMonthName(int month, BuildContext context) {
  const monthKeys = [
    LocaleData.jan,
    LocaleData.feb,
    LocaleData.mar,
    LocaleData.apr,
    LocaleData.may,
    LocaleData.jun,
    LocaleData.jul,
    LocaleData.aug,
    LocaleData.sep,
    LocaleData.oct,
    LocaleData.nov,
    LocaleData.dec,
  ];
  return monthKeys[month - 1].getString(context);
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