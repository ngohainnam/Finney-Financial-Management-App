import 'package:finney/core/storage/cloud/models/transaction_model.dart';
import 'package:finney/shared/widgets/common/app_dialog.dart';
import 'package:finney/pages/6-transaction/view_transaction/all_transactions.dart';
import 'package:finney/pages/6-transaction/widgets/transaction_list.dart';
import 'package:finney/pages/7-insights/components/time_selector.dart';
import 'package:flutter/material.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:finney/shared/widgets/common/settings_notifier.dart';

class RecentTransactions extends StatefulWidget {
  final List<TransactionModel> transactions;
  final Function(dynamic)? onDeleteTransaction; // Accepts single or list
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

    final confirmed = await AppDialog.show(
      context,
      message: LocaleData.confirmDeleteAction
          .getString(context)
          .replaceFirst('%d', _selectedTransactions.length.toString()),
      title: LocaleData.deleteTransactions.getString(context),
    );

    if (confirmed) {
      // Call the callback with a list for multiple, or single for one
      if (_selectedTransactions.length == 1) {
        widget.onDeleteTransaction?.call(_selectedTransactions.first);
      } else {
        widget.onDeleteTransaction?.call(_selectedTransactions.toList());
      }
      _selectedTransactions.clear();
      _toggleDeleteMode();
    }
  }

  @override
  Widget build(BuildContext context) {
    final recentTransactions = widget.transactions.take(5).toList();

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
          child: Container(
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
                      _isDeleteMode
                          ? LocaleData.selectItemsToDelete.getString(context)
                          : LocaleData.transactions.getString(context),
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
                            icon: const Icon(Icons.delete_outline, color: AppColors.darkBlue),
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
                              LocaleData.seeAll.getString(context),
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
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        LocaleData.noTransactionsInThisPeriod.getString(context),
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
          ),
        );
      },
    );
  }
}