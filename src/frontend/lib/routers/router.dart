import 'package:frontend/routers/router_names.dart';
import 'package:frontend/screens/user/buyer/buyer_main_screen.dart';
import 'package:frontend/screens/user/buyer/buyer_purchases_screen.dart';
import 'package:frontend/screens/onboarding_screen.dart';
import 'package:frontend/screens/registration/select_location_page.dart';
import 'package:frontend/screens/registration/seller_category_page.dart';
import 'package:frontend/screens/registration/user_info_page.dart';
import 'package:frontend/screens/user/seller/seller_main_screen.dart';
import 'package:frontend/screens/sign_in_screen.dart';
import 'package:frontend/screens/sign_up_screen.dart';
import 'package:frontend/screens/splash_screen.dart';
import 'package:frontend/screens/user/edit_user_details_screen.dart';
import 'package:frontend/screens/user/update_password_screen.dart';
import 'package:frontend/screens/welcome_screen.dart';
import 'package:frontend/widgets/otp_form.dart';
import 'package:go_router/go_router.dart';

class RouterClass {
  static final router = GoRouter(
    initialLocation: "/",
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
    ],
  );
}
