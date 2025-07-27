import 'package:flutter/material.dart';
import 'package:frontend/providers/registration_provider.dart';
import 'package:frontend/screens/registration/user_type_page.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegistrationProvider(),
      child: UserTypePage(),
    );
  }
}
