import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend/routers/router_names.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/widgets/custom_alert_box.dart';
import 'package:frontend/widgets/custom_submit_button.dart';
import 'package:frontend/widgets/custom_text_input.dart';
import 'package:go_router/go_router.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final _sluidNoController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthApiService _apiService = AuthApiService();

  @override
  void dispose() {
    _sluidNoController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signInUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        final res = await _apiService.signInUser(
          sludiNo: _sluidNoController.text,
          password: _passwordController.text,
        );

        _sluidNoController.text = "";
        _passwordController.text = "";

        if (res['status'] == 'success') {
          showDialog(
            context: context,
            builder: (ctx) => CustomAlertBox(
              icon: Icons.done,
              title: "Success",
              message: "Login successful!",
            ),
          ).then((_) {
            context.goNamed(RouterNames.splash);
          });
        } else {
          showDialog(
            context: context,
            builder: (ctx) => CustomAlertBox(
              icon: Icons.error,
              title: "Error",
              message: res['message'] ?? 'Registration failed',
            ),
          );
        }
      } catch (e) {
        log("Registration Failed In signIn Page :  $e");
        showDialog(
          context: context, // Make sure you have access to the BuildContext
          builder: (BuildContext context) {
            return CustomAlertBox(
              icon: Icons.close,
              title: "Somethig went wrong",
              message: e.toString(),
            );
          },
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: colorScheme.onBackground),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            // Header section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello Again!",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Welcome back you've been missed",
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.6),
                    height: 1.2,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 48),

            // Form section
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextInputField(
                    lableText: "SLUDI Number",
                    hintText: "Enter your SLUID number",
                    keyBoardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your SLUDI number";
                      }
                      return null;
                    },
                    onSaved: (newValue) {},
                    controller: _sluidNoController,
                    obscureText: false,
                  ),

                  const SizedBox(height: 20),

                  CustomTextInputField(
                    lableText: "Password",
                    hintText: "Enter your Password",
                    keyBoardType: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your Password";
                      }
                      return null;
                    },
                    onSaved: (newValue) {},
                    controller: _passwordController,
                    obscureText: true,
                  ),

                  SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                          context:
                              context, // Make sure you have access to the BuildContext
                          builder: (BuildContext context) {
                            return CustomAlertBox(
                              icon: Icons.warning_amber_rounded,
                              title: "Warning!",
                              message:
                                  "Coming soon!\nThis feature is still in development.",
                            );
                          },
                        );
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    child: CustomSubmitButton(
                      isLoading: isLoading,
                      onPressed: _signInUser,
                      lableText: "Sign In",
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 25),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Not a member? ", style: TextStyle(fontSize: 15)),
                  SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
                      GoRouter.of(context).pushNamed(RouterNames.signUp);
                    },
                    child: Text(
                      "Register Now",
                      style: TextStyle(fontSize: 15, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
