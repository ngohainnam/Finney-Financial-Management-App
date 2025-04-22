import 'package:finney/pages/3-dashboard/transaction/add_transaction/base_adding.dart';
import 'package:finney/pages/3-dashboard/utils/category.dart';
import 'package:flutter/material.dart';
class AddExpenseScreen extends BaseTransactionScreen {
  const AddExpenseScreen({
    super.key,
    super.onTransactionAdded,
    super.existingTransaction,
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends BaseTransactionScreenState<AddExpenseScreen> {
  @override
  String get screenTitle => widget.existingTransaction != null 
      ? 'Edit Expense' 
      : 'Add Expense';

  @override
  Color get amountColor => Colors.redAccent;

@override
List<CategoryData> get categories => CategoryUtils
    .getCategoriesForType(true)
    .map((name) => CategoryData(name))
    .toList();


  @override
  double getTransactionAmount() {
    return -double.parse(amountController.text.replaceAll(',', '.'));
  }
}