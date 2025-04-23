import 'package:finney/pages/3-dashboard/models/transaction_model.dart';
import 'package:finney/pages/3-dashboard/transaction/view_transaction/all_transactions.dart';
import 'package:finney/pages/3-dashboard/transaction/widgets/transaction_list.dart';
import 'package:flutter/material.dart';
import 'package:finney/assets/theme/app_color.dart';

class RecentTransactions extends StatefulWidget {
  final List<TransactionModel> transactions;
  final Function(TransactionModel)? onDeleteTransaction;

  const RecentTransactions({
    super.key,
    required this.transactions,
    this.onDeleteTransaction,
  });

  @override
  State<RecentTransactions> createState() => _RecentTransactionsState();
}

class _RecentTransactionsState extends State<RecentTransactions> {
  bool _isDeleteMode = false;
  final Set<TransactionModel> _selectedTransactions = {};

  void _toggleDeleteMode() {
    setState(() {
      // Toggle delete mode
      _isDeleteMode = !_isDeleteMode;

      // If exiting delete mode, clear all selections
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isDeleteMode ? 'Select Items to Delete' : 'Recent Transactions',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  if (!_isDeleteMode)
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: _toggleDeleteMode,
                    )
                  else ...[
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: _toggleDeleteMode,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: _selectedTransactions.isEmpty ? null : _showDeleteConfirmationDialog,
                    ),
                  ],
                  if (!_isDeleteMode)
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AllTransactionsScreen(
                              transactions: widget.transactions,
                              onDeleteTransaction: widget.onDeleteTransaction,
                            ),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      child: Text(
                        'See All',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          TransactionList(
            transactions: widget.transactions,
            onDeleteTransaction: widget.onDeleteTransaction,
            showAll: false,
            isDeleteMode: _isDeleteMode,
            selectedTransactions: _selectedTransactions,
            onTransactionSelected: _toggleTransactionSelection,
          ),
        ],
      ),
    );
  }
}