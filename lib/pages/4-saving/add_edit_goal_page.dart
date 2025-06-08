import 'package:finney/shared/theme/app_color.dart';
import 'package:finney/shared/widgets/common/settings_notifier.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finney/core/storage/cloud/models/saving_goal_model.dart';
import 'package:finney/core/storage/cloud/service/saving_goal_service.dart';
import 'package:finney/shared/widgets/common/snack_bar.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/shared/localization/locales.dart';

class AddEditGoalPage extends StatefulWidget {
  final SavingGoal? existingGoal;
  final Function(SavingGoal)? onGoalSaved;
  final VoidCallback? onGoalDeleted;

  const AddEditGoalPage({
    super.key,
    this.existingGoal,
    this.onGoalSaved,
    this.onGoalDeleted,
  });

  @override
  State<AddEditGoalPage> createState() => _AddEditGoalPageState();
}

class _AddEditGoalPageState extends State<AddEditGoalPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 30));
  final SavingGoalService _goalService = SavingGoalService();

  @override
  void initState() {
    super.initState();
    if (widget.existingGoal != null) {
      _titleController.text = widget.existingGoal!.title;
      _targetAmountController.text =
          widget.existingGoal!.targetAmount.toString();
      _descriptionController.text = widget.existingGoal!.description ?? '';
      _selectedDate = widget.existingGoal!.targetDate;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetAmountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: LocaleData.selectDate.getString(context),
      cancelText: LocaleData.cancel.getString(context),  
      confirmText: LocaleData.transactionPreviewConfirm.getString(context),     
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.darkBlue, 
              onPrimary: Colors.white,   
              onSurface: AppColors.darkBlue,   
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.darkBlue,
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ), dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveGoal() async {
    if (_formKey.currentState!.validate()) {
      try {
        final amount = double.tryParse(_targetAmountController.text);
        if (amount == null || amount <= 0) {
          AppSnackBar.showError(
            context,
            message: LocaleData.pleaseEnterPositiveAmount.getString(context),
          );
          return;
        }

        final goal = SavingGoal(
          id: widget.existingGoal?.id ??
              FirebaseFirestore.instance.collection('users').doc().id,
          title: _titleController.text,
          targetAmount: amount,
          savedAmount: widget.existingGoal?.savedAmount ?? 0.0,
          targetDate: _selectedDate,
          description: _descriptionController.text.isNotEmpty
              ? _descriptionController.text
              : null,
          createdAt: widget.existingGoal?.createdAt ?? DateTime.now(),
        );

        await _goalService.saveGoal(goal);

        AppSnackBar.showSuccess(
          context,
          message: widget.existingGoal == null
              ? LocaleData.goalCreated.getString(context).replaceFirst('%s', goal.title)
              : LocaleData.goalUpdated.getString(context).replaceFirst('%s', goal.title),
        );

        if (widget.onGoalSaved != null) {
          widget.onGoalSaved!(goal);
        }

        Navigator.of(context).pop();
      } catch (e) {
        AppSnackBar.showError(
          context,
          message: LocaleData.errorSavingGoal.getString(context),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: SettingsNotifier().textSizeNotifier,
      builder: (context, textSize, child) {
        double textScaleFactor;
        switch (textSize) {
          case 'Small':
            textScaleFactor = 0.8;
            break;
          case 'Large':
            textScaleFactor = 1.2;
            break;
          default:
            textScaleFactor = 1.0;
        }
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(textScaleFactor),
          ),
          child:  Scaffold(
      appBar: AppBar(
        title: Text(
          widget.existingGoal == null
              ? LocaleData.addSavingGoal.getString(context)
              : LocaleData.editSavingGoal.getString(context),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount Field
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '৳',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _targetAmountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4CAF50),
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        hintText: LocaleData.amountHint.getString(context),
                        hintStyle: const TextStyle(
                          color: Color(0xFF4CAF50),
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LocaleData.pleaseEnterAmount.getString(context);
                        }
                        final amount = double.tryParse(value);
                        if (amount == null) {
                          return LocaleData.pleaseEnterValidNumber.getString(context);
                        }
                        if (amount <= 0) {
                          return LocaleData.pleaseEnterPositiveAmount.getString(context);
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Goal Name Field
              Text(
                LocaleData.savingGoalPurpose.getString(context),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: LocaleData.savingGoalHint.getString(context),
                  filled: true,
                  fillColor: const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(15),
                ),
                validator: (value) =>
                    value == null || value.isEmpty
                        ? LocaleData.pleaseEnterSavingGoalName.getString(context)
                        : null,
              ),
              const SizedBox(height: 20),

              // Date Field
              Text(
                LocaleData.targetDate.getString(context),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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

              // Description Field
              Text(
                LocaleData.description.getString(context),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                maxLines: 3,
              ),
              const SizedBox(height: 40),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveGoal,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    LocaleData.saveGoal.getString(context),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}