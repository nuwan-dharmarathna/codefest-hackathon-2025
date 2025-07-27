import 'package:flutter/material.dart';
import 'package:frontend/routers/router.dart';
import 'package:frontend/utils/theme_data.dart';

void main() {
  runApp(MyApp());
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
      routerConfig: RouterClass().router,
    );
  }
}
