import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:finney/models/transaction_model.dart';

class SavingPredCard extends StatefulWidget {
  final List<TransactionModel> transactions;

  const SavingPredCard({super.key, required this.transactions});

  @override
  State<SavingPredCard> createState() => _SavingPredCardState();
}

class _SavingPredCardState extends State<SavingPredCard> {
  int? lowerBound;
  int? upperBound;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchPrediction();
  }

  Future<void> fetchPrediction() async {
    if (widget.transactions.isEmpty){
      setState(() {
        error = "No Transaction to analyze.";
        isLoading = false;
      });
      return;
    }
  final uri = Uri.parse("http://10.0.2.2:5050/predict-savings");

  try {
    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "transactions": widget.transactions.map((tx) => {
          "amount": tx.amount,
          "date": tx.date.toIso8601String()
        }).toList()
      }),
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        lowerBound = data["lower_bound"];
        upperBound = data["upper_bound"];
        isLoading = false;
      });
    } else {
      setState(() {
        error = "Failed to fetch prediction.";
        isLoading = false;
      });
    }
  } catch (e) {
    setState(() {
      error = "Error: $e";
      isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
              ? Text(error!, style: const TextStyle(color: Colors.red))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Predicted Yearly Savings (ML)',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${lowerBound ?? 0} - \$${upperBound ?? 0}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.green),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Powered by Random Forest model',
                      style: TextStyle(color: Colors.grey[600]),
                    )
                  ],
                ),
      ),
    );
  }
}
