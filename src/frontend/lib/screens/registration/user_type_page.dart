import 'package:flutter/material.dart';
import 'package:frontend/models/user_type.dart';
import 'package:frontend/providers/registration_provider.dart';
import 'package:frontend/routers/router_names.dart';
import 'package:frontend/widgets/form_progress_indicator.dart';
import 'package:frontend/widgets/user_type_card.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class UserTypePage extends StatelessWidget {
  const UserTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);
    final currentType = provider.registrationData.userType;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormProgressIndicator(currentStep: 1, totalSteps: 3),
            SizedBox(height: 34),
            Text(
              'How would you like to join GoviChain?',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                height: 2,
                fontSize: 30,
              ),
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                provider.setUserType(UserType.buyer);
              },
              child: UserTypeCard(
                type: UserType.buyer,
                isSelected: currentType == UserType.buyer,
                description:
                    "Discover fresh, local products straight from the source",
                onTap: () {
                  provider.setUserType(UserType.buyer);
                },
              ),
            ),
            SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                provider.setUserType(UserType.seller);
              },
              child: UserTypeCard(
                type: UserType.seller,
                isSelected: currentType == UserType.seller,
                description:
                    "List your harvest, set your own prices, and connect directly with buyers.",
                onTap: () {
                  provider.setUserType(UserType.buyer);
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.3),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  currentType == UserType.buyer
                      ? GoRouter.of(context).pushNamed(RouterNames.buyerInfo)
                      : GoRouter.of(
                          context,
                        ).pushNamed(RouterNames.sellerCategory);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.1),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text("Continue", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
