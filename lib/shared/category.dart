import 'package:finney/shared/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:finney/shared/localization/locales.dart';
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
    'Savings',
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
      case 'শপিং':
        icon = Icons.shopping_bag;
        break;
      case 'Food':
      case 'খাবার':
        icon = Icons.restaurant;
        break;
      case 'Entertainment':
      case 'বিনোদন':
        icon = Icons.movie;
        break;
      case 'Transport':
      case 'পরিবহন':
        icon = Icons.directions_car;
        break;
      case 'Health':
      case 'স্বাস্থ্য':
        icon = Icons.medical_services;
        break;
      case 'Utilities':
      case 'ইউটিলিটি':
        icon = Icons.phone;
        break;

      case 'Savings':
      case 'সঞ্চয়':
        icon = Icons.savings;
        break;

      // Income icons
      case 'Salary':
      case 'বেতন':
        icon = Icons.work;
        break;
      case 'Investment':
      case 'বিনিয়োগ':
        icon = Icons.trending_up;
        break;
      case 'Business':
      case 'ব্যবসা':
        icon = Icons.business;
        break;
      case 'Gift':
      case 'উপহার':
        icon = Icons.card_giftcard;
        break;

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
      case 'শপিং':
        color = AppColors.categoryShopping;
        break;
      case 'Food':
      case 'খাবার':
        color = AppColors.categoryFood;
        break;
      case 'Entertainment':
      case 'বিনোদন':
        color = AppColors.categoryEntertainment;
        break;
      case 'Transport':
      case 'পরিবহন':
        color = AppColors.categoryTransport;
        break;
      case 'Health':
      case 'স্বাস্থ্য':
        color = AppColors.categoryHealth;
        break;
      case 'Utilities':
      case 'ইউটিলিটি':
        color = AppColors.categoryUtilities;
        break;
      
      case 'Savings':
      case 'সঞ্চয়':
        color = AppColors.categorySavings;
        break;

      // Income colors
      case 'Salary':
      case 'বেতন':
        color = AppColors.categorySalary;
        break;
      case 'Investment':
      case 'বিনিয়োগ':
        color = AppColors.categoryInvestment;
        break;
      case 'Business':
      case 'ব্যবসা':
        color = AppColors.categoryBusiness;
        break;
      case 'Gift':
      case 'উপহার':
        color = AppColors.categoryGift;
        break;

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