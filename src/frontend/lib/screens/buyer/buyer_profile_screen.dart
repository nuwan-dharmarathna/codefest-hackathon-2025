import 'package:flutter/material.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class BuyerProfileScreen extends StatefulWidget {
  const BuyerProfileScreen({super.key});

  @override
  State<BuyerProfileScreen> createState() => _BuyerProfileScreenState();
}

class _BuyerProfileScreenState extends State<BuyerProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDark = themeProvider.themeMode == ThemeMode.dark;

    void _changeDarkLightMode() {
      themeProvider.toggleTheme(!isDark);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: const Center(child: Text("Profile")),
          actions: [
            IconButton(
              onPressed: _changeDarkLightMode,
              icon: isDark
                  ? const Icon(Icons.light_mode)
                  : const Icon(Icons.dark_mode),
            ),
          ],
          elevation: 0,
        ),
      ),
    );
  }
}
