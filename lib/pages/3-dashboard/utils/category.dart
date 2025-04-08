import 'package:finney/assets/theme/app_color.dart';
import 'package:flutter/material.dart';

class CategoryUtils {
  static final Map<String, IconData> _categoryIconCache = {};
  static final Map<String, Color> _categoryColorCache = {};

  // Expense categories
  static const expenseCategories = [
    'Shopping',
    'Food',
    'Entertainment',
    'Transport',
    'Health',
    'Utilities',
    'Others'
  ];

  // Income categories
  static const incomeCategories = [
    'Salary',
    'Investment',
    'Business',
    'Gift',
    'Others'
  ];

  static IconData getIconForCategory(String category) {
    if (_categoryIconCache.containsKey(category)) {
      return _categoryIconCache[category]!;
    }

    IconData icon;
    switch (category) {
      // Expense icons
      case 'Shopping':
        icon = Icons.shopping_bag;
      case 'Food':
        icon = Icons.restaurant;
      case 'Entertainment':
        icon = Icons.movie;
      case 'Transport':
        icon = Icons.directions_car;
      case 'Health':
        icon = Icons.medical_services;
      case 'Utilities':
        icon = Icons.phone;
      
      // Income icons
      case 'Salary':
        icon = Icons.work;
      case 'Investment':
        icon = Icons.trending_up;
      case 'Business':
        icon = Icons.business;
      case 'Gift':
        icon = Icons.card_giftcard;
      
      // Default icon
      default:
        icon = Icons.category_outlined;
    }

    _categoryIconCache[category] = icon;
    return icon;
  }

  static Color getColorForCategory(String category) {
    if (_categoryColorCache.containsKey(category)) {
      return _categoryColorCache[category]!;
    }

    Color color;
    switch (category) {
      // Expense colors
      case 'Shopping':
        color = AppColors.categoryShopping;
      case 'Food':
        color = AppColors.categoryFood;
      case 'Entertainment':
        color = AppColors.categoryEntertainment;
      case 'Transport':
        color = AppColors.categoryTransport;
      case 'Health':
        color = AppColors.categoryHealth;
      case 'Utilities':
        color = AppColors.categoryUtilities;
      
      // Income colors
      case 'Salary':
        color = AppColors.categorySalary;
      case 'Investment':
        color = AppColors.categoryInvestment;
      case 'Business':
        color = AppColors.categoryBusiness;
      case 'Gift':
        color = AppColors.categoryGift;
      
      // Default color
      default:
        color = AppColors.categoryDefault;
    }

    _categoryColorCache[category] = color;
    return color;
  }

  // Helper method to get categories based on transaction type
  static List<String> getCategoriesForType(bool isExpense) {
    return isExpense ? expenseCategories : incomeCategories;
  }
}