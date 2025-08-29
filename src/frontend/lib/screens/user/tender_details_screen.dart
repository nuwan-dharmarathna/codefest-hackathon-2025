import 'package:flutter/material.dart';
import 'package:frontend/models/tender_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TenderDetailsScreen extends StatelessWidget {
  final TenderModel tender;
  final UserRole currentUserRole;

  const TenderDetailsScreen({
    Key? key,
    required this.tender,
    required this.currentUserRole,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isClosed = tender.isClosed ?? false;
    final hasAcceptedBid = tender.acceptedBid != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tender.title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        actions: [
          if (isClosed)
            Container(
              margin: const EdgeInsets.only(right: 16, top: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: colorScheme.error.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                'CLOSED',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTypeIndicator(context),
                  const SizedBox(height: 24),
                  _buildSection(
                    context,
                    title: 'Description',
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        tender.description,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildProductDetailsSection(context),
                  if (tender.deliveryRequired) ...[
                    const SizedBox(height: 24),
                    _buildDeliverySection(context),
                  ],
                  const SizedBox(height: 24),
                  _buildTimingSection(context),
                  if (hasAcceptedBid) ...[
                    const SizedBox(height: 24),
                    _buildAcceptedBidSection(context),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          if (!isClosed) _buildActionButton(context),
        ],
      ),
    );
  }

  Widget _buildTypeIndicator(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isBuyer = tender.role == UserRole.buyer;

    final primaryColor = isBuyer ? colorScheme.primary : colorScheme.secondary;
    final containerColor = primaryColor.withOpacity(0.1);
    final borderColor = primaryColor.withOpacity(0.3);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isBuyer ? Icons.shopping_cart : Icons.store,
            size: 20,
            color: primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isBuyer ? 'Buyer Tender' : 'Seller Tender',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildProductDetailsSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return _buildSection(
      context,
      title: 'Product Details',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            _buildDetailRow(
              context,
              label: 'Category',
              value: tender.categoryName,
              icon: Icons.category,
            ),
            if (tender.subCategory.isNotEmpty)
              _buildDetailRow(
                context,
                label: 'Subcategory',
                value: tender.subCategoryName,
                icon: Icons.category_outlined,
              ),
            _buildDetailRow(
              context,
              label: 'Quantity',
              value: '${tender.quantity} ${unitsToString(tender.unit)}',
              icon: Icons.scale,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliverySection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return _buildSection(
      context,
      title: 'Delivery Information',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            _buildDetailRow(
              context,
              label: 'Delivery Required',
              value: 'Yes',
              icon: Icons.local_shipping,
            ),
            if (tender.deliveryLocation != null)
              _buildDetailRow(
                context,
                label: 'Location',
                value: tender.deliveryLocation!,
                icon: Icons.location_on,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimingSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return _buildSection(
      context,
      title: 'Timing',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            _buildDetailRow(
              context,
              label: 'Posted On',
              value: DateFormat(
                'MMMM dd, yyyy - hh:mm a',
              ).format(tender.createdAt!),
              icon: Icons.calendar_today,
            ),
            if (tender.updatedAt != null)
              _buildDetailRow(
                context,
                label: 'Last Updated',
                value: DateFormat(
                  'MMMM dd, yyyy - hh:mm a',
                ).format(tender.updatedAt!),
                icon: Icons.update,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(value, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcceptedBidSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Accepted Bid',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'This tender has an accepted bid and is no longer accepting offers.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isBuyer = tender.role == UserRole.buyer;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // Handle bid/offer action
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: isBuyer
                ? colorScheme.primary
                : colorScheme.secondary,
          ),
          child: Text(
            userProvider.user!.id == tender.createdBy
                ? 'See Seller Bids'
                : currentUserRole == UserRole.buyer
                ? 'See Seller Bids'
                : 'Place a Bid',
            style: theme.textTheme.labelLarge?.copyWith(
              color: isBuyer ? colorScheme.onPrimary : colorScheme.onSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
