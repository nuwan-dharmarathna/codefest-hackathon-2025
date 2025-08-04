import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:frontend/models/sub_category_model.dart';
import 'package:frontend/services/sub_category_service.dart';

class SubCategoryProvider with ChangeNotifier {
  final SubCategoryService _subCategoryService = SubCategoryService();
  List<SubCategoryModel> _subCategories = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _selectedCategoryId; // Track selected category for subcategories

  // Getters
  List<SubCategoryModel> get subCategories => _subCategories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedCategoryId => _selectedCategoryId;

  // Get subcategories filtered by category
  List<SubCategoryModel> getSubCategoriesByCategory(String categoryId) {
    return _subCategories
        .where((subCat) => subCat.category == categoryId)
        .toList();
  }

  // Fetch all subcategories
  Future<void> fetchAllSubCategories() async {
    try {
      _startLoading();
      _subCategories = await _subCategoryService.getAllSubCategories();
      _clearError();
    } catch (e, stackTrace) {
      log("Failed to fetch subcategories", error: e, stackTrace: stackTrace);
      _setError('Failed to load subcategories. Please try again.');
    } finally {
      _stopLoading();
    }
  }

  // Fetch subcategories for a specific category
  Future<void> fetchSubCategoriesByCategory(String categoryId) async {
    try {
      _startLoading();
      _selectedCategoryId = categoryId;
      _subCategories = await _subCategoryService.getSubCategoriesByCategory(
        categoryId,
      );
      _clearError();
    } catch (e, stackTrace) {
      log(
        "Failed to fetch subcategories for category $categoryId",
        error: e,
        stackTrace: stackTrace,
      );
      _setError('Failed to load subcategories for this category.');
    } finally {
      _stopLoading();
    }
  }

  // Clear selected category
  void clearSelectedCategory() {
    _selectedCategoryId = null;
    notifyListeners();
  }

  // Helper methods
  void _startLoading() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
  }

  void _stopLoading() {
    _isLoading = false;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _subCategories = []; // Clear data on error
  }

  void _clearError() {
    _errorMessage = null;
  }

  // Clear all state
  void reset() {
    _subCategories = [];
    _isLoading = false;
    _errorMessage = null;
    _selectedCategoryId = null;
    notifyListeners();
  }
}
