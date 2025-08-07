import 'package:flutter/material.dart';
import 'package:frontend/providers/advertisement_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/screens/user/advertisement_details_screen.dart';
import 'package:frontend/widgets/custom_advertisement_card.dart';
import 'package:provider/provider.dart';

class SellerHomeScreen extends StatelessWidget {
  const SellerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<UserProvider>(
          builder: (context, userProvider, child) {
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

                      // Popular Categories title
                      Text(
                        "My Advertisements",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  Consumer<AdvertisementProvider>(
                    builder: (context, advertisementProvider, child) {
                      if (advertisementProvider.isLoading) {
                        return const Expanded(
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (advertisementProvider.error != null) {
                        return Expanded(
                          child: Center(
                            child: Text(
                              'Error: ${advertisementProvider.error}',
                            ),
                          ),
                        );
                      }
                      return Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount:
                              advertisementProvider.advertisements.length,
                          itemBuilder: (context, index) {
                            final ad =
                                advertisementProvider.advertisements[index];
                            return AdvertisementCard(
                              ad: ad,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AdvertisementDetailsScreen(ad: ad),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
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
