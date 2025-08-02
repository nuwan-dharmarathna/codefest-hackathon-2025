import 'package:flutter/material.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/providers/signup_provider.dart';
import 'package:frontend/routers/router_names.dart';
import 'package:frontend/widgets/form_progress_indicator.dart';
import 'package:frontend/widgets/user_type_card.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserTypePage extends StatelessWidget {
  const UserTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Consumer<SignupProvider>(
          builder: (context, signupProvider, child) {
            final selectedRole = signupProvider.role;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FormProgressIndicator(currentStep: 1, totalSteps: 3),
                const SizedBox(height: 34),
                Text(
                  'How would you like to join GoviChain?',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 2,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 40),
                UserTypeCard(
                  type: UserRole.buyer,
                  isSelected: selectedRole == UserRole.buyer,
                  description:
                      "Discover fresh, local products straight from the source",
                  onTap: () {
                    signupProvider.setRole(UserRole.buyer);
                  },
                ),
                const SizedBox(height: 15),
                UserTypeCard(
                  type: UserRole.seller,
                  isSelected: selectedRole == UserRole.seller,
                  description:
                      "List your harvest, set your own prices, and connect directly with buyers.",
                  onTap: () {
                    signupProvider.setRole(UserRole.seller);
                  },
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedRole != null) {
                        print(signupProvider.role);
                        GoRouter.of(
                          context,
                        ).pushNamed(RouterNames.selectLocation);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select your role"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.1),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Continue",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                SizedBox(height: 40),
              ],
            );
          },
        ),
      ),
    );
  }
}
