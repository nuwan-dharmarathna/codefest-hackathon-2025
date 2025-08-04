import 'package:flutter/material.dart';
import 'package:frontend/providers/category_filter_provider.dart';
import 'package:frontend/providers/seller_category_provider.dart';
import 'package:frontend/providers/signup_provider.dart';
import 'package:frontend/providers/sub_category_provider.dart';
import 'package:frontend/providers/tender_provider.dart';
import 'package:frontend/providers/theme_provider.dart';
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
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => TenderProvider()),
        ChangeNotifierProvider(create: (context) => SubCategoryProvider()),
        ChangeNotifierProvider(create: (context) => CategoryFilterProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp.router(
          title: "GoviChain",
          debugShowCheckedModeBanner: false,
          theme: lightMode,
          darkTheme: darkMode,
          themeMode: themeProvider.themeMode,
          routerConfig: RouterClass.router,
        );
      },
    );
  }
}
