import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:frontend/models/advertisement_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/screens/user/buyer/order_placement_dialog.dart';
import 'package:frontend/widgets/custom_alert_box.dart';
import 'package:frontend/widgets/custom_submit_button.dart';
import 'package:provider/provider.dart';

class AdvertisementDetailsScreen extends StatelessWidget {
  final AdvertisementModel ad;

  const AdvertisementDetailsScreen({Key? key, required this.ad})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lowestPrice = ad.priceTiers.isNotEmpty
        ? ad.priceTiers.reduce((a, b) => a.price < b.price ? a : b).price
        : 0;

    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: _buildImageGallery(context),
                  title: Text(
                    ad.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.8),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  centerTitle: true,
                ),
                actions: [
                  if (userProvider.user!.role == UserRole.seller)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.white),
                      onPressed: () => _shareAdvertisement(context),
                    ),
                  IconButton(
                    icon: const Icon(Icons.share, color: Colors.white),
                    onPressed: () => _shareAdvertisement(context),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Price and rating row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'From LKR. ${lowestPrice.toStringAsFixed(2)}/${ad.unit.name}',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          RatingStars(
                            value: 4.5,
                            starCount: 5,
                            starSize: 20,
                            valueLabelVisibility: false,
                            starColor: Colors.amber,
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Location and delivery info
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 20,
                            color: theme.primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              ad.location!,
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                          if (ad.deliveryAvailable) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.delivery_dining,
                                    size: 16,
                                    color: theme.primaryColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Delivery',
                                    style: TextStyle(
                                      color: theme.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (ad.deliveryRadius != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Text(
                                  '(${ad.deliveryRadius!.toStringAsFixed(1)} km)',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Description section
                      Text(
                        'Product Details',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          ad.description,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Pricing tiers
                      Text(
                        'Pricing Tiers',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (ad.priceTiers.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'No pricing information available',
                            style: theme.textTheme.bodyLarge,
                          ),
                        )
                      else
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              ...ad.priceTiers.map(
                                (tier) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: _buildPriceTierItem(tier),
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 24),

                      // Quantity available
                      Text(
                        'Available Stock',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              color: theme.primaryColor,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${ad.quantity} ${ad.unit.name} available',
                              style: theme.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.13,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildActionButtons(context),
    );
  }

  Widget _buildImageGallery(BuildContext context) {
    if (ad.images!.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: const Center(
          child: Icon(Icons.photo, size: 50, color: Colors.grey),
        ),
      );
    }

    return Stack(
      children: [
        // Horizontal scrollable images
        PageView.builder(
          itemCount: ad.images!.length,
          itemBuilder: (context, index) {
            return CachedNetworkImage(
              imageUrl: ad.images![index],
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey[200]),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            );
          },
        ),

        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
            ),
          ),
        ),

        // Image count indicator
        if (ad.images!.length > 1)
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${ad.images!.length} photos',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPriceTierItem(PriceTier tier) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${tier.minQuantity} - ${tier.maxQuantity} ${ad.unit.name}',
                style: const TextStyle(fontSize: 16),
              ),
              if (tier.maxQuantity != double.infinity)
                Text(
                  'Save ${(100 - (tier.price / ad.priceTiers[0].price * 100)).toStringAsFixed(0)}%',
                  style: TextStyle(fontSize: 12, color: Colors.green.shade700),
                ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'LKR. ${tier.price.toStringAsFixed(2)}/${ad.unit.name}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final isSeller = context.read<UserProvider>().user?.role == UserRole.seller;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          if (!isSeller) ...[
            Expanded(
              flex: 2,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextButton.icon(
                  icon: const Icon(Icons.chat_outlined),
                  label: const Text('Chat'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => CustomAlertBox(
                        title: 'Warning',
                        message:
                            "Coming soon!\n Chat feature is still in development.",
                        icon: Icons.warning_amber_rounded,
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            flex: 3,
            child: CustomSubmitButton(
              onPressed: () =>
                  isSeller ? _seeOrders(context) : _placeOrder(context, ad),
              lableText: isSeller ? "Manage Orders" : "Place Order",
              isLoading: false,
            ),
          ),
        ],
      ),
    );
  }

  void _shareAdvertisement(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomAlertBox(
        title: 'Warning',
        message: "Coming soon!\n Share feature is still in development.",
        icon: Icons.warning_amber_rounded,
      ),
    );
  }

  void _seeOrders(BuildContext context) {
    // todo
  }

  void _placeOrder(BuildContext context, AdvertisementModel ad) {
    showDialog(
      context: context,
      builder: (context) => OrderPlacementDialog(
        ad: ad,
        onPlaceOrder: (quantity, wantDelivery) async {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Order placed for $quantity ${ad.unit.name}'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        },
      ),
    );
  }
}
