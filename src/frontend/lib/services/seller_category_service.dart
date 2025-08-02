import 'dart:convert';
import 'dart:developer';

import 'package:frontend/models/seller_category_model.dart';
import 'package:frontend/utils/constants.dart';
import 'package:http/http.dart' as http;

class SellerCategoryService {
  final String url = "$baseURL/sellerCategory";

  // get all seller categories
  Future<List<SellerCategoryModel>> getAllSellerCategories() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        log("Seller Categories API CALL Success!");

        final Map<String, dynamic> responseBody = json.decode(response.body);

        // Access the nested array
        final List<dynamic> data = responseBody['data']['data'];

        return data.map((json) => SellerCategoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      log("Failed to Fetch Seller Categories : $e");
      rethrow;
    }
  }
}
