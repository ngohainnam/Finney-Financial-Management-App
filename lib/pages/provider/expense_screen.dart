import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finney/pages/provider.dart/ExpenseProvider.dart';
import 'package:finney/pages/provider.dart/BudgetProvider.dart';
import 'package:finney/pages/provider.dart/CategoryProvider.dart';
import 'TransactionHistory.dart'; // Import TransactionHistory
import 'AddExpenseScreen.dart';
import 'BudgetNotification.dart';
import 'TransactionHistoryScreen.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseProvider = Provider.of<ExpenseProvider>(context);
    final budgetProvider = Provider.of<BudgetProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final transactionHistory =
        TransactionHistory(); // Initialize TransactionHistory

    return Scaffold(
      appBar: AppBar(title: Text("Manage Expenses")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Expense Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'Expenses',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: expenseProvider.expenses.length,
                      itemBuilder: (context, index) {
                        final expense = expenseProvider.expenses[index];
                        return ListTile(
                          title: Text(expense.category),
                          subtitle: Text(
                            '\$${expense.amount} - ${expense.description}',
                          ),
                          trailing: Text(expense.date.toString()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Budget Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'Budgets',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: budgetProvider.budgets.length,
                      itemBuilder: (context, index) {
                        final budget = budgetProvider.budgets[index];
                        return ListTile(
                          title: Text(budget.category),
                          subtitle: Text(
                            'Limit: \$${budget.limit} - Remaining: \$${budgetProvider.getRemainingBudget(budget.category)}',
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Category Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: categoryProvider.categories.length,
                      itemBuilder: (context, index) {
                        final category = categoryProvider.categories[index];
                        return ListTile(
                          title: Text(category.name),
                          subtitle: Text('Budget: \$${category.budget}'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Transaction Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      'Transactions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: transactionHistory.transactions.length,
                      itemBuilder: (context, index) {
                        final transaction =
                            transactionHistory.transactions[index];
                        return ListTile(
                          title: Text(transaction.description),
                          subtitle: Text('\$${transaction.amount}'),
                          trailing: Text(transaction.date.toString()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
