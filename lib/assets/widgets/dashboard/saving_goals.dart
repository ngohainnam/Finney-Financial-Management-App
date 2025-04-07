import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/models/transaction_model.dart';
import 'package:finney/services/transaction_services.dart';

class AddSavingGoalScreen extends StatelessWidget {
  const AddSavingGoalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saving Goals')),
      body: ListView(
        children: [
          // Your existing goal cards
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOptionsModal(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Add the _showAddOptionsModal and _buildOptionButton methods here
  void _showAddOptionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            children: [
              _buildOptionButton(
                context: context,
                label: 'Saving Goal',
                icon: Icons.savings,
                color: Colors.green,
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to the Add Saving Goal screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddSavingGoalScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _buildOptionButton(
                context: context,
                label: 'Budget',
                icon: Icons.savings,
                color: Colors.green,
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to the Add Budget screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddSavingGoalScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
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
            child: Center(child: Icon(icon, color: color, size: 40)),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
