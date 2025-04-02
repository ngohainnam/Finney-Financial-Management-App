import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finney/pages/3-dashboard/models/transaction_model.dart';
import 'package:finney/pages/3-dashboard/services/transaction_services.dart';

class AddIncomeScreen extends StatefulWidget {
  final Function? onIncomeAdded;

  const AddIncomeScreen({
    super.key,
    this.onIncomeAdded,
  });

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;
  final TransactionService _transactionService = TransactionService();

  // Pre-defined income sources with icons and colors
  final List<IncomeCategoryData> _incomeSources = [
    IncomeCategoryData('Salary', Icons.account_balance_wallet, const Color(0xFF4CAF50)),
    IncomeCategoryData('Freelance', Icons.laptop, const Color(0xFF2196F3)),
    IncomeCategoryData('Bonus', Icons.card_giftcard, const Color(0xFFFF9800)),
    IncomeCategoryData('Investment', Icons.trending_up, const Color(0xFF9C27B0)),
    IncomeCategoryData('Other', Icons.add_circle_outline, const Color(0xFF9E9E9E)),
  ];

  String _selectedSource = 'Salary';

  @override
  void initState() {
    super.initState();
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
    // Validate amount
    if (_amountController.text.isEmpty ||
        double.tryParse(_amountController.text.replaceAll(',', '.')) == null) {
      _showErrorSnackBar('Please enter a valid amount');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Parse amount (positive for income)
      double amountValue = double.parse(_amountController.text.replaceAll(',', '.'));

      // Create transaction model
      final transaction = TransactionModel(
        name: _selectedSource,
        category: 'Income',
        amount: amountValue,
        date: _selectedDate,
        description: _descriptionController.text.trim(),
      );

      // Optimistic UI update
      if (widget.onIncomeAdded != null) {
        widget.onIncomeAdded!(transaction);
      }

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Income saved successfully'),
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
        _showErrorSnackBar('Failed to save income. Please try again.');
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
          'Add Income',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
                color: Color(0xFF4CAF50),
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: '0.00',
                prefixText: '\$',
                prefixStyle: const TextStyle(
                  color: Color(0xFF4CAF50),
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
                  // Income Source section
                  const Text(
                    'Income Source',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Income Sources grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 15,
                    ),
                    itemCount: _incomeSources.length,
                    itemBuilder: (context, index) {
                      final source = _incomeSources[index];
                      final isSelected = _selectedSource == source.name;

                      return _buildIncomeSourceItem(
                        source.name,
                        source.icon,
                        source.color,
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
          backgroundColor: const Color(0xFF4CAF50),
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

  Widget _buildIncomeSourceItem(String name, IconData icon, Color color, bool isSelected) {
    final backgroundColor = const Color(0xFFF5F5F5);
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSource = name;
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

// Separate class for income source data
class IncomeCategoryData {
  final String name;
  final IconData icon;
  final Color color;

  IncomeCategoryData(this.name, this.icon, this.color);
}