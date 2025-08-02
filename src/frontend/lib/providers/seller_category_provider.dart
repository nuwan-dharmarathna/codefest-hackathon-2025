import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:frontend/models/seller_category_model.dart';
import 'package:frontend/services/seller_category_service.dart';

class SellerCategoryProvider extends ChangeNotifier {
  final SellerCategoryService _sellerCategoryService = SellerCategoryService();

  List<SellerCategoryModel> _sellerCategories = [];

  // getter
  List<SellerCategoryModel> get sellerCategories => _sellerCategories;

  //fetch categories when the provider is initialized
  SellerCategoryProvider() {
    fetchAllCategories();
  }
  // fetch all categories
  Future<void> fetchAllCategories() async {
    try {
      _sellerCategories = await _sellerCategoryService.getAllSellerCategories();
      notifyListeners();
    } catch (e) {
      log("Failed to Fetch Seller Categories : $e");
    }
  }
}
