import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/models/advertisement_model.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/routers/router_names.dart';
import 'package:frontend/screens/user/advertisement_details_screen.dart';
import 'package:frontend/screens/user/buyer/buyer_main_screen.dart';
import 'package:frontend/screens/user/buyer/buyer_purchases_screen.dart';
import 'package:frontend/screens/onboarding_screen.dart';
import 'package:frontend/screens/registration/select_location_page.dart';
import 'package:frontend/screens/registration/seller_category_page.dart';
import 'package:frontend/screens/registration/user_info_page.dart';
import 'package:frontend/screens/user/seller/create_advertisement_screen.dart';
import 'package:frontend/screens/user/seller/seller_main_screen.dart';
import 'package:frontend/screens/sign_in_screen.dart';
import 'package:frontend/screens/sign_up_screen.dart';
import 'package:frontend/screens/splash_screen.dart';
import 'package:frontend/screens/user/edit_user_details_screen.dart';
import 'package:frontend/screens/user/update_password_screen.dart';
import 'package:frontend/screens/welcome_screen.dart';
import 'package:frontend/widgets/otp_form.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RouterClass {
  static final router = GoRouter(
    initialLocation: "/",
    redirect: _redirectLogic,
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
            path: "/selectLocation",
            name: RouterNames.selectLocation,
            builder: (context, state) => SelectLocationPage(),
          ),
          GoRoute(
            path: "/sellerCategory",
            name: RouterNames.sellerCategory,
            builder: (context, state) => SellerCategoryPage(),
          ),
          GoRoute(
            path: "/userInfo",
            name: RouterNames.userInfo,
            builder: (context, state) => UserInfoPage(),
          ),
        ],
      ),
      GoRoute(
        path: "/otp",
        name: RouterNames.otp,
        builder: (context, state) => OtpForm(),
      ),
      GoRoute(
        path: "/buyer",
        name: RouterNames.buyer,
        builder: (context, state) => BuyerMainScreen(),
      ),
      GoRoute(
        path: "/seller",
        name: RouterNames.seller,
        builder: (context, state) => SellerMainScreen(),
      ),
      GoRoute(
        path: "/buyerPurchases",
        name: RouterNames.buyerPurchases,
        builder: (context, state) => BuyerPurchasesScreen(),
      ),
      GoRoute(
        path: "/updatePassword",
        name: RouterNames.updatePassword,
        builder: (context, state) => UpdatePasswordScreen(),
      ),
      GoRoute(
        path: "/editUserDetails",
        name: RouterNames.editUserDetails,
        builder: (context, state) => EditUserDetailsScreen(),
      ),
      GoRoute(
        path: "/createAdvertisement",
        name: RouterNames.createAdvertisement,
        builder: (context, state) => CreateAdvertisementScreen(),
      ),
      GoRoute(
        path: "/advertisementDetails",
        name: RouterNames.advertisementDetails,
        builder: (context, state) {
          final advertisementJson =
              state.uri.queryParameters["advertisementDetails"];

          final advertisement = AdvertisementModel.fromJson(
            jsonDecode(advertisementJson!),
          );

          return AdvertisementDetailsScreen(ad: advertisement);
        },
      ),
    ],
  );

  static String? _redirectLogic(BuildContext context, GoRouterState state) {
    // Skip redirection for these routes
    if (state.matchedLocation == '/' ||
        state.matchedLocation == '/onboarding' ||
        state.matchedLocation == '/signIn' ||
        state.matchedLocation == '/signUp') {
      return null;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final isLoggedIn = userProvider.user != null;

    if (!isLoggedIn) {
      return '/signIn'; // Redirect to sign in if not authenticated
    }

    return null;
  }
}
