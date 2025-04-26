import 'package:finney/pages/3-dashboard/models/transaction_model.dart';
import 'package:finney/pages/3-dashboard/transaction/transaction_services.dart';
import 'package:intl/intl.dart';

class TransactionRAGService {
  final TransactionService _transactionService = TransactionService();
  
  /// Retrieves user transaction data and formats it for RAG context
  Future<String> getTransactionContext() async {
    try {
      // Wait for transactions to be retrieved
      final transactionsFuture = _transactionService.getTransactions().first;
      final transactions = await transactionsFuture;
      
      if (transactions.isEmpty) {
        return "No transactions found in your records.";
      }
      
      // Get monthly stats
      final income = await _transactionService.getCurrentMonthIncome();
      final expenses = await _transactionService.getCurrentMonthExpenses();
      final balance = income - expenses;
      
      // Get category expenses for insights
      final categoryExpenses = await _transactionService.getCategoryExpenses();
      String categoryInsights = _formatCategoryInsights(categoryExpenses);
      
      // Format all transactions, grouped by month
      String formattedTransactions = _formatAllTransactions(transactions);
      
      // Build the context
      String context = """
User's Transaction Data:
- Current Month Income: ${NumberFormat.currency(symbol: '\$').format(income)}
- Current Month Expenses: ${NumberFormat.currency(symbol: '\$').format(expenses)}
- Current Balance: ${NumberFormat.currency(symbol: '\$').format(balance)}

$categoryInsights

Transaction History (All Transactions):
$formattedTransactions
""";
      
      return context;
    } catch (e) {
      return "Error retrieving transaction data: $e";
    }
  }
  
  String _formatAllTransactions(List<TransactionModel> transactions) {
    if (transactions.isEmpty) return "No transactions found.";
    
    final dateFormat = DateFormat('MMM d, yyyy');
    final monthFormat = DateFormat('MMMM yyyy');
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final buffer = StringBuffer();
    
    // Group transactions by month
    Map<String, List<TransactionModel>> transactionsByMonth = {};
    
    for (var transaction in transactions) {
      final monthKey = monthFormat.format(transaction.date);
      if (!transactionsByMonth.containsKey(monthKey)) {
        transactionsByMonth[monthKey] = [];
      }
      transactionsByMonth[monthKey]!.add(transaction);
    }
    
    // Sort months chronologically (most recent first)
    final sortedMonths = transactionsByMonth.keys.toList()
      ..sort((a, b) {
        DateTime dateA = DateFormat('MMMM yyyy').parse(a);
        DateTime dateB = DateFormat('MMMM yyyy').parse(b);
        return dateB.compareTo(dateA);  // Most recent first
      });
    
    // Format transactions by month
    for (var month in sortedMonths) {
      buffer.writeln("\n## $month");
      
      final monthTransactions = transactionsByMonth[month]!;
      // Sort transactions by date (most recent first)
      monthTransactions.sort((a, b) => b.date.compareTo(a.date));
      
      double monthlyIncome = 0;
      double monthlyExpense = 0;
      
      for (var transaction in monthTransactions) {
        final amount = transaction.amount;
        if (amount > 0) {
          monthlyIncome += amount;
        } else {
          monthlyExpense += amount.abs();
        }
        
        final formattedAmount = transaction.isIncome 
            ? "+${currencyFormat.format(transaction.amount)}" 
            : currencyFormat.format(transaction.amount);
        
        buffer.writeln("- ${dateFormat.format(transaction.date)}: ${transaction.name} (${transaction.category}) - $formattedAmount");
        if (transaction.description != null && transaction.description!.isNotEmpty) {
          buffer.writeln("  Description: ${transaction.description}");
        }
      }
      
      // Add monthly summary
      buffer.writeln("  Monthly Income: ${currencyFormat.format(monthlyIncome)}");
      buffer.writeln("  Monthly Expenses: ${currencyFormat.format(monthlyExpense)}");
      buffer.writeln("  Monthly Balance: ${currencyFormat.format(monthlyIncome - monthlyExpense)}");
    }
    
    return buffer.toString();
  }
  
  String _formatCategoryInsights(List<CategoryExpense> categoryExpenses) {
    if (categoryExpenses.isEmpty) return "No category insights available.";
    
    final currencyFormat = NumberFormat.currency(symbol: '\$');
    final buffer = StringBuffer("Top Spending Categories:\n");
    
    // Sort and include all categories
    final sortedCategories = List.of(categoryExpenses)
      ..sort((a, b) => b.amount.compareTo(a.amount));
    
    for (var category in sortedCategories) {
      buffer.writeln("- ${category.name}: ${currencyFormat.format(category.amount)}");
    }
    
    return buffer.toString();
  }
}