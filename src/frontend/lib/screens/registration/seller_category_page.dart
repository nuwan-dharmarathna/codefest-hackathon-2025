import 'package:flutter/material.dart';
import 'package:frontend/models/seller_category_model.dart';
import 'package:frontend/providers/seller_category_provider.dart';
import 'package:frontend/providers/signup_provider.dart';
import 'package:frontend/routers/router_names.dart';
import 'package:frontend/widgets/form_progress_indicator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SellerCategoryPage extends StatefulWidget {
  const SellerCategoryPage({super.key});

  @override
  State<SellerCategoryPage> createState() => _SellerCategoryPageState();
}

class _SellerCategoryPageState extends State<SellerCategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Consumer2<SellerCategoryProvider, SignupProvider>(
        builder: (context, sellerCategoryProvider, signUpProvider, child) {
          final selectedCategory = signUpProvider.category;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const FormProgressIndicator(currentStep: 3, totalSteps: 4),
                const SizedBox(height: 34),
                Text(
                  "Tell us what you sell",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 2,
                    fontSize: 30,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Choose your category so buyers can find you easily.",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 2,
                    fontSize: 20,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(bottom: 20), // Add bottom padding
                    itemCount: sellerCategoryProvider.sellerCategories.length,
                    itemBuilder: (context, index) {
                      final category =
                          sellerCategoryProvider.sellerCategories[index];
                      return GestureDetector(
                        onTap: () {
                          signUpProvider.setCategory(category.id);
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: 12),
                          constraints: BoxConstraints(
                            minHeight: MediaQuery.of(context).size.height * 0.1,
                          ),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                ? Colors.white60
                                : Colors.white54.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: selectedCategory == category.id
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                              width: selectedCategory == category.id ? 1.5 : 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  child: Image.asset(
                                    _getCategoryIcon(category),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        category.name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        category.description,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withOpacity(0.6),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  margin: EdgeInsets.only(bottom: 40),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedCategory == null
                        ? null
                        : () {
                            GoRouter.of(
                              context,
                            ).pushNamed(RouterNames.userInfo);
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
          );
        },
      ),
    );
  }

  String _getCategoryIcon(SellerCategoryModel category) {
    if (category.slug == 'farmer') {
      return "assets/icons/farmer.png";
    } else if (category.slug == 'gardner') {
      return "assets/icons/gardening.png";
    } else if (category.slug == 'handcarft-item-maker') {
      return "assets/icons/handicrafts.png";
    } else if (category.slug == 'live-stock-producer') {
      return "assets/icons/meat.png";
    } else {
      return "assets/icons/chicken.png";
    }
  }
}
