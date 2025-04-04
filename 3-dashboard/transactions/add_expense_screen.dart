import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finney/models/transaction_model.dart';
import 'package:finney/services/transaction_services.dart';

class AddExpenseScreen extends StatefulWidget {
  final Function? onExpenseAdded;

  const AddExpenseScreen({
    super.key,
    this.onExpenseAdded,
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = '';
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;
  final TransactionService _transactionService = TransactionService();

  // Pre-defined category data
  final List<CategoryData> _categories = [
    CategoryData('Shopping', Icons.shopping_bag, const Color(0xFFFF9800)),
    CategoryData('Food', Icons.restaurant, const Color(0xFF2196F3)),
    CategoryData('Entertainment', Icons.movie, const Color(0xFFE91E63)),
    CategoryData('Transport', Icons.directions_car, const Color(0xFF4CAF50)),
    CategoryData('Health', Icons.medical_services, const Color(0xFFF44336)),
    CategoryData('Utilities', Icons.phone, const Color(0xFF9C27B0)),
    CategoryData('Others', Icons.category_outlined, const Color(0xFF9E9E9E)),
  ];

  @override
  void initState() {
    super.initState();
    // Set default category
    if (_categories.isNotEmpty) {
      _selectedCategory = _categories[0].name;
    }

    // Initialize amount controller with 0.00
    _amountController.text = '0.00';
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveTransaction() async {
    // Validate and save transaction
    if (_amountController.text.isEmpty ||
        double.tryParse(_amountController.text.replaceAll(',', '.')) == null) {
      _showErrorSnackBar('Please enter a valid amount');
      return;
    }

    if (_selectedCategory.isEmpty) {
      _showErrorSnackBar('Please select a category');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Parse amount (negative for expenses)
      double amountValue = -double.parse(_amountController.text.replaceAll(',', '.'));

      // Create transaction model
      final transaction = TransactionModel(
        name: _selectedCategory,
        category: _selectedCategory,
        amount: amountValue,
        date: _selectedDate,
        description: _descriptionController.text.trim(),
      );

      // Optimistic UI update
      if (widget.onExpenseAdded != null) {
        widget.onExpenseAdded!(transaction);
      }

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Expense saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Go back to previous screen
      if (mounted) {
        Navigator.pop(context);
      }

      // Save to Firestore in the background
      _transactionService.addTransaction(transaction).catchError((e) {
        debugPrint('Error saving transaction: $e');
      });
    } catch (e) {
      debugPrint('Error saving transaction: $e');
      if (mounted) {
        _showErrorSnackBar('Failed to save expense. Please try again.');
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFF44336),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Add Expense',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'More categories',
              style: TextStyle(
                color: Color(0xFF2196F3),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Amount section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF44336),
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: '0.00',
                prefixText: '\$',
                prefixStyle: const TextStyle(
                  color: Color(0xFFF44336),
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
                hintStyle: const TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category section
                  const Text(
                    'Category',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Categories grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = _selectedCategory == category.name;

                      return _buildCategoryItem(
                        category.name,
                        category.icon,
                        category.color,
                        isSelected,
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Date selector
                  const Text(
                    'Date',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),

                  InkWell(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Today',
                            style: TextStyle(
                              color: Color(0xFF424242),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            DateFormat('dd/MM/yyyy').format(_selectedDate),
                            style: const TextStyle(
                              color: Color(0xFF424242),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Description field
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Enter description (optional)',
                      hintStyle: const TextStyle(
                        color: Color(0xFFBDBDBD),
                        fontSize: 14,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF5F5F5),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _isSaving
          ? const Padding(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          onPressed: _saveTransaction,
          backgroundColor: const Color(0xFFF44336),
          elevation: 4,
          child: const Icon(Icons.check, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Widget _buildCategoryItem(String name, IconData icon, Color color, bool isSelected) {
    final backgroundColor = const Color(0xFFF5F5F5);
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = name;
        });
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
              border: isSelected ? Border.all(color: color, width: 2) : null,
            ),
            child: Icon(
              icon,
              color: color,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Reuse the CategoryData class from previous implementation
class CategoryData {
  final String name;
  final IconData icon;
  final Color color;

  CategoryData(this.name, this.icon, this.color);
}