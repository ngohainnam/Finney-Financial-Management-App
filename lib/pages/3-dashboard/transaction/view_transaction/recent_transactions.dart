import 'package:finney/pages/3-dashboard/models/transaction_model.dart';
import 'package:finney/pages/3-dashboard/transaction/view_transaction/all_transactions.dart';
import 'package:finney/pages/3-dashboard/transaction/widgets/transaction_list.dart';
import 'package:finney/components/time_selector.dart'; // Add this import
import 'package:flutter/material.dart';
import 'package:finney/assets/theme/app_color.dart';

class RecentTransactions extends StatefulWidget {
  final List<TransactionModel> transactions;
  final Function(TransactionModel)? onDeleteTransaction;
  // Add these parameters
  final TimeRangeData timeRange;
  final Function(TimeRangeData) onTimeRangeChanged;

  const RecentTransactions({
    super.key,
    required this.transactions,
    this.onDeleteTransaction,
    required this.timeRange,
    required this.onTimeRangeChanged,
  });

  @override
  State<RecentTransactions> createState() => _RecentTransactionsState();
}

class _RecentTransactionsState extends State<RecentTransactions> {
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
    // Show only the 5 most recent transactions from the time-filtered list
    final recentTransactions = widget.transactions.take(5).toList();

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
                _isDeleteMode ? 'Select Items to Delete' : 'Transactions',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBlue,
                ),
              ),
              Row(
                children: [
                  if (!_isDeleteMode)
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: recentTransactions.isEmpty ? null : _toggleDeleteMode,
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
                              timeRange: widget.timeRange,
                              onTimeRangeChanged: widget.onTimeRangeChanged,
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
          if (recentTransactions.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No transactions in this period',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            TransactionList(
              transactions: recentTransactions,
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