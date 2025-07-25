import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightMode = ThemeData(
  fontFamily: GoogleFonts.lato().fontFamily,
  colorScheme: ColorScheme.light(
    primary: Color(0xFF2E7D32), // Deep green (trust, growth)
    secondary: Color(0xFFF57F17), // Warm amber (energy, Sri Lankan influence)
    surface: Color(0xFFFFFFFF), // Light gray background
    error: Color(0xFFC62828), // Alert red
    onPrimary: Color(0xFFFFFFFF), // White text on primary
    onSecondary: Color(0xFF000000), // Black text on secondary
    onSurface: Color(0xFF212121), // Dark gray text
    onError: Color(0xFFFFFFFF), // White text on error
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF424242)),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF2E7D32),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),
);

ThemeData darkMode = ThemeData(
  fontFamily: GoogleFonts.lato().fontFamily,
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF81C784), // Soft green
    secondary: Color(0xFFFFB74D), // Muted amber
    surface: Color(0xFF121212), // Slightly lighter dark gray
    error: Color(0xFFEF5350), // Soft red
    onPrimary: Color(0xFF000000), // Black text on primary
    onSecondary: Color(0xFF000000), // Black text on secondary
    onSurface: Color(0xFFFFFFFF), // White text
    onError: Color(0xFF000000), // Black text on error
  ),
  textTheme: TextTheme(
    displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    bodyLarge: TextStyle(fontSize: 16, color: Color(0xFFE0E0E0)),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF1B5E20),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  ),
);
