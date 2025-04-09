import 'package:finney/pages/3-dashboard/models/transaction_model.dart';
import 'package:finney/pages/3-dashboard/services/transaction_services.dart';
import 'package:finney/pages/3-dashboard/transaction/widgets/transaction_list.dart';
import 'package:flutter/material.dart';

class AllTransactionsScreen extends StatefulWidget {
  final List<TransactionModel> transactions;
  final Function(TransactionModel)? onDeleteTransaction;

  const AllTransactionsScreen({
    super.key,
    required this.transactions,
    this.onDeleteTransaction,
  });

  @override
  State<AllTransactionsScreen> createState() => _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends State<AllTransactionsScreen> {
  final TransactionService _transactionService = TransactionService();
  
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
      
      body: StreamBuilder<List<TransactionModel>>(
        stream: _transactionService.getTransactions(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final transactions = snapshot.data!;
          
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TransactionList(
                transactions: transactions,
                onDeleteTransaction: widget.onDeleteTransaction,
                showAll: true,
              ),
            ),
          );
        },
      ),
    );
  }
}