
import 'package:flutter/material.dart';
import 'package:finney/models/transaction_model.dart';

class BudgetPredCard extends StatelessWidget {
  final List<TransactionModel> transactions;

  const BudgetPredCard({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    final budgetSuggestion = _generateBudgetSuggestion();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Suggested Monthly Budget',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '\$${budgetSuggestion.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.blueAccent),
            ),
            const SizedBox(height: 4),
            Text(
              'Based on your average monthly expenses so far.',
              style: TextStyle(color: Colors.grey[600]),
            )
          ],
        ),
      ),
    );
  }

  double _generateBudgetSuggestion() {
    final Map<String, double> monthlyExpenses = {};

    for (var tx in transactions) {
      if (tx.amount < 0) {
        final key = "${tx.date.year}-${tx.date.month}";
        monthlyExpenses[key] = (monthlyExpenses[key] ?? 0) + tx.amount.abs();
      }
    }

    if (monthlyExpenses.isEmpty) return 0;
    return monthlyExpenses.values.reduce((a, b) => a + b) / monthlyExpenses.length;
  }
}
