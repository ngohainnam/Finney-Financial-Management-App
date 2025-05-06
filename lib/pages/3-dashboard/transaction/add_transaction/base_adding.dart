import 'package:finney/pages/3-dashboard/utils/category.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finney/pages/3-dashboard/models/transaction_model.dart';
import 'package:finney/pages/3-dashboard/transaction/transaction_services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/localization/locales.dart';

abstract class BaseTransactionScreen extends StatefulWidget {
  final Function? onTransactionAdded;
  final TransactionModel? existingTransaction;

  const BaseTransactionScreen({
    super.key,
    this.onTransactionAdded,
    this.existingTransaction,
  });
}

abstract class BaseTransactionScreenState<T extends BaseTransactionScreen>
    extends State<T> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = '';
  DateTime _selectedDate = DateTime.now();
  bool _isSaving = false;
  final TransactionService _transactionService = TransactionService();

  TextEditingController get amountController => _amountController;

  String get screenTitle;
  Color get amountColor;
  List<CategoryData> get categories;
  double getTransactionAmount();

  @override
  void initState() {
    super.initState();
    if (widget.existingTransaction != null) {
      // if the transaction exists
      _selectedCategory = widget.existingTransaction!.category;
      _selectedDate = widget.existingTransaction!.date;
      _amountController.text = widget.existingTransaction!.amount.abs().toStringAsFixed(2);
      _descriptionController.text = widget.existingTransaction!.description ?? '';
    } else {
      // if it is a new transaction
      if (categories.isNotEmpty) {
        _selectedCategory = categories[0].name;
      }
      _amountController.text = '0.00';
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

Future<void> _saveTransaction() async {
  // Validate amount
  if (_amountController.text == '0.00' || _amountController.text.isEmpty) {
    _showErrorSnackBar(LocaleData.pleaseEnterValidAmount.getString(context));
    return;
  }

  try {
    double amount = double.parse(_amountController.text);
    if (amount <= 0) {
      _showErrorSnackBar(LocaleData.pleaseEnterPositiveAmount.getString(context));
      return;
    }
  } catch (e) {
    _showErrorSnackBar(LocaleData.pleaseEnterValidNumber.getString(context));
    return;
  }

  if (_selectedCategory.isEmpty) {
    _showErrorSnackBar(LocaleData.pleaseSelectCategory.getString(context));
    return;
  }

  setState(() {
    _isSaving = true;
  });

  try {
    double amountValue = getTransactionAmount();

    final transaction = TransactionModel(
      id: widget.existingTransaction?.id,
      name: _selectedCategory,
      category: _selectedCategory,
      amount: amountValue,
      date: _selectedDate,
      description: _descriptionController.text.trim(),
    );

    // Optimistic UI update - call callback first
    if (widget.onTransactionAdded != null) {
      widget.onTransactionAdded!(transaction);
    }

    // Show success message and pop screen
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.existingTransaction != null 
            ? LocaleData.transactionUpdated.getString(context)
            : LocaleData.transactionSaved.getString(context)),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }

    // Save to Firestore in the background
    if (widget.existingTransaction != null) {
      _transactionService.updateTransaction(transaction).catchError((e) {
        debugPrint('Error updating transaction: $e');
      });
    } else {
      _transactionService.addTransaction(transaction).catchError((e) {
        debugPrint('Error saving transaction: $e');
      });
    }

  } catch (e) {
    debugPrint('Error processing transaction: $e');
    if (mounted) {
      setState(() {
        _isSaving = false;
      });
      _showErrorSnackBar(LocaleData.failedToSaveTransaction.getString(context));
    }
  }
}

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          screenTitle,
          style: const TextStyle(
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
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: amountColor,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                hintText: LocaleData.amountHint.getString(context),
                prefixText: '\$',
                prefixStyle: TextStyle(
                  color: amountColor,
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
                  Text(
                    LocaleData.category.getString(context),
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
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
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
                  Text(
                    LocaleData.date.getString(context),
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
                          Text(
                            DateFormat('EEEE').format(_selectedDate),
                            style: const TextStyle(
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
                  Text(
                    LocaleData.description.getString(context),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: LocaleData.descriptionHint.getString(context),
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
                backgroundColor: amountColor,
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
              color: const Color(0xFFF5F5F5),
              shape: BoxShape.circle,
              border: isSelected ? Border.all(color: color, width: 2) : null,
            ),
            child: Icon(
              CategoryUtils.getIconForCategory(name),
              color: CategoryUtils.getColorForCategory(name),
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            CategoryUtils.getLocalizedCategoryName(name, context),
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

class CategoryData {
  final String name;
  final IconData icon;
  final Color color;

  CategoryData(this.name) : 
    icon = CategoryUtils.getIconForCategory(name),
    color = CategoryUtils.getColorForCategory(name);
}