import 'package:flutter/material.dart';
import 'package:frontend/providers/seller_category_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/widgets/category_selector.dart';
import 'package:provider/provider.dart';

class BuyerHomeScreen extends StatefulWidget {
  const BuyerHomeScreen({super.key});

  @override
  State<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends State<BuyerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer2<UserProvider, SellerCategoryProvider>(
          builder: (context, userProvider, sellerCategoryProvider, child) {
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Column(
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
                      const SizedBox(height: 10),
                      CategorySelector(),
                      const SizedBox(height: 15),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.2,

                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.2,

                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.2,

                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.2,

                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
