import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:frontend/models/seller_category_model.dart';
import 'package:frontend/services/seller_category_service.dart';

class SellerCategoryProvider extends ChangeNotifier {
  final SellerCategoryService _sellerCategoryService = SellerCategoryService();

  List<SellerCategoryModel> _sellerCategories = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  List<SellerCategoryModel> get sellerCategories => _sellerCategories;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Constructor - now with optional immediate fetch
  SellerCategoryProvider({bool fetchOnInit = true}) {
    if (fetchOnInit) {
      fetchAllCategories();
    }
  }

  // Fetch all categories with proper state management
  Future<void> fetchAllCategories() async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      _sellerCategories = await _sellerCategoryService.getAllSellerCategories();
    } catch (e) {
      log("Failed to Fetch Seller Categories: $e");
      _errorMessage = 'Failed to load categories. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
