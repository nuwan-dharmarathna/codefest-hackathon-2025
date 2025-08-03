import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/routers/router_names.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/widgets/custom_alert_box.dart';
import 'package:frontend/widgets/custom_user_menu_list_tile.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Consumer2<ThemeProvider, UserProvider>(
        builder: (context, themeProvider, userProvider, child) {
          bool isDark = themeProvider.themeMode == ThemeMode.dark;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "My Profile",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 1.5,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6.0,
                        vertical: 1,
                      ),
                      child: Text(
                        userProvider.user?.role == UserRole.buyer
                            ? "Buyer"
                            : "Seller",
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    themeProvider.toggleTheme(!isDark);
                  },
                  icon: isDark
                      ? const Icon(Icons.light_mode)
                      : const Icon(Icons.dark_mode),
                ),
              ],
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.tertiary,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: Offset(0, 4),
                          ),
                        ],
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.3),
                          ],
                        ),
                      ),
                      child: ClipOval(
                        child: Container(
                          padding: EdgeInsets.all(4), // Adds inner spacing
                          child: Image.asset(
                            "assets/icons/user.png",
                            width: MediaQuery.of(context).size.width * 0.25,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.person,
                              size: MediaQuery.of(context).size.width * 0.15,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "${userProvider.user?.firstName} ${userProvider.user?.lastName}",
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${userProvider.user?.phone}",
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(width: 15),
                        Text("|", style: TextStyle(fontSize: 14)),
                        SizedBox(width: 15),
                        Text(
                          "${userProvider.user?.email}",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.width * 0.1,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.2),
                        ),
                        onPressed: () {
                          GoRouter.of(
                            context,
                          ).pushNamed(RouterNames.editUserDetails);
                        },
                        child: Text("Edit Profile"),
                      ),
                    ),
                    SizedBox(height: 35),
                    // Menu
                    CustomUserMenuListTile(
                      title: "Settings",
                      leadingIcon: Icons.settings,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertBox(
                              title: "Warning",
                              message:
                                  "Coming soon!\nThis Settings feature is still in development.",
                              icon: Icons.warning_amber_rounded,
                            );
                          },
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    CustomUserMenuListTile(
                      title: "My Purchases",
                      leadingIcon: Icons.wallet_rounded,
                      onPressed: () {
                        GoRouter.of(
                          context,
                        ).pushNamed(RouterNames.buyerPurchases);
                      },
                    ),
                    SizedBox(height: 10),
                    CustomUserMenuListTile(
                      title: "Update Passwords",
                      leadingIcon: Icons.password_rounded,
                      onPressed: () {
                        GoRouter.of(
                          context,
                        ).pushNamed(RouterNames.updatePassword);
                      },
                    ),
                    SizedBox(height: 10),
                    CustomUserMenuListTile(
                      title: "Logout",
                      leadingIcon: Icons.logout_rounded,
                      onPressed: () {
                        AuthApiService apiService = AuthApiService();
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => _logoutDialogBox(
                            context,
                            () {
                              log("Logout Cancelled");
                            },
                            () async {
                              await apiService.logout();
                              userProvider.clearUser();
                              context.goNamed(RouterNames.signIn);
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _logoutDialogBox(
  BuildContext context,
  VoidCallback onCancel,
  VoidCallback onConfirm,
) {
  return AlertDialog(
    title: Text("Logout"),
    content: Text("Are you sure you want to logout?"),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    actionsAlignment: MainAxisAlignment.spaceBetween,
    actions: [
      // Cancel Button
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          onCancel.call();
        },
        child: Text(
          "Cancel",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      TextButton(
        onPressed: () {
          Navigator.of(context).pop(); // Close dialog
          onConfirm(); // Execute logout
        },
        style: TextButton.styleFrom(
          foregroundColor: Theme.of(context).colorScheme.error,
        ),
        child: Text(
          "Logout",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
    ],
  );
}
