import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/routers/router_names.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _checkAuthStatus();
    super.initState();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userJson = prefs.getString('loggedUser');

    // Add token validation check
    final isTokenValid = token != null
        ? await AuthApiService().isTokenValid()
        : false;

    log("Token validation :$isTokenValid");

    await Future.delayed(const Duration(seconds: 2)); // Splash delay

    if (!mounted) return;

    // No token or invalid token
    if (token == null || userJson == null || !isTokenValid) {
      await _handleUnauthenticated(prefs);
      return;
    }

    // Valid token exists
    await _handleAuthenticated(userJson);
  }

  Future<void> _handleUnauthenticated(SharedPreferences prefs) async {
    final isFirstLaunch = prefs.getBool('first_launch') ?? true;

    if (isFirstLaunch) {
      await prefs.setBool('first_launch', false);
      openOnboardingSection();
    } else {
      if (mounted) {
        context.goNamed(RouterNames.signIn);
      }
    }
  }

  Future<void> _handleAuthenticated(String userJson) async {
    try {
      // Decode ONLY ONCE
      final userModel = UserModel.fromJson(jsonDecode(userJson));

      // Update provider state
      if (mounted) {
        Provider.of<UserProvider>(context, listen: false).setUser(userModel);
      }

      // Verify critical user data
      if (userModel.role == null || userModel.id == null) {
        throw Exception('Incomplete user data');
      }

      // Navigate with route protection
      if (mounted) {
        context.goNamed(
          userModel.role == UserRole.seller
              ? RouterNames.seller
              : RouterNames.buyer,
          extra: userModel, // Pass the MODEL, not raw map
        );
      }
    } catch (e) {
      log('Auth Error: $e');
      if (mounted) {
        // Clear invalid data
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        await prefs.remove('loggedUser');

        context.goNamed(RouterNames.signIn);
      }
    }
  }

  void openOnboardingSection() async {
    context.goNamed(RouterNames.onboarding);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ClipRRect(
            child: Theme.of(context).brightness == Brightness.light
                ? Image.asset(
                    "assets/images/logo_light.png",
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width * 0.9,
                  )
                : Image.asset(
                    "assets/images/logo_dark.png",
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width * 0.9,
                  ),
          ),
        ),
      ),
    );
  }
}
