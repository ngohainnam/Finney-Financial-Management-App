import 'package:finney/pages/3-dashboard/transaction/add_transaction/base_adding.dart';
import 'package:finney/pages/3-dashboard/utils/category.dart';
import 'package:flutter/material.dart';

class AddIncomeScreen extends BaseTransactionScreen {
  const AddIncomeScreen({
    super.key,
    super.onTransactionAdded,
    super.existingTransaction,
  });

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends BaseTransactionScreenState<AddIncomeScreen> {
  @override
  String get screenTitle => widget.existingTransaction != null 
      ? 'Edit Income' 
      : 'Add Income';

  @override
  Color get amountColor => Colors.green;

@override
List<CategoryData> get categories => CategoryUtils
    .getCategoriesForType(false)
    .map((name) => CategoryData(name))
    .toList();

  @override
  double getTransactionAmount() {
    return double.parse(amountController.text.replaceAll(',', '.'));
  }
}