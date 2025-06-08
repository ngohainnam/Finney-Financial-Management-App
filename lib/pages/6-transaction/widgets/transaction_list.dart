import 'package:finney/core/storage/cloud/models/transaction_model.dart';
import 'package:finney/shared/localization/localized_number_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:finney/pages/6-transaction/widgets/transaction_item.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:finney/shared/widgets/common/settings_notifier.dart';

class TransactionList extends StatelessWidget {
  final List<TransactionModel> transactions;
  final Function(TransactionModel)? onDeleteTransaction;
  final bool showAll;
  final bool isDeleteMode;
  final Set<TransactionModel> selectedTransactions;
  final Function(TransactionModel)? onTransactionSelected;

  const TransactionList({
    super.key,
    required this.transactions,
    this.onDeleteTransaction,
    this.showAll = false,
    this.isDeleteMode = false,
    this.selectedTransactions = const {},
    this.onTransactionSelected,
  });

  Map<String, List<TransactionModel>> _groupTransactionsByDate() {
    final groupedTransactions = <String, List<TransactionModel>>{};

    final transactionList = showAll
        ? transactions
        : transactions.take(5).toList();

    for (var transaction in transactionList) {
      final date = DateFormat('yyyy-MM-dd').format(transaction.date);
      if (!groupedTransactions.containsKey(date)) {
        groupedTransactions[date] = [];
      }
      groupedTransactions[date]!.add(transaction);
    }

    final sortedDates = groupedTransactions.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Map.fromEntries(
        sortedDates.map((date) => MapEntry(date, groupedTransactions[date]!))
    );
  }

  String _formatDate(String date, BuildContext context) {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    final transactionDate = DateTime.parse(date);

    if (DateFormat('yyyy-MM-dd').format(today) == date) {
      return LocaleData.today.getString(context);
    } else if (DateFormat('yyyy-MM-dd').format(yesterday) == date) {
      return LocaleData.yesterday.getString(context);
    }
    String formatted = DateFormat('MMMM d, yyyy').format(transactionDate);
    return LocalizedNumberFormatter.formatDate(formatted, context);
  }

  @override
  Widget build(BuildContext context) {
    final groupedTransactions = _groupTransactionsByDate();

    if (transactions.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            LocaleData.noTransactionsYet.getString(context),
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

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
          child: Column(
            children: groupedTransactions.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      _formatDate(entry.key, context),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkBlue,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.softGray,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: entry.value.map((transaction) {
                        return TransactionItem(
                          transaction: transaction,
                          onDelete: onDeleteTransaction,
                          isDeleteMode: isDeleteMode,
                          isSelected: selectedTransactions.contains(transaction),
                          onSelected: onTransactionSelected,
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }
}