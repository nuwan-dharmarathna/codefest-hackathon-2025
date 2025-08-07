import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/models/advertisement_model.dart';

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
      appBar: AppBar(
        title: Text(ad.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareAdvertisement(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Gallery
            _buildImageGallery(context),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          ad.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        'From \$${lowestPrice.toStringAsFixed(2)}/${ad.unit.name}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Location and Delivery
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: theme.hintColor,
                      ),
                      const SizedBox(width: 4),
                      Text(ad.location!),
                      const Spacer(),
                      if (ad.deliveryAvailable)
                        Row(
                          children: [
                            Icon(
                              Icons.delivery_dining,
                              size: 16,
                              color: theme.primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Delivery Available',
                              style: TextStyle(color: theme.primaryColor),
                            ),
                            if (ad.deliveryRadius != null) ...[
                              const SizedBox(width: 4),
                              Text(
                                '(${ad.deliveryRadius!.toStringAsFixed(1)} km radius)',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ],
                        ),
                    ],
                  ),

                  const Divider(height: 32),

                  // Description
                  Text(
                    'Description',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(ad.description, style: theme.textTheme.bodyMedium),

                  const Divider(height: 32),

                  // Pricing Tiers
                  Text(
                    'Pricing',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (ad.priceTiers.isEmpty)
                    Text(
                      'No pricing information available',
                      style: theme.textTheme.bodySmall,
                    )
                  else
                    Column(
                      children: ad.priceTiers
                          .map((tier) => _buildPriceTierItem(tier))
                          .toList(),
                    ),

                  const Divider(height: 32),

                  // Quantity Available
                  Text(
                    'Available Quantity',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${ad.quantity} ${ad.unit.name}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildActionButtons(context),
    );
  }

  Widget _buildImageGallery(BuildContext context) {
    if (ad.images!.isEmpty) {
      return Container(
        height: 150,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: const Center(
          child: Icon(Icons.photo, size: 50, color: Colors.grey),
        ),
      );
    }

    return SizedBox(
      height: 150,
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: Stack(
          children: [
            // Horizontal scrollable images
            PageView.builder(
              itemCount: ad.images!.length,
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: ad.images![index],
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(color: Colors.grey[200]),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                );
              },
            ),

            // Image count indicator
            if (ad.images!.length > 1)
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${ad.images!.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),

            // Page indicator dots
            if (ad.images!.length > 1)
              Positioned(
                left: 0,
                right: 0,
                bottom: 8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(ad.images!.length, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceTierItem(PriceTier tier) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${tier.minQuantity} - ${tier.maxQuantity} ${ad.unit.name}',
            ),
          ),
          Text(
            '\$${tier.price.toStringAsFixed(2)}/${ad.unit.name}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => _contactSeller(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
              child: const Text('Contact Seller'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _placeOrder(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Place Order'),
            ),
          ),
        ],
      ),
    );
  }

  void _shareAdvertisement(BuildContext context) {
    // Implement share functionality
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Sharing advertisement...')));
  }

  void _contactSeller(BuildContext context) {
    // Implement contact seller functionality
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Contacting seller...')));
  }

  void _placeOrder(BuildContext context) {
    // Implement place order functionality
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Placing order...')));
  }
}
