import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finney/pages/provider.dart/ExpenseProvider.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Expenses")),
      body: Consumer<ExpenseProvider>(
        builder: (context, expenseProvider, child) {
          return ListView.builder(
            itemCount: expenseProvider.expenses.length,
            itemBuilder: (context, index) {
              final expense = expenseProvider.expenses[index];
              return ListTile(
                title: Text(expense.category),
                subtitle: Text('\$${expense.amount}'),
                trailing: Text(expense.date.toString()),
              );
            },
          );
        },
      ),
    );
  }
}
