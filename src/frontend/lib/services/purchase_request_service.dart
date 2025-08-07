import 'dart:convert';

import 'package:frontend/models/purchase_request_model.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/utils/constants.dart';
import 'package:http/http.dart' as http;

class PurchaseRequestService {
  final url = "$baseURL/purchases";
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

  Future<List<PurchaseRequestModel>> fetchRequestsBasedOnSeller() async {
    try {
      final response = await http.get(
        Uri.parse("$url/user"),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);

        final List<dynamic> data = responseBody['data']['data'];
        return data.map((json) => PurchaseRequestModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load Tenders');
      }
    } catch (e) {
      throw Exception('Failed to load tenders');
    }
  }
}
