import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:finney/pages/3-dashboard/transaction/transaction_services.dart';
import 'package:finney/pages/3-dashboard/models/transaction_model.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  final TransactionService _transactionService = TransactionService();
  bool _loading = true;
  Map<String, dynamic> _prediction = {
    "predictedExpense": 0.0,
    "predictedSavings": 0.0,
    "suggestedBudget": 0.0
  };

  Future<void> _fetchPrediction(List<TransactionModel> transactions) async {
    try {
      final jsonTransactions = transactions.map((tx) => {
        'name': tx.name,
        'category': tx.category,
        'amount': tx.amount,
        'date': tx.date.toIso8601String(),
        'description': tx.description ?? ''
      }).toList();

      final response = await http.post(
        Uri.parse("http://10.0.2.2:8000/predict"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'transactions': jsonTransactions}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _prediction = data;
          _loading = false;
        });
      } else {
        throw Exception('Failed to fetch prediction: ${response.body}');
      }
    } catch (e) {
      debugPrint("Prediction Error: $e");
      setState(() {
        _prediction = {
          "predictedExpense": 0.0,
          "predictedSavings": 0.0,
          "suggestedBudget": 0.0
        };
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Spending Prediction Report"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<TransactionModel>>(
        stream: _transactionService.getTransactions(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final transactions = snapshot.data!;
          _fetchPrediction(transactions); // 🔁 Automatically run on every change

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCard("📉 Predicted Expense (Next Month)",
                    "\$${_prediction["predictedExpense"]?.toStringAsFixed(2) ?? '0.00'}"),
                const SizedBox(height: 16),
                _buildCard("💰 Predicted Savings",
                    "\$${_prediction["predictedSavings"]?.toStringAsFixed(2) ?? '0.00'}"),
                const SizedBox(height: 16),
                _buildCard("📊 Suggested Monthly Budget",
                    "\$${_prediction["suggestedBudget"]?.toStringAsFixed(2) ?? '0.00'}"),
                const SizedBox(height: 32),
                const Text(
                  "Warning: If your spending stays consistent, this is how your finances may look next month.",
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard(String title, String value) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(value,
                style: const TextStyle(fontSize: 20, color: Colors.teal)),
          ],
        ),
      ),
    );
  }
}
