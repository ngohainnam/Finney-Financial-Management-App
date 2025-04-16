import 'package:finney/pages/3-dashboard/models/transaction_model.dart';
import 'package:intl/intl.dart';

class TransactionParser {
  static bool hasTransactionInfo(String message) {
    return message.contains("I detected a transaction:");
  }

  static bool isConfirmingTransaction(String message) {
    String lowercase = message.toLowerCase();
    return lowercase.contains('yes');
  }

  static bool isCancelingTransaction(String message) {
    String lowercase = message.toLowerCase();
    return lowercase.contains('no');
  }
  
  static Map<String, dynamic>? extractTransactionFromMessage(String message) {
    try {
      RegExp amountRegex = RegExp(r'Amount:\s+\$(\d+(?:\.\d{2})?)');
      final amountMatch = amountRegex.firstMatch(message);
      if (amountMatch == null) return null;
      double amount = double.parse(amountMatch.group(1) ?? '0');
      
      RegExp nameRegex = RegExp(r'Name:\s+(.+)');
      final nameMatch = nameRegex.firstMatch(message);
      String name = nameMatch?.group(1)?.trim() ?? 'Unknown';
      
      RegExp categoryRegex = RegExp(r'Category:\s+(.+)');
      final categoryMatch = categoryRegex.firstMatch(message);
      String category = categoryMatch?.group(1)?.trim() ?? 'Others';
      
      RegExp dateRegex = RegExp(r'Date:\s+(.+)');
      final dateMatch = dateRegex.firstMatch(message);
      String dateStr = dateMatch?.group(1)?.trim() ?? '';
      
      DateTime date;
      try {
        if (dateStr.contains(',')) {
          date = DateFormat('MMM d, yyyy').parse(dateStr);
        } else {
          date = DateTime.now();
        }
      } catch (e) {
        date = DateTime.now();
      }
      
      RegExp descRegex = RegExp(r'Description:\s+(.+)');
      final descMatch = descRegex.firstMatch(message);
      String description = descMatch?.group(1)?.trim() ?? '';
      
      return {
        'amount': amount,
        'name': name,
        'category': category,
        'date': date,
        'description': description,
      };
    } catch (e) {
      return null;
    }
  }
  
  static TransactionModel createTransactionModel(Map<String, dynamic> data) {
    return TransactionModel(
      name: data['name'], 
      category: data['category'],
      amount: -data['amount'],
      date: data['date'],
      description: data['description'],
    );
  }
}