import 'package:flutter/material.dart';

class CategoryFilterProvider extends ChangeNotifier {
  String? _selectedCategoryId;
  String? _selectedSubCategoryId;

  String? get selectedCategoryId => _selectedCategoryId;
  String? get selectedSubCategoryId => _selectedSubCategoryId;

  void selectCategory(String categoryId) {
    _selectedCategoryId = categoryId;
    _selectedSubCategoryId = null; // Reset subcategory when category changes
    notifyListeners();
  }

  void selectSubCategory(String subCategoryId) {
    _selectedSubCategoryId = subCategoryId;
    notifyListeners();
  }

  void clearFilters() {
    _selectedCategoryId = null;
    _selectedSubCategoryId = null;
    notifyListeners();
  }

  bool get hasFilters => _selectedCategoryId != null;
}
