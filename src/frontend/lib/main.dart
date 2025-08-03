import 'package:flutter/material.dart';
import 'package:frontend/providers/seller_category_provider.dart';
import 'package:frontend/providers/signup_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/routers/router.dart';
import 'package:frontend/utils/theme_data.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SignupProvider()),
        ChangeNotifierProvider(create: (context) => SellerCategoryProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "GoviChain",
      debugShowCheckedModeBanner: false,
      theme: lightMode,
      darkTheme: darkMode,
      routerConfig: RouterClass.router,
    );
  }
}
