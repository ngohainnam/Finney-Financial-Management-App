import 'package:flutter/material.dart';
import 'package:visualize_infinance/models/expense_model.dart';
import 'package:visualize_infinance/services/firebase_database.dart';

class TransactionProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  // Data containers
  List<Transaction> _transactions = [];
  List<Transaction> _recentTransactions = [];
  List<ExpenseData> _weeklyExpenses = [];
  List<CategoryExpense> _categoryExpenses = [];
  Map<String, double> _financialSummary = {
    'totalBalance': 0.0,
    'monthlyIncome': 0.0,
    'monthlyExpenses': 0.0,
  };

  bool _isLoading = true;
  bool _useDummyData = true; // For development

  // Getters
  List<Transaction> get transactions => _transactions;
  List<Transaction> get recentTransactions => _recentTransactions;
  List<ExpenseData> get weeklyExpenses => _weeklyExpenses;
  List<CategoryExpense> get categoryExpenses => _categoryExpenses;
  Map<String, double> get financialSummary => _financialSummary;
  bool get isLoading => _isLoading;

  // Constructor
  TransactionProvider() {
    fetchData();
  }

  // Fetch data
  Future<void> fetchData() async {
    _isLoading = true;
    notifyListeners();

    if (_useDummyData) {
      // Use dummy data for testing
      await Future.delayed(Duration(milliseconds: 500));
      _transactions = DummyData.getRecentTransactions();
      _recentTransactions = _transactions.take(5).toList();
      _weeklyExpenses = DummyData.getWeeklyExpenses();
      _categoryExpenses = DummyData.getCategoryExpenses();
      _financialSummary = DummyData.getFinancialSummary();

      _isLoading = false;
      notifyListeners();
    } else {
      // Setting up Firebase transaction listener
      print("Setting up Firebase transaction listener");
      _firebaseService.getCurrentMonthTransactions().listen((transactions) {
        print("Received ${transactions.length} transactions from Firebase");
        _transactions = transactions;
        _recentTransactions = transactions.take(5).toList();

        // Process the transactions to generate charts and summaries
        if (transactions.isNotEmpty) {
          _weeklyExpenses = _firebaseService.calculateWeeklyExpenses(transactions);
          _categoryExpenses = _firebaseService.calculateCategoryExpenses(transactions);
          _financialSummary = _firebaseService.calculateFinancialSummary(transactions);
        } else {
          // Fallback if no transactions
          _weeklyExpenses = [];
          _categoryExpenses = [];
          _financialSummary = {
            'totalBalance': 0.0,
            'monthlyIncome': 0.0,
            'monthlyExpenses': 0.0,
          };
        }

        _isLoading = false;
        notifyListeners();
      });
    }
  }

  // Add a new transaction
  Future<bool> addTransaction(Transaction transaction) async {
    _isLoading = true;
    notifyListeners();

    if (_useDummyData) {
      // Just add to local list
      _transactions.insert(0, transaction);
      _recentTransactions = _transactions.take(5).toList();

      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      // Add to Firebase
      String? docId = await _firebaseService.addTransaction(transaction);
      _isLoading = false;
      notifyListeners();
      return docId != null;
    }
  }

  // Toggle between dummy data and Firebase
  void toggleDataSource() {
    _useDummyData = !_useDummyData;
    fetchData();
  }
}