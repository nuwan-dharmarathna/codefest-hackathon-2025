import 'dart:convert';
import 'dart:developer';

import 'package:frontend/models/sub_category_model.dart';
import 'package:frontend/utils/constants.dart';
import 'package:http/http.dart' as http;

class SubCategoryService {
  final String url = "$baseURL/subCategory";

  Future<List<SubCategoryModel>> getAllSubCategories() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        log("Seller Categories API CALL Success!");

        final Map<String, dynamic> responseBody = json.decode(response.body);

        // Access the nested array
        final List<dynamic> data = responseBody['data']['data'];

        return data.map((json) => SubCategoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      log("Failed to Fetch Seller Categories : $e");
      rethrow;
    }
  }

  Future<List<SubCategoryModel>> getSubCategoriesByCategory(
    String categoryId,
  ) async {
    try {
      final response = await http.get(Uri.parse('$url/category/$categoryId'));

      if (response.statusCode == 200) {
        log("SubCategories $categoryId fetched success!");

        final Map<String, dynamic> responseBody = json.decode(response.body);
        final dynamic data = responseBody['data']['data'];

        return data.map((json) => SubCategoryModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tender');
      }
    } catch (e) {
      log("Error fetching SubCategories $categoryId: $e");
      throw Exception('Failed to load tender');
    }
  }
}
