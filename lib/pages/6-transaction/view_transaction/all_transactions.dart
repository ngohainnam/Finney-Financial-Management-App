import 'package:finney/shared/theme/app_color.dart';
import 'package:finney/pages/7-insights/components/time_selector.dart';
import 'package:finney/core/storage/cloud/models/transaction_model.dart';
import 'package:finney/core/storage/cloud/service/transaction_cloud_service.dart';
import 'package:finney/core/storage/storage_manager.dart';
import 'package:finney/pages/6-transaction/widgets/transaction_list.dart';
import 'package:finney/shared/widgets/common/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:finney/shared/widgets/common/settings_notifier.dart';

class AllTransactionsScreen extends StatefulWidget {
  final List<TransactionModel> transactions;
  final Function(dynamic)? onDeleteTransaction; // Accepts single or list
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

    final confirmed = await AppDialog.show(
      context,
      message: LocaleData.confirmDeleteAction
        .getString(context)
        .replaceFirst('%d', selectedTransactions.length.toString()),
      title: LocaleData.deleteTransactions.getString(context),
    );

    if (confirmed) {
      // Delete all selected transactions in parallel
      await Future.wait(selectedTransactions.map((transaction) async {
        if (transaction.id != null) {
          await _transactionService.deleteTransaction(transaction.id!);
        }
      }));

      // Notify parent ONCE with the list or single
      if (widget.onDeleteTransaction != null) {
        if (selectedTransactions.length == 1) {
          widget.onDeleteTransaction!(selectedTransactions.first);
        } else {
          widget.onDeleteTransaction!(selectedTransactions);
        }
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
    return ValueListenableBuilder<String>(
      valueListenable: SettingsNotifier().textSizeNotifier,
      builder: (context, textSize, child) {
        double textScaleFactor;
        switch (textSize) {
          case 'Small':
            textScaleFactor = 0.8;
            break;
          case 'Large':
            textScaleFactor = 1.2;
            break;
          default:
            textScaleFactor = 1.0;
        }
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScaleFactor),
          ),
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                _isDeleteMode
                  ? LocaleData.selectItemsToDelete.getString(context)
                  : LocaleData.transactions.getString(context),
                style: const TextStyle(
                  color: AppColors.darkBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  letterSpacing: 1.2,
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
                    icon: const Icon(Icons.delete_outline, color: AppColors.darkBlue),
                    onPressed: _toggleDeleteMode,
                  )
                else
                  StreamBuilder<List<TransactionModel>>(
                    stream: _transactionService.getTransactions(),
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
                Expanded(
                  child: StreamBuilder<List<TransactionModel>>(
                    stream: _transactionService.getTransactions(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(LocaleData.errorLoadingTransactions.getString(context)),
                        );
                      }
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2));
                      }
                      final allTransactions = snapshot.data!;
                      final filteredTransactions = _filterTransactionsByTimeRange(allTransactions);
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: TransactionList(
                            transactions: filteredTransactions,
                            onDeleteTransaction: widget.onDeleteTransaction,
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
          ),
        );
      },
    );
  }
}