import 'package:finney/shared/widgets/common/my_button.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finney/pages/1-auth/widgets/my_textfield.dart';
import 'package:finney/shared/theme/app_color.dart';
import 'package:finney/shared/category.dart';
import 'package:finney/pages/0-onboarding/budget_result.dart';
import 'package:finney/shared/widgets/common/snack_bar.dart';
import 'package:finney/shared/localization/locales.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:finney/shared/widgets/common/app_dialog.dart';

class OnboardingQuestionsPage extends StatefulWidget {
  const OnboardingQuestionsPage({super.key});

  @override
  State<OnboardingQuestionsPage> createState() => _OnboardingQuestionsPageState();
}

class _OnboardingQuestionsPageState extends State<OnboardingQuestionsPage> {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _incomeController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();

  bool _loading = false;

  Future<void> _submit() async {
    final ageText = _ageController.text.trim();
    final jobText = _jobController.text.trim();
    final incomeText = _incomeController.text.trim();
    final balanceText = _balanceController.text.trim();

    // Validation
    if (ageText.isEmpty ||
        jobText.isEmpty ||
        incomeText.isEmpty ||
        balanceText.isEmpty) {
      AppSnackBar.showError(context, message: LocaleData.onboardingFillAll.getString(context));
      return;
    }
    if (int.tryParse(ageText) == null || int.parse(ageText) <= 0) {
      AppSnackBar.showError(context, message: LocaleData.onboardingValidAge.getString(context));
      return;
    }
    if (double.tryParse(incomeText) == null || double.parse(incomeText) <= 0) {
      AppSnackBar.showError(context, message: LocaleData.onboardingValidIncome.getString(context));
      return;
    }
    if (double.tryParse(balanceText) == null || double.parse(balanceText) < 0) {
      AppSnackBar.showError(context, message: LocaleData.onboardingValidBalance.getString(context));
      return;
    }
    if (jobText.contains(RegExp(r'\d'))) {
      AppSnackBar.showError(context, message: LocaleData.onboardingJobLetters.getString(context));
      return;
    }

    final income = double.parse(incomeText);

    // Warn if income is unrealistically low
    if (income < 100) {
      final proceed = await AppDialog.show(
        context,
        title: "Unrealistic Income",
        message: "Your income is very low, which can make the 50-30-20 rule inaccurate or impractical. Do you want to continue anyway?",
        iconColor: Colors.redAccent,
        confirmText: LocaleData.dialogOk.getString(context),
      );
      if (proceed != true) return;
    }

    setState(() => _loading = true);

    final age = int.parse(ageText);
    final job = jobText;
    final balance = double.parse(balanceText);

    // Save user info
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'onboarding': {
        'age': age,
        'job': job,
        'income': income,
        'balance': balance,
      }
    }, SetOptions(merge: true));

    // 50-30-20 rule
    final needs = income * 0.5;
    final wants = income * 0.3;
    final savings = income * 0.2;
    final needsCategories = ['Food', 'Utilities', 'Transport', 'Health'];
    final wantsCategories = ['Shopping', 'Entertainment', 'Others'];
    final savingsCategories = ['Savings'];
    double needsPerCat = needsCategories.isNotEmpty ? needs / needsCategories.length : 0;
    double wantsPerCat = wantsCategories.isNotEmpty ? wants / wantsCategories.length : 0;
    double savingsPerCat = savingsCategories.isNotEmpty ? savings / savingsCategories.length : 0;

    Map<String, double> limits = {};
    for (var cat in CategoryUtils.expenseCategories) {
      if (needsCategories.contains(cat)) {
        limits[cat] = needsPerCat;
      } else if (wantsCategories.contains(cat)) {
        limits[cat] = wantsPerCat;
      } else if (savingsCategories.contains(cat)) {
        limits[cat] = savingsPerCat;
      } else {
        limits[cat] = 0;
      }
    }

    // Save to Firestore if still mounted
    if (!mounted) return;
    for (final entry in limits.entries) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('budgets')
          .doc(entry.key)
          .set({'limit': entry.value, 'category': entry.key}, SetOptions(merge: true));
    }

    if (mounted) {
      setState(() => _loading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BudgetResultPage(
            budgetLimits: limits,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        centerTitle: true,
        title: Text(
          LocaleData.onboardingPersonalizeTitle.getString(context),
          style: const TextStyle(
            color: AppColors.darkBlue,
            fontWeight: FontWeight.bold,
            fontSize: 28,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    MyTextField(
                      controller: _ageController,
                      hintText: LocaleData.onboardingAgeHint.getString(context),
                      obscureText: false,
                      keyboardType: TextInputType.number,
                    ),
                    MyTextField(
                      controller: _jobController,
                      hintText: LocaleData.onboardingJobHint.getString(context),
                      obscureText: false,
                      keyboardType: TextInputType.text,
                    ),
                    MyTextField(
                      controller: _incomeController,
                      hintText: LocaleData.onboardingIncomeHint.getString(context),
                      obscureText: false,
                      keyboardType: TextInputType.number,
                    ),
                    MyTextField(
                      controller: _balanceController,
                      hintText: LocaleData.onboardingBalanceHint.getString(context),
                      obscureText: false,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_basket, color: Colors.blue[700]),
                                const SizedBox(width: 10),
                                Text(
                                  LocaleData.onboardingNeedsTitle.getString(context),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.only(left: 34),
                              child: Text(
                                LocaleData.onboardingNeedsDesc.getString(context),
                                style: TextStyle(fontSize: 14, color: AppColors.darkBlue),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.celebration, color: Colors.orange[800]),
                                const SizedBox(width: 10),
                                Text(
                                  LocaleData.onboardingWantsTitle.getString(context),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange[800],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.only(left: 34),
                              child: Text(
                                LocaleData.onboardingWantsDesc.getString(context),
                                style: TextStyle(fontSize: 14, color: AppColors.darkBlue),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.savings, color: Colors.green[700]),
                                const SizedBox(width: 10),
                                Text(
                                  LocaleData.onboardingSavingsTitle.getString(context),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[700],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.only(left: 34),
                              child: Text(
                                LocaleData.onboardingSavingsDesc.getString(context),
                                style: TextStyle(fontSize: 14, color: AppColors.darkBlue),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 18),
                            const Divider(thickness: 1, color: AppColors.darkBlue),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.info_outline, color: AppColors.darkBlue, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    LocaleData.onboardingInfo.getString(context),
                                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    MyButton(
                      onTap: _submit,
                      text: LocaleData.onboardingContinue.getString(context),
                      backgroundColor: AppColors.darkBlue,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}