import 'package:flutter/material.dart';
import 'package:visualize_infinance/models/expense_model.dart';
import 'package:visualize_infinance/utils/constants.dart';
import 'package:visualize_infinance/widgets/balance_card.dart';
import 'package:visualize_infinance/widgets/category_chart.dart';
import 'package:visualize_infinance/widgets/recent_transactions.dart';
import 'package:visualize_infinance/widgets/weekly_chart.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool _isLoading = true;

  // Sample data for testing
  late List<Transaction> _transactions;
  late List<ExpenseData> _weeklyExpenses;
  late List<CategoryExpense> _categoryExpenses;
  late Map<String, double> _financialSummary;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // Use sample data
    _transactions = DummyData.getRecentTransactions();
    _weeklyExpenses = DummyData.getWeeklyExpenses();
    _categoryExpenses = DummyData.getCategoryExpenses();
    _financialSummary = DummyData.getFinancialSummary();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: colorScheme.primary,
              child: const Text('JD'),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account Balance Card
              BalanceCard(
                balance: _financialSummary['totalBalance'] ?? 0.0,
                income: _financialSummary['monthlyIncome'] ?? 0.0,
                expenses: _financialSummary['monthlyExpenses'] ?? 0.0,
              ),

              const SizedBox(height: 24),

              // Weekly Spending Section
              const Text(
                'Spending Analysis',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // Weekly Spending Chart
              WeeklySpendingChart(weeklyExpenses: _weeklyExpenses),

              const SizedBox(height: 24),

              // Category Spending Section
              const Text(
                'Spending by Category',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              // Category Spending Chart
              CategorySpendingChart(categoryExpenses: _categoryExpenses),

              const SizedBox(height: 24),

              // Recent Transactions Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Transactions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to all transactions
                    },
                    child: Text(
                      'See All',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Recent Transactions List
              RecentTransactions(
                transactions: _transactions,
                onSeeAllPressed: () {
                  // Navigate to all transactions
                },
              ),
            ],
          ),
        ),
      ),
      // Floating Action Button for adding transactions
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTransactionModal(context);
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, size: 28),
        elevation: 4,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // Show modal for choosing between adding income or expense
  void _showAddTransactionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add Transaction',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOptionButton(
                  context: context,
                  label: 'Expense',
                  icon: Icons.remove_circle_outline,
                  color: Colors.red,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/add_transaction', arguments: false);
                  },
                ),
                _buildOptionButton(
                  context: context,
                  label: 'Income',
                  icon: Icons.add_circle_outline,
                  color: Colors.green,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/add_transaction', arguments: true);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon,
                color: color,
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}