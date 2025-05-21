import 'package:finney/assets/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:finney/localization/locales.dart';
import 'package:flutter_localization/flutter_localization.dart';

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
    'Others',
  ];

  // Income categories
  static const incomeCategories = [
    'Salary',
    'Investment',
    'Business',
    'Gift',
    'Others',
  ];

  // Get localized category name
  static String getLocalizedCategoryName(String category, BuildContext context) {
    switch (category) {
      case 'Shopping':
        return LocaleData.shopping.getString(context);
      case 'Food':
        return LocaleData.food.getString(context);
      case 'Entertainment':
        return LocaleData.entertainment.getString(context);
      case 'Transport':
        return LocaleData.transport.getString(context);
      case 'Health':
        return LocaleData.health.getString(context);
      case 'Utilities':
        return LocaleData.utilities.getString(context);
      case 'Salary':
        return LocaleData.salary.getString(context);
      case 'Investment':
        return LocaleData.investment.getString(context);
      case 'Business':
        return LocaleData.business.getString(context);
      case 'Gift':
        return LocaleData.gift.getString(context);
      case 'Others':
        return LocaleData.others.getString(context);
      default:
        return category;
    }
  }

  // Get category from localized name
  static String getCategoryFromLocalizedName(String localizedName, BuildContext context) {
    // Check expense categories
    for (String category in expenseCategories) {
      if (getLocalizedCategoryName(category, context) == localizedName) {
        return category;
      }
    }
    
    // Check income categories
    for (String category in incomeCategories) {
      if (getLocalizedCategoryName(category, context) == localizedName) {
        return category;
      }
    }
    
    return localizedName;
  }

  // Get localized categories based on transaction type
  static List<String> getLocalizedCategoriesForType(bool isExpense, BuildContext context) {
    List<String> categories = isExpense ? expenseCategories : incomeCategories;
    return categories.map((e) => getLocalizedCategoryName(e, context)).toList();
  }

  static IconData getIconForCategory(String category) {
    if (_categoryIconCache.containsKey(category)) {
      return _categoryIconCache[category]!;
    }

    IconData icon;
    switch (category) {
      // Expense icons
      case 'Shopping':
        icon = Icons.shopping_bag;
        break;
      case 'Food':
        icon = Icons.restaurant;
        break;
      case 'Entertainment':
        icon = Icons.movie;
        break;
      case 'Transport':
        icon = Icons.directions_car;
        break;
      case 'Health':
        icon = Icons.medical_services;
        break;
      case 'Utilities':
        icon = Icons.phone;
        break;

      // Income icons
      case 'Salary':
        icon = Icons.work;
        break;  // Added missing break
      case 'Investment':
        icon = Icons.trending_up;
        break;  // Added missing break
      case 'Business':
        icon = Icons.business;
        break;  // Added missing break
      case 'Gift':
        icon = Icons.card_giftcard;
        break;  // Added missing break

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
        break;
      case 'Food':
        color = AppColors.categoryFood;
        break;
      case 'Entertainment':
        color = AppColors.categoryEntertainment;
        break;
      case 'Transport':
        color = AppColors.categoryTransport;
        break;
      case 'Health':
        color = AppColors.categoryHealth;
        break;
      case 'Utilities':
        color = AppColors.categoryUtilities;
        break;

      // Income colors
      case 'Salary':
        color = AppColors.categorySalary;
        break;  // Added missing break
      case 'Investment':
        color = AppColors.categoryInvestment;
        break;  // Added missing break
      case 'Business':
        color = AppColors.categoryBusiness;
        break;  // Added missing break
      case 'Gift':
        color = AppColors.categoryGift;
        break;  // Added missing break

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