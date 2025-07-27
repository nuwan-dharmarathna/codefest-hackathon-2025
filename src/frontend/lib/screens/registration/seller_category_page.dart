import 'package:flutter/material.dart';
import 'package:frontend/models/seller_info.dart';
import 'package:frontend/providers/registration_provider.dart';
import 'package:frontend/routers/router_names.dart';
import 'package:frontend/widgets/form_progress_indicator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SellerCategoryPage extends StatelessWidget {
  const SellerCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);
    SellerCategory? selectedCategory =
        provider.registrationData.sellerInfo?.sellerCategory;

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
            const FormProgressIndicator(currentStep: 2, totalSteps: 3),
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
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(bottom: 20), // Add bottom padding
                itemCount: SellerCategory.values.length,
                itemBuilder: (context, index) {
                  final category = SellerCategory.values[index];
                  return GestureDetector(
                    onTap: () {
                      Provider.of<RegistrationProvider>(
                        context,
                        listen: false,
                      ).setSellerCategory(category);
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 12),
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.1,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.white60
                            : Colors.white54.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: selectedCategory == category
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey,
                          width: selectedCategory == category ? 1.5 : 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: Image.asset(
                                _getCategoryIcon(category),
                                fit: BoxFit.contain,
                              ),
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _getCategoryName(category),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    _getCategoryDescription(category),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withOpacity(0.6),
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
                        GoRouter.of(context).pushNamed(RouterNames.sellerInfo);
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

  String _getCategoryName(SellerCategory category) {
    switch (category) {
      case SellerCategory.farmer:
        return 'Farmer';
      case SellerCategory.liveStock:
        return 'Animal Product Producer';
      case SellerCategory.foodMaker:
        return 'Processed Food Maker';
      case SellerCategory.craftMaker:
        return 'Handicraft & Cottage Industry Seller';
      case SellerCategory.gardener:
        return 'Plant & Gardening Product Seller';
      case SellerCategory.other:
        return 'Other Rural SME';
    }
  }

  String _getCategoryDescription(SellerCategory category) {
    switch (category) {
      case SellerCategory.farmer:
        return 'Sell: Vegetables, fruits, grains, etc.';
      case SellerCategory.liveStock:
        return 'Sell: Eggs, milk, curd, meat, animal feed, etc.';
      case SellerCategory.foodMaker:
        return 'Sell: Snacks, dried fish, rice packets, pickles, sweets, etc.';
      case SellerCategory.craftMaker:
        return 'Sell: Handmade items, toys, baskets, candles, clothes';
      case SellerCategory.gardener:
        return 'Sell: Plant pots, seeds, compost, tools, herbal plants';
      case SellerCategory.other:
        return 'Sell: Animal feed, fertilizers, tools, soaps, etc.';
    }
  }

  String _getCategoryIcon(SellerCategory category) {
    switch (category) {
      case SellerCategory.farmer:
        return "assets/icons/farmer.png";
      case SellerCategory.liveStock:
        return "assets/icons/meat.png";
      case SellerCategory.foodMaker:
        return "assets/icons/juicer.png";
      case SellerCategory.craftMaker:
        return "assets/icons/handicrafts.png";
      case SellerCategory.gardener:
        return "assets/icons/gardening.png";
      case SellerCategory.other:
        return "assets/icons/chicken.png";
    }
  }
}
