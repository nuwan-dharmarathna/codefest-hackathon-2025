import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/services/auth_service.dart';

class SignupProvider extends ChangeNotifier {
  final AuthApiService _authApiService = AuthApiService();
  // Hold the current user being registered
  UserModel _userModel = UserModel();

  // getter to access user
  UserModel get user => _userModel;

  // getter to role
  UserRole? get role => _userModel.role;

  // getter to location
  String? get location => _userModel.location;

  //getter to category
  String? get category => _userModel.categoryId;

  // Set role
  void setRole(UserRole role) {
    _userModel.role = role;
    notifyListeners();
  }

  // set location
  void setLocation(String location) {
    _userModel.location = location;
    notifyListeners();
  }

  // (Seller only): Set Category
  void setCategory(String categoryId) {
    _userModel.categoryId = categoryId;
    notifyListeners();
  }

  // Set Basic Details (Shared)
  void setUserDetails({
    required String firstName,
    required String lastName,
    required String phone,
    required String email,
    required String password,
    required String sludiNo,
    required String nic,
  }) {
    _userModel.firstName = firstName;
    _userModel.lastName = lastName;
    _userModel.phone = phone;
    _userModel.email = email;
    _userModel.password = password;
    _userModel.sludiNo = sludiNo;
    _userModel.nic = nic;
    notifyListeners();
  }

  // (Seller only): Add business info
  void setBusinessInfo({
    required String businessName,
    String? businessRegistrationNo,
  }) {
    _userModel.businessName = businessName;
    _userModel.businessRegistrationNo = businessRegistrationNo ?? '';
    notifyListeners();
  }

  //Reset provider after registration
  void clear() {
    _userModel = UserModel();
    notifyListeners();
  }

  // signUp User
  Future<Map<String, dynamic>> signUpUser(UserModel user) async {
    try {
      final response = await _authApiService.registerUser(user);

      // Directly return successful responses
      if (response['status'] == 'success') {
        return response;
      }

      // Format error responses consistently
      return {
        'status': 'failed',
        'error':
            response['error'] ??
            {
              'statusCode': 400,
              'message': response['message'] ?? 'Registration failed',
            },
        'message': response['message'] ?? 'Registration failed',
      };
    } catch (e) {
      log("Registration error: $e");

      // Handle cases where the error is actually a success response
      if (e.toString().contains('{"status":"success"')) {
        try {
          return json.decode(e.toString().split('Exception: ').last);
        } catch (_) {
          // Fall through to normal error handling
        }
      }

      return {
        'status': 'failed',
        'error': {'statusCode': 500, 'message': 'Network error'},
        'message': 'Failed to connect to server',
      };
    }
  }
}
