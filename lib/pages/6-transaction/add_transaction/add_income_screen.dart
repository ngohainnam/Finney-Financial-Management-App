import 'package:finney/pages/6-transaction/add_transaction/base_adding.dart';
import 'package:finney/shared/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/shared/localization/locales.dart';

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
      ? LocaleData.editExpense.getString(context)
      : LocaleData.addExpense.getString(context);

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