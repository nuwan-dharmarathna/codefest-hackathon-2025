import 'package:frontend/routers/router_names.dart';
import 'package:frontend/screens/buyer/buyer_main_screen.dart';
import 'package:frontend/screens/onboarding_screen.dart';
import 'package:frontend/screens/registration/buyer_info_page.dart';
import 'package:frontend/screens/registration/select_location_page.dart';
import 'package:frontend/screens/registration/seller_category_page.dart';
import 'package:frontend/screens/registration/seller_info_page.dart';
import 'package:frontend/screens/sign_in_screen.dart';
import 'package:frontend/screens/sign_up_screen.dart';
import 'package:frontend/screens/splash_screen.dart';
import 'package:frontend/screens/welcome_screen.dart';
import 'package:frontend/widgets/otp_form.dart';
import 'package:go_router/go_router.dart';

class RouterClass {
  final router = GoRouter(
    initialLocation: "/selectLocation",
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
        routes: [
          GoRoute(
            path: "/sellerCategory",
            name: RouterNames.sellerCategory,
            builder: (context, state) => SellerCategoryPage(),
            routes: [
              GoRoute(
                path: "/sellerInfo",
                name: RouterNames.sellerInfo,
                builder: (context, state) => SellerInfoPage(),
              ),
            ],
          ),
          GoRoute(
            path: "/buyerInfo",
            name: RouterNames.buyerInfo,
            builder: (context, state) => BuyerInfoPage(),
          ),
        ],
      ),
      GoRoute(
        path: "/otp",
        name: RouterNames.otp,
        builder: (context, state) => OtpForm(),
      ),
      GoRoute(
        path: "/selectLocation",
        name: RouterNames.selectLocation,
        builder: (context, state) => SelectLocationPage(),
      ),
      GoRoute(
        path: "/buyer",
        name: RouterNames.buyer,
        builder: (context, state) => BuyerMainScreen(),
      ),
    ],
  );
}
