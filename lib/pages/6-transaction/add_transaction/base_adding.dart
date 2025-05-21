import 'package:finney/core/storage/cloud/service/transaction_cloud_service.dart';
import 'package:finney/shared/category.dart';
import 'package:finney/pages/9-setting/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finney/core/storage/cloud/models/transaction_model.dart';
import 'package:finney/core/storage/storage_manager.dart'; // Added for singleton access
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/shared/localization/locales.dart';

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
  String? _errorMessage;
  late final TransactionCloudService _transactionService;

  TextEditingController get amountController => _amountController;

  String get screenTitle;
  Color get amountColor;
  List<CategoryData> get categories;
  double getTransactionAmount();

  @override
  void initState() {
    super.initState();
    // Get transaction service from StorageManager
    _transactionService = StorageManager().transactionService;
    
    if (widget.existingTransaction != null) {
      // if the transaction exists
      _selectedCategory = widget.existingTransaction!.category;
      _selectedDate = widget.existingTransaction!.date;
      _amountController.text = CurrencyFormatter.formatWithoutSymbol(widget.existingTransaction!.amount.abs());
      _descriptionController.text = widget.existingTransaction!.description ?? '';
    } else {
      // if it is a new transaction
      if (categories.isNotEmpty) {
        _selectedCategory = categories[0].name;
      }
      _amountController.text = '0';
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveTransaction() async {
    // Clear any previous errors
    setState(() {
      _errorMessage = null;
    });

    // Validate amount
    if (_amountController.text.isEmpty || _amountController.text == '0') {
      setState(() {
        _errorMessage = LocaleData.pleaseEnterValidAmount.getString(context);
      });
      return;
    }

    try {
      double amount = CurrencyFormatter.parse(_amountController.text);
      if (amount <= 0) {
        setState(() {
          _errorMessage = LocaleData.pleaseEnterPositiveAmount.getString(context);
        });
        return;
      }
    } catch (e) {
      setState(() {
        _errorMessage = LocaleData.pleaseEnterValidNumber.getString(context);
      });
      return;
    }

    if (_selectedCategory.isEmpty) {
      setState(() {
        _errorMessage = LocaleData.pleaseSelectCategory.getString(context);
      });
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

      // Save to storage (handles both local and cloud)
      if (widget.existingTransaction != null) {
        await _transactionService.updateTransaction(transaction);
      } else {
        await _transactionService.addTransaction(transaction);
      }

      // Simply navigate back without showing a snackbar
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint('Error processing transaction: $e');
      if (mounted) {
        setState(() {
          _isSaving = false;
          _errorMessage = LocaleData.failedToSaveTransaction.getString(context);
        });
      }
    }
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
          // Error message (if any)
          if (_errorMessage != null)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Colors.red.shade50,
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red[700], fontSize: 14),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 16, color: Colors.red),
                    onPressed: () => setState(() => _errorMessage = null),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

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
                prefixText: '৳ ',
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
              onChanged: (value) {
                // Clear any error when user starts typing
                if (_errorMessage != null) {
                  setState(() {
                    _errorMessage = null;
                  });
                }
                
                // Simple number input without formatting
                if (value.isEmpty) {
                  _amountController.text = '';
                  return;
                }
                
                // Only allow numbers and one decimal point
                String cleanValue = value.replaceAll(RegExp(r'[^\d.]'), '');
                if (cleanValue.split('.').length > 2) {
                  cleanValue = cleanValue.substring(0, cleanValue.lastIndexOf('.'));
                }
                
                if (cleanValue != value) {
                  _amountController.text = cleanValue;
                  _amountController.selection = TextSelection.fromPosition(
                    TextPosition(offset: cleanValue.length),
                  );
                }
              },
            ),
          ),

          // Rest of the UI remains unchanged
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category section
                  Text(
                    LocaleData.category.getString(context),
                    style: const TextStyle(
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
                    style: const TextStyle(
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
                    style: const TextStyle(
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

  // The remaining methods remain unchanged
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
          // Clear any errors when selecting a category
          if (_errorMessage == LocaleData.pleaseSelectCategory.getString(context)) {
            _errorMessage = null;
          }
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