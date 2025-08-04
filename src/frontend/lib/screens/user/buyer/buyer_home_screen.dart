import 'package:flutter/material.dart';
import 'package:frontend/providers/seller_category_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/widgets/custom_category_card.dart';
import 'package:provider/provider.dart';

class BuyerHomeScreen extends StatefulWidget {
  const BuyerHomeScreen({super.key});

  @override
  State<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends State<BuyerHomeScreen> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategories();
    });
  }

  Future<void> _loadCategories() async {
    final provider = Provider.of<SellerCategoryProvider>(
      context,
      listen: false,
    );
    await provider.fetchAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _loadCategories,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
              ),
              child: Consumer2<UserProvider, SellerCategoryProvider>(
                builder: (context, userProvider, sellerCategoryProvider, child) {
                  if (sellerCategoryProvider.isLoading) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (sellerCategoryProvider.errorMessage.isNotEmpty) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(sellerCategoryProvider.errorMessage),
                            ElevatedButton(
                              onPressed: _loadCategories,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with greeting and notification icon
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Have a Good Day!",
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                ),
                                Text(
                                  "${userProvider.user?.firstName} ${userProvider.user?.lastName}",
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.notifications_none_rounded,
                                size: 32,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),

                        // Search field
                        TextField(
                          decoration: InputDecoration(
                            hintText: "Search",
                            prefixIcon: const Icon(Icons.search),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Popular Categories title
                        Text(
                          "Popular Categories",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 20),

                        // Categories horizontal list
                        SizedBox(
                          height: 120,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                sellerCategoryProvider.sellerCategories.length,
                            itemBuilder: (context, index) {
                              final category = sellerCategoryProvider
                                  .sellerCategories[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: CustomCategoryCard(
                                  isSelected: false,
                                  title: category.nameOnBuyerSide,
                                  imageUrl: category.imageOnBuyerSide,
                                  onTap: () {
                                    // Handle category tap
                                  },
                                ),
                              );
                            },
                          ),
                        ),

                        // Add more content here if needed
                        // Make sure to add SizedBox for spacing between widgets
                        const SizedBox(height: 20),

                        // Example: Add another section
                        Text(
                          "Featured Products",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 20),

                        // You would add your products list here
                        // Placeholder for demonstration
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text("Featured products will appear here"),
                          ),
                        ),

                        // Add bottom padding to prevent overflow
                        const SizedBox(height: 40),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
