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
  void initState() {
    super.initState();
    // Optionally refresh data when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<SellerCategoryProvider>(
        context,
        listen: false,
      );
      if (provider.sellerCategories.isEmpty && provider.errorMessage.isEmpty) {
        provider.fetchAllCategories();
      }
    });
  }

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

          return _buildContent(
            context: context,
            sellerCategoryProvider: sellerCategoryProvider,
            signUpProvider: signUpProvider,
            selectedCategory: selectedCategory,
          );
        },
      ),
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required SellerCategoryProvider sellerCategoryProvider,
    required SignupProvider signUpProvider,
    required String? selectedCategory,
  }) {
    if (sellerCategoryProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (sellerCategoryProvider.errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              sellerCategoryProvider.errorMessage,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                sellerCategoryProvider.clearError();
                sellerCategoryProvider.fetchAllCategories();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (sellerCategoryProvider.sellerCategories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No categories available'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => sellerCategoryProvider.fetchAllCategories(),
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }

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
          const SizedBox(height: 5),
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
              shrinkWrap: true,
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: sellerCategoryProvider.sellerCategories.length,
              itemBuilder: (context, index) {
                final category = sellerCategoryProvider.sellerCategories[index];
                return _buildCategoryItem(
                  context: context,
                  category: category,
                  selectedCategory: selectedCategory,
                  onTap: () => signUpProvider.setCategory(category.id),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          _buildContinueButton(
            context: context,
            isActive: selectedCategory != null,
            onPressed: () {
              GoRouter.of(context).pushNamed(RouterNames.userInfo);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem({
    required BuildContext context,
    required SellerCategoryModel category,
    required String? selectedCategory,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.1,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
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
                width: MediaQuery.of(context).size.width * 0.15,
                child: Image.network(
                  category.imageOnSellerSide,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.description,
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
  }

  Widget _buildContinueButton({
    required BuildContext context,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isActive ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          "Continue",
          style: TextStyle(
            fontSize: 18,
            color: isActive
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
