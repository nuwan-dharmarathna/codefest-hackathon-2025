import 'package:flutter/material.dart';
import 'package:frontend/routers/router_names.dart';
import 'package:frontend/widgets/custom_text_input.dart';
import 'package:go_router/go_router.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sluidNoController = TextEditingController();
  final _nicNoController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _sluidNoController.dispose();
    _nicNoController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                    onSaved: (newValue) =>
                        _sluidNoController.text = newValue ?? '',
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
                    onSaved: (newValue) =>
                        _passwordController.text = newValue ?? '',
                    obscureText: true,
                  ),

                  SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      // Todo: Need to impl
                      onTap: () {},
                      child: Text("Forgot Password?"),
                    ),
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.1),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text("Sign In", style: TextStyle(fontSize: 18)),
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
