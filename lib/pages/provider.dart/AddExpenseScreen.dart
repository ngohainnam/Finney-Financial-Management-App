import 'package:finney/assets/theme/app_color.dart';
import 'package:finney/assets/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'ExpenseProvider.dart';
import 'package:provider/provider.dart';

class AddExpenseScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();

  AddExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Expense')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) return 'Please enter an amount';
                return null;
              },
            ),
            DropdownButtonFormField(
              items:
                  ['Food', 'Transport', 'Entertainment'].map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
              onChanged: (value) {
                _categoryController.text = value!;
              },
              decoration: InputDecoration(labelText: 'Category'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final expense = Expense(
                    id: DateTime.now().toString(),
                    amount: double.parse(_amountController.text),
                    category: _categoryController.text,
                    date: DateTime.now(),
                    description: _descriptionController.text,
                  );
                  context.read<ExpenseProvider>().addExpense(expense);
                  Navigator.pop(context);
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
//UI for adding expense