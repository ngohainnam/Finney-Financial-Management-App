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
  bool _isDeleteMode = false;
  final Set<TransactionModel> _selectedTransactions = {};

  void _toggleDeleteMode() {
    setState(() {
      _isDeleteMode = !_isDeleteMode;
      if (!_isDeleteMode) {
        _selectedTransactions.clear();
      }
    });
  }

  void _toggleTransactionSelection(TransactionModel transaction) {
    setState(() {
      if (_selectedTransactions.contains(transaction)) {
        _selectedTransactions.remove(transaction);
      } else {
        _selectedTransactions.add(transaction);
      }
    });
  }

  Future<void> _showDeleteConfirmationDialog() async {
    if (_selectedTransactions.isEmpty) return;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transactions'),
        content: Text(
          'Are you sure you want to delete ${_selectedTransactions.length} transaction(s)?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              for (var transaction in _selectedTransactions) {
                widget.onDeleteTransaction?.call(transaction);
              }
              _selectedTransactions.clear();
              _toggleDeleteMode();
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isDeleteMode ? 'Select Items to Delete' : 'All Transactions',
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            _isDeleteMode ? Icons.close : Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: _isDeleteMode ? _toggleDeleteMode : () => Navigator.pop(context),
        ),
        actions: [
          if (!_isDeleteMode)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.black),
              onPressed: _toggleDeleteMode,
            )
          else
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _selectedTransactions.isEmpty ? null : _showDeleteConfirmationDialog,
            ),
        ],
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
                isDeleteMode: _isDeleteMode,
                selectedTransactions: _selectedTransactions,
                onTransactionSelected: _toggleTransactionSelection,
              ),
            ),
          );
        },
      ),
    );
  }
}