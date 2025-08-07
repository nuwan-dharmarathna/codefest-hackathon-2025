import 'dart:convert';
import 'dart:developer';

import 'package:frontend/models/tender_model.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/utils/constants.dart';
import 'package:http/http.dart' as http;

class TenderService {
  final String url = "$baseURL/tenders";
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

  Future<List<TenderModel>> fetchAllTenders() async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        log("Get All Tender API Call success");
        final Map<String, dynamic> responseBody = json.decode(response.body);

        final List<dynamic> data = responseBody['data']['data'];
        return data.map((json) => TenderModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load Tenders');
      }
    } catch (e) {
      throw Exception('Failed to load tenders');
    }
  }

  Future<List<TenderModel>> fetchTendersBasedOnCategory() async {
    try {
      final response = await http.get(
        Uri.parse("$url/seller"),
        headers: await _getHeaders(),
      );

      log("Response -> ${response.body}");

      if (response.statusCode == 200) {
        log("Get All Tender API Call success");
        final Map<String, dynamic> responseBody = json.decode(response.body);

        final List<dynamic> data = responseBody['data']['data'];
        return data.map((json) => TenderModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load Tenders');
      }
    } catch (e) {
      throw Exception('Failed to load tenders');
    }
  }

  Future<TenderModel> fetchTenderById(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$url/$id'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        log("Tender $id fetched success!");

        final Map<String, dynamic> responseBody = json.decode(response.body);
        final dynamic data = responseBody['data']['data'];

        return TenderModel.fromJson(json.decode(data));
      } else {
        throw Exception('Failed to load tender');
      }
    } catch (e) {
      log("Error fetching tender $id: $e");
      throw Exception('Failed to load tender');
    }
  }

  Future<TenderModel> createTender(TenderModel tender) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: await _getHeaders(),
      );
      if (response.statusCode == 201) {
        return TenderModel.fromJson(json.decode(response.body)['data']['data']);
      } else {
        throw Exception('Failed to create tender');
      }
    } catch (e) {
      log("Error creating tender : $e");
      throw Exception('Failed to create tender : $e');
    }
  }

  Future<void> deleteTender(String id) async {
    final response = await http.delete(
      Uri.parse('$url/$id'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete tender');
    }
  }

  Future<TenderModel> acceptBid(String bidId) async {
    final response = await http.patch(
      Uri.parse('$url/accept-bid/$bidId'),
      headers: await _getHeaders(),
      body: json.encode({'bidId': bidId}),
    );

    if (response.statusCode == 200) {
      return TenderModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to accept bid');
    }
  }

  Future<List<TenderModel>> fetchTenders({
    Map<String, dynamic>? queryParams,
  }) async {
    final uri = Uri.parse(url).replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      log("Tenders fetched related to query params");
      final List<dynamic> data = json.decode(response.body)['data']['data'];
      return data.map((json) => TenderModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tenders');
    }
  }
}
