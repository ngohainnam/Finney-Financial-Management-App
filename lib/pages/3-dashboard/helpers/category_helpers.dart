import 'package:flutter/material.dart';

// Cache maps for icons and colors
final Map<String, IconData> _categoryIconCache = {};
final Map<String, Color> _categoryColorCache = {};

// Get icon for category with caching
IconData getIconForCategory(String category) {
  if (_categoryIconCache.containsKey(category)) {
    return _categoryIconCache[category]!;
  }

  IconData icon;
  switch (category) {
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
    default:
      icon = Icons.category_outlined;
  }

  _categoryIconCache[category] = icon;
  return icon;
}

// Get color for category with caching
Color getColorForCategory(String category) {
  if (_categoryColorCache.containsKey(category)) {
    return _categoryColorCache[category]!;
  }

  Color color;
  switch (category) {
    case 'Shopping':
      color = const Color(0xFFFF9800);
    case 'Food':
      color = const Color(0xFF2196F3);
    case 'Entertainment':
      color = const Color(0xFFE91E63);
    case 'Transport':
      color = const Color(0xFF4CAF50);
    case 'Health':
      color = const Color(0xFFF44336);
    case 'Utilities':
      color = const Color(0xFF9C27B0);
    default:
      color = const Color(0xFF9E9E9E);
  }

  _categoryColorCache[category] = color;
  return color;
}