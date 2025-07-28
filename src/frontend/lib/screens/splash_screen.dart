import 'package:flutter/material.dart';
import 'package:frontend/routers/router_names.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    openOnboardingSection();
    super.initState();
  }

  void openOnboardingSection() async {
    await Future.delayed(Duration(seconds: 2));
    GoRouter.of(context).pushNamed(RouterNames.onboarding);
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
