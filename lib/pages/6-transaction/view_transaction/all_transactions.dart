import 'package:finney/shared/theme/app_color.dart';
import 'package:finney/pages/7-insights/components/time_selector.dart';
import 'package:finney/core/storage/cloud/models/transaction_model.dart';
import 'package:finney/core/storage/cloud/service/transaction_cloud_service.dart';
import 'package:finney/core/storage/storage_manager.dart'; // Added for getting the singleton
import 'package:finney/pages/6-transaction/widgets/transaction_list.dart';
import 'package:finney/pages/3-dashboard/widgets/delete_transaction_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/shared/localization/locales.dart';

class AllTransactionsScreen extends StatefulWidget {
  final List<TransactionModel> transactions;
  final Function(TransactionModel)? onDeleteTransaction;
  // Add these parameters
  final TimeRangeData timeRange;
  final Function(TimeRangeData) onTimeRangeChanged;

  const AllTransactionsScreen({
    super.key,
    required this.transactions,
    this.onDeleteTransaction,
    required this.timeRange,
    required this.onTimeRangeChanged,
  });

  @override
  State<AllTransactionsScreen> createState() => _AllTransactionsScreenState();
}

class _AllTransactionsScreenState extends State<AllTransactionsScreen> {
  late final TransactionCloudService _transactionService;
  bool _isDeleteMode = false;
  final Set<String> _selectedTransactionIds = {};
  late TimeRangeData _currentTimeRange;

  @override
  void initState() {
    super.initState();
    _currentTimeRange = widget.timeRange;
    // Get the transaction service from the StorageManager
    _transactionService = StorageManager().transactionService;
  }

  @override
  void didUpdateWidget(AllTransactionsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.timeRange != oldWidget.timeRange) {
      _currentTimeRange = widget.timeRange;
    }
  }

  void _toggleDeleteMode() {
    setState(() {
      _isDeleteMode = !_isDeleteMode;
      if (!_isDeleteMode) {
        _selectedTransactionIds.clear();
      }
    });
  }

  void _toggleTransactionSelection(TransactionModel transaction) {
    if (transaction.id == null) return;
    
    setState(() {
      if (_selectedTransactionIds.contains(transaction.id!)) {
        _selectedTransactionIds.remove(transaction.id!);
      } else {
        _selectedTransactionIds.add(transaction.id!);
      }
    });
  }
  
  List<TransactionModel> _getSelectedTransactions(List<TransactionModel> allTransactions) {
    return allTransactions
        .where((transaction) => _selectedTransactionIds.contains(transaction.id))
        .toList();
  }

  Future<void> _showDeleteConfirmationDialog(List<TransactionModel> transactions) async {
    final selectedTransactions = _getSelectedTransactions(transactions);
    if (selectedTransactions.isEmpty) return;

    final confirmed = await DeleteTransactionDialog.show(
      context,
      message: LocaleData.confirmDeleteAction
        .getString(context)
        .replaceFirst('%d', selectedTransactions.length.toString()),
      title: LocaleData.deleteTransactions.getString(context),
    );

    if (confirmed) {
      for (var transaction in selectedTransactions) {
        // Delete via service first
        if (transaction.id != null) {
          await _transactionService.deleteTransaction(transaction.id!);
        }
        // Then notify parent via callback if needed
        widget.onDeleteTransaction?.call(transaction);
      }
      _selectedTransactionIds.clear();
      _toggleDeleteMode();
    }
  }

  List<TransactionModel> _filterTransactionsByTimeRange(List<TransactionModel> transactions) {
    final startDate = _currentTimeRange.startDate;
    final endDate = _currentTimeRange.endDate.add(const Duration(days: 1));
    
    return transactions.where((transaction) {
      final date = transaction.date;
      return date.isAfter(startDate) && date.isBefore(endDate);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isDeleteMode
            ? LocaleData.selectItemsToDelete.getString(context)
            : LocaleData.transactions.getString(context),
          style: const TextStyle(
            color: AppColors.primary,
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
            StreamBuilder<List<TransactionModel>>(
              stream: _transactionService.getTransactions(), // Use core service
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const IconButton(
                    icon: Icon(Icons.delete, color: Colors.grey),
                    onPressed: null,
                  );
                }
                
                final transactions = _filterTransactionsByTimeRange(snapshot.data!);
                final selectedTransactions = _getSelectedTransactions(transactions);
                
                return IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: selectedTransactions.isEmpty 
                    ? null 
                    : () => _showDeleteConfirmationDialog(transactions),
                );
              },
            ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Time selector at the top
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TimeRangeSelector(
              initialTimeRange: _currentTimeRange,
              onTimeRangeChanged: (newTimeRange) {
                setState(() {
                  _currentTimeRange = newTimeRange;
                });
                widget.onTimeRangeChanged(newTimeRange);
              },
            ),
          ),
          
          // Transaction list below
          Expanded(
            child: StreamBuilder<List<TransactionModel>>(
              stream: _transactionService.getTransactions(), // Use core service
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(LocaleData.errorLoadingTransactions.getString(context)),
                  );
                }
      
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
      
                final allTransactions = snapshot.data!;
                final filteredTransactions = _filterTransactionsByTimeRange(allTransactions);
      
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: TransactionList(
                      transactions: filteredTransactions,
                      onDeleteTransaction: (transaction) {
                        // Delete via service first
                        if (transaction.id != null) {
                          _transactionService.deleteTransaction(transaction.id!);
                        }
                        // Then notify parent
                        widget.onDeleteTransaction?.call(transaction);
                      },
                      showAll: true,
                      isDeleteMode: _isDeleteMode,
                      selectedTransactions: Set<TransactionModel>.from(
                        _getSelectedTransactions(filteredTransactions)
                      ),
                      onTransactionSelected: _toggleTransactionSelection,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}