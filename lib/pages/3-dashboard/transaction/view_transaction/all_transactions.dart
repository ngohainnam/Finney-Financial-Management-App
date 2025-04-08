import 'package:finney/pages/3-dashboard/models/transaction_model.dart';
import 'package:finney/pages/3-dashboard/transaction/widgets/transaction_list.dart';
import 'package:flutter/material.dart';

class AllTransactionsScreen extends StatelessWidget {
  final List<TransactionModel> transactions;
  final Function(TransactionModel)? onDeleteTransaction;

  const AllTransactionsScreen({
    super.key,
    required this.transactions,
    this.onDeleteTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Transactions',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.white,
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: TransactionList(
            transactions: transactions,
            onDeleteTransaction: onDeleteTransaction,
            showAll: true,
          ),
        ),
      ),
    );
  }
}