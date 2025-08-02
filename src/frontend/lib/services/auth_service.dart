import 'dart:convert';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/utils/constants.dart';
import 'package:http/http.dart' as http;

class AuthApiService {
  final String url = "$baseURL/auth";

  Future<Map<String, dynamic>> registerUser(UserModel user) async {
    final response = await http.post(
      Uri.parse("$url/signUp"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to register user: ${response.body}');
    }
  }

  // Add other auth-related methods (login, etc.)
}
