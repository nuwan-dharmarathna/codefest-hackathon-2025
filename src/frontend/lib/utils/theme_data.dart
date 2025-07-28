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
    // Display Text (Large Headings)
    displayLarge: TextStyle(
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      height: 1.2,
    ),
    displayMedium: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      height: 1.25,
    ),
    displaySmall: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
      height: 1.3,
    ),

    // Headlines (Page/Section Titles)
    headlineLarge: TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
      height: 1.3,
    ),
    headlineMedium: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      height: 1.35,
    ),
    headlineSmall: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),

    // Titles (Card Titles, List Headers)
    titleLarge: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
      height: 1.4,
    ),
    titleMedium: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      height: 1.4,
    ),
    titleSmall: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      height: 1.4,
    ),

    // Body Text (Primary Content)
    bodyLarge: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
    bodySmall: TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),

    // Labels (Buttons, Form Fields)
    labelLarge: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.4,
    ),
    labelMedium: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.3,
      height: 1.4,
    ),
    labelSmall: TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
      height: 1.4,
    ),
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
    // Display Text (Large Headings)
    displayLarge: TextStyle(
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      height: 1.2,
    ),
    displayMedium: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      height: 1.25,
    ),
    displaySmall: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
      height: 1.3,
    ),

    // Headlines (Page/Section Titles)
    headlineLarge: TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
      height: 1.3,
    ),
    headlineMedium: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      height: 1.35,
    ),
    headlineSmall: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),

    // Titles (Card Titles, List Headers)
    titleLarge: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
      height: 1.4,
    ),
    titleMedium: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      height: 1.4,
    ),
    titleSmall: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      height: 1.4,
    ),

    // Body Text (Primary Content)
    bodyLarge: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),
    bodySmall: TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w400,
      height: 1.5,
    ),

    // Labels (Buttons, Form Fields)
    labelLarge: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      height: 1.4,
    ),
    labelMedium: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.3,
      height: 1.4,
    ),
    labelSmall: TextStyle(
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
      height: 1.4,
    ),
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
