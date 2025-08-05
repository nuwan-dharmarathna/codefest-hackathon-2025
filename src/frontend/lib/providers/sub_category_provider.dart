import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:frontend/models/sub_category_model.dart';
import 'package:frontend/services/sub_category_service.dart';

class SubCategoryProvider with ChangeNotifier {
  final SubCategoryService _subCategoryService = SubCategoryService();
  List<SubCategoryModel> _subCategories = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _selectedCategoryId;

  List<SubCategoryModel> get subCategories => _subCategories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get selectedCategoryId => _selectedCategoryId;

  Future<void> fetchAllSubCategories() async {
    try {
      _startLoading();
      _selectedCategoryId = null; // Clear selection when fetching all
      _subCategories = await _subCategoryService.getAllSubCategories();
      _clearError();
    } catch (e, stackTrace) {
      log("Failed to fetch subcategories", error: e, stackTrace: stackTrace);
      _setError('Failed to load subcategories. Please try again.');
    } finally {
      _stopLoading();
    }
  }

  Future<List<SubCategoryModel>> fetchSubCategoriesByCategory(
    String categoryId,
  ) async {
    if (_selectedCategoryId == categoryId && _subCategories.isNotEmpty) {
      return _subCategories;
    }

    try {
      _isLoading = true;
      _selectedCategoryId = categoryId;
      final result = await _subCategoryService.getSubCategoriesByCategory(
        categoryId,
      );

      // Only update state and notify after the build phase
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _subCategories = result;
        _errorMessage = null;
        _isLoading = false;
        notifyListeners();
      });

      return result;
    } catch (e, stackTrace) {
      log(
        "Failed to fetch subcategories for category $categoryId",
        error: e,
        stackTrace: stackTrace,
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _errorMessage = 'Failed to load subcategories for this category.';
        _subCategories = [];
        _isLoading = false;
        notifyListeners();
      });

      return [];
    }
  }

  void clearSelectedCategory() {
    _selectedCategoryId = null;
    _subCategories = []; // Clear subcategories when no category is selected
    notifyListeners();
  }

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
    _subCategories = [];
    notifyListeners();
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  void reset() {
    _subCategories = [];
    _isLoading = false;
    _errorMessage = null;
    _selectedCategoryId = null;
    notifyListeners();
  }
}
