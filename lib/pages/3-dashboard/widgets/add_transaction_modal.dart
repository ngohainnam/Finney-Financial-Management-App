import 'package:flutter/material.dart';

void showAddTransactionModal({
  required BuildContext context,
  required VoidCallback onAddIncome,
  required VoidCallback onAddExpense,
}) {
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
                onTap: onAddExpense,
              ),
              _buildOptionButton(
                context: context,
                label: 'Income',
                icon: Icons.add_circle_outline,
                color: Colors.green,
                onTap: onAddIncome,
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