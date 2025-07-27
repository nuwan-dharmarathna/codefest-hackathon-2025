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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  child: Image.asset(
                    "assets/images/logo.png",
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width * 0.7,
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  "Your Digital Bridge",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "To Fairer Commerce.",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
