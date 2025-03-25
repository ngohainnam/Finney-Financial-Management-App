import 'package:flutter/material.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/pages/3-dashboard/widgets/balance_card.dart';
import 'package:finney/pages/3-dashboard/widgets/spending_chart.dart';
import 'package:finney/pages/3-dashboard/widgets/category_breakdown.dart';
import 'package:finney/pages/3-dashboard/widgets/recent_transactions.dart';
import 'package:finney/pages/3-dashboard/models/transaction_data.dart';
import 'package:finney/pages/3-dashboard/add_transaction.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BalanceCard(
              balance: 12680.50,
              income: 3520.80,
              expenses: 2230.40,
            ),
            const SizedBox(height: 20),
            const SpendingChart(weeklyExpenses: sampleWeeklyExpenses),
            const SizedBox(height: 20),
            const CategoryBreakdown(categoryExpenses: sampleCategoryExpenses),
            const SizedBox(height: 20),
            RecentTransactions(
              transactions: sampleTransactions,
              onSeeAllPressed: () {
                // Navigate to all transactions
              },
            ),
            // Add padding at the bottom to account for the navbar
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          _showAddTransactionModal(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

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
                    // Navigate to add expense screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddTransactionScreen(isIncome: false)
                        )
                    );
                  },
                ),
                _buildOptionButton(
                  context: context,
                  label: 'Income',
                  icon: Icons.add_circle_outline,
                  color: Colors.green,
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to add income screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddTransactionScreen(isIncome: true)
                        )
                    );
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

    final backgroundColor = const Color(0xFFF5F5F5);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 1),
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