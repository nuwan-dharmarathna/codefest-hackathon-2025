import 'dart:convert';
import 'dart:developer';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthApiService {
  final String url = "$baseURL/auth";

  Future<Map<String, dynamic>> registerUser(UserModel user) async {
    try {
      final response = await http.post(
        Uri.parse("$url/signUp"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user.toJson()),
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode == 201) {
        return responseBody;
      } else {
        throw Exception('Failed to register user: ${response.body}');
      }
    } on Exception catch (e) {
      throw Exception("user registration failed: $e");
    }
  }

  // Add other auth-related methods (login, etc.)
  Future<Map<String, dynamic>> signInUser({
    required String sludiNo,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$url/signIn"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"sludiNo": sludiNo, "password": password}),
      );

      // First decode the response body
      final result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Validate the response structure
        if (result["token"] == null ||
            result["data"] == null ||
            result["data"]["user"] == null) {
          throw Exception("Invalid response format from server");
        }

        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();

        // Store token
        await sharedPreferences.setString("token", result["token"].toString());

        // Convert user object to JSON string before storing
        await sharedPreferences.setString(
          "loggedUser",
          jsonEncode(result["data"]["user"]),
        );

        return result;
      } else {
        // Handle error responses
        final errorMessage =
            result["message"]?.toString() ?? "Unknown error occurred";
        throw Exception(
          "Sign-in failed: $errorMessage (Status: ${response.statusCode})",
        );
      }
    } on http.ClientException catch (e) {
      throw Exception("Network error: ${e.message}");
    } on FormatException catch (e) {
      throw Exception("Invalid server response: ${e.message}");
    } catch (e) {
      throw Exception("Sign-in error: ${e.toString()}");
    }
  }

  //logout
  Future<void> logout() async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      sharedPreferences.remove("token");
      sharedPreferences.remove("loggedUser");
    } catch (e) {
      log("user logout failed! -> $e");
    }
  }

  // get stored token
  Future<String?> getJwtToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString("token");
  }

  Future<bool> isTokenValid() async {
    try {
      // 1. Get token from SharedPreferences
      final String? token = await getJwtToken();

      if (token == null || token.isEmpty) {
        return false; // No token exists
      }

      // 2. Decode JWT to check expiration
      final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      final int expirationTimestamp = decodedToken['exp'] as int;
      final DateTime expirationDate = DateTime.fromMillisecondsSinceEpoch(
        expirationTimestamp * 1000,
      );
      final DateTime currentDate = DateTime.now();

      // 3. Compare with current time (with 1 minute buffer)
      return currentDate.isBefore(
        expirationDate.subtract(const Duration(minutes: 1)),
      );
    } catch (e) {
      log('Token validation error: $e');
      return false; // Invalid token format
    }
  }
}
