import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:visualize_infinance/models/expense_model.dart';

class FirebaseService {
  // Firestore instance
  final firestore.FirebaseFirestore _db = firestore.FirebaseFirestore.instance;

  // Use a fixed user ID for demo purposes
  final String _userId = 'demo_user_123';

  // Simple getters
  String get userId => _userId;
  bool get isLoggedIn => true; // Always return true for demo

  // Initialize (without auth)
  Future<void> initialize() async {
    // Check if the demo user has any data
    await _checkAndAddSampleData(_userId);
  }

  // Check if user has transactions and add sample data if needed
  Future<void> _checkAndAddSampleData(String userId) async {
    try {
      var snapshot = await _db
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .limit(1)
          .get();

      // Add sample data for new users
      if (snapshot.docs.isEmpty) {
        print("New user detected - adding sample data");
        await _addSampleTransactions(userId);
      }
    } catch (e) {
      print('Error checking for existing data: $e');
    }
  }

  // Add sample transactions for demo
  Future<void> _addSampleTransactions(String userId) async {
    final now = DateTime.now();

    // Sample transactions to add
    final sampleTransactions = [
      {
        'name': 'Salary Deposit',
        'category': 'Income',
        'amount': 2850.00,
        'date': DateTime(now.year, now.month, 1).millisecondsSinceEpoch,
      },
      {
        'name': 'Rent Payment',
        'category': 'Bills & Utilities',
        'amount': -1200.00,
        'date': DateTime(now.year, now.month, 3).millisecondsSinceEpoch,
      },
      {
        'name': 'Grocery Shopping',
        'category': 'Food & Dining',
        'amount': -85.75,
        'date': DateTime(now.year, now.month, now.day - 5).millisecondsSinceEpoch,
      },
      {
        'name': 'Netflix Subscription',
        'category': 'Entertainment',
        'amount': -15.99,
        'date': DateTime(now.year, now.month, 10).millisecondsSinceEpoch,
      },
      {
        'name': 'Gas Station',
        'category': 'Transportation',
        'amount': -45.50,
        'date': DateTime(now.year, now.month, now.day - 3).millisecondsSinceEpoch,
      },
    ];

    // Add all sample transactions to Firestore
    final batch = _db.batch();
    for (var transaction in sampleTransactions) {
      firestore.DocumentReference docRef = _db
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .doc();
      batch.set(docRef, transaction);
    }

    await batch.commit();
    print("Added sample transactions for demo user");
  }

  // Add a transaction to Firestore
  Future<String?> addTransaction(Transaction transaction) async {
    try {
      firestore.DocumentReference doc = await _db
          .collection('users')
          .doc(userId)
          .collection('transactions')
          .add(transaction.toMap());

      return doc.id;
    } catch (e) {
      print('Error adding transaction: $e');
      return null;
    }
  }

  // Get all transactions for the current user
  Stream<List<Transaction>> getTransactions() {
    return _db
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Transaction.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Get transactions for the current month
  Stream<List<Transaction>> getCurrentMonthTransactions() {
    // Calculate month boundaries
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final lastDay = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    return _db
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .where('date', isGreaterThanOrEqualTo: firstDay.millisecondsSinceEpoch)
        .where('date', isLessThanOrEqualTo: lastDay.millisecondsSinceEpoch)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Transaction.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // Calculate financial summary from transactions
  Map<String, double> calculateFinancialSummary(List<Transaction> transactions) {
    double income = 0;
    double expenses = 0;

    for (var tx in transactions) {
      if (tx.amount > 0) {
        income += tx.amount;
      } else {
        expenses += tx.amount.abs();
      }
    }

    return {
      'totalBalance': income - expenses,
      'monthlyIncome': income,
      'monthlyExpenses': expenses,
    };
  }

  // Other methods...
  List<ExpenseData> calculateWeeklyExpenses(List<Transaction> transactions) {
    // Implementation to be filled
    return [];
  }

  List<CategoryExpense> calculateCategoryExpenses(List<Transaction> transactions) {
    // Implementation to be filled
    return [];
  }
}