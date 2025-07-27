import 'package:frontend/routers/router_names.dart';
import 'package:frontend/screens/onboarding_screen.dart';
import 'package:frontend/screens/signIn_screen.dart';
import 'package:frontend/screens/signUp_screen.dart';
import 'package:frontend/screens/splash_screen.dart';
import 'package:frontend/screens/welcome_screen.dart';
import 'package:go_router/go_router.dart';

class RouterClass {
  final router = GoRouter(
    routes: [
      GoRoute(
        path: "/",
        name: RouterNames.splash,
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: "/onboarding",
        name: RouterNames.onboarding,
        builder: (context, state) => OnboardingScreen(),
      ),
      GoRoute(
        path: "/welcome",
        name: RouterNames.welcome,
        builder: (context, state) => WelcomeScreen(),
      ),
      GoRoute(
        path: "/signIn",
        name: RouterNames.signIn,
        builder: (context, state) => SigninScreen(),
      ),
      GoRoute(
        path: "/signUp",
        name: RouterNames.signUp,
        builder: (context, state) => SignupScreen(),
      ),
    ],
  );
}
