import 'dart:convert';
import 'dart:developer';

import 'package:frontend/models/advertisement_model.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/utils/constants.dart';
import 'package:http/http.dart' as http;

class AdvertisementService {
  final String url = "$baseURL/advertisements";
  final AuthApiService _apiService = AuthApiService();
  String? _authToken;

  Future<String?> get authToken async {
    _authToken = await _apiService.getJwtToken();
    return _authToken;
  }

  Future<Map<String, String>> _getHeaders() async {
    final token = await authToken;
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<AdvertisementModel>> fetchAllAdvertisements() async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        log("Advertisements Fetched Successful!");
        final Map<String, dynamic> responseBody = json.decode(response.body);

        log("Advertisement Service Response Body -> $responseBody");

        final List<dynamic> data = responseBody['data']['data'];
        return data.map((json) => AdvertisementModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load Advertisements');
      }
    } on Exception catch (e) {
      throw Exception("Failed to Load Advertisements : $e");
    }
  }

  Future<AdvertisementModel> fetchAdvertisementById(String id) async {
    try {
      final response = await http.get(
        Uri.parse("$url/$id"),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        log("Advertisement Service Response Body -> $responseBody");

        final dynamic data = responseBody['data']['data'];
        return AdvertisementModel.fromJson(json.decode(data));
      } else {
        throw Exception('Failed to load Advertisements');
      }
    } on Exception catch (e) {
      throw Exception("Failed to Load Advertisements : $e");
    }
  }

  Future<List<AdvertisementModel>> fetchAllAdvertisementsRelatedToCategory(
    String categoryId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse("$url/category/$categoryId"),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        log(
          "Advertisements Fetched Related to Category - $categoryId Successful!",
        );
        final Map<String, dynamic> responseBody = json.decode(response.body);

        log("Advertisement Service Response Body -> $responseBody");

        final List<dynamic> data = responseBody['data']['data'];
        return data.map((json) => AdvertisementModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load Advertisements');
      }
    } on Exception catch (e) {
      throw Exception("Failed to Load Advertisements : $e");
    }
  }

  Future<List<AdvertisementModel>> fetchAllAdvertisementsRelatedToCSubategory(
    String subCategoryId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse("$url/subcategory/$subCategoryId"),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        log(
          "Advertisements Fetched Related to Category - $subCategoryId Successful!",
        );
        final Map<String, dynamic> responseBody = json.decode(response.body);

        log("Advertisement Service Response Body -> $responseBody");

        final List<dynamic> data = responseBody['data']['data'];
        return data.map((json) => AdvertisementModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load Advertisements');
      }
    } on Exception catch (e) {
      throw Exception("Failed to Load Advertisements : $e");
    }
  }

  Future<Map<String, dynamic>> createAdvertisement(
    AdvertisementModel advertisement,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: await _getHeaders(),
        body: jsonEncode(advertisement),
      );

      if (response.statusCode == 201) {
        log("Advertisement Created Suceess!");
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create Advertisement');
      }
    } catch (e) {
      log("Error creating Advertisement : $e");
      throw Exception('Failed to create Advertisement : $e');
    }
  }

  Future<void> deleteAdvertisement(String id) async {
    final response = await http.delete(
      Uri.parse('$url/$id'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete Advertisement');
    }
  }

  Future<Map<String, dynamic>> createPurchaseRequest(
    Map<String, dynamic> req,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$baseURL/purchases"),
        headers: await _getHeaders(),
        body: jsonEncode(req),
      );

      log("Response : ${response.body}");

      if (response.statusCode == 201) {
        log("Purchase Request Created Suceess!");
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create Purchase Request');
      }
    } catch (e) {
      log("Error creating Advertisement : $e");
      throw Exception('Failed to create Advertisement : $e');
    }
  }
}
