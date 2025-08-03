import 'package:flutter/material.dart';
import 'package:frontend/utils/theme_data.dart'; // Import your theme file

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;
  ThemeData get themeData => isDarkMode ? darkMode : lightMode;

  void toggleTheme(bool isOn) {
    _themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
