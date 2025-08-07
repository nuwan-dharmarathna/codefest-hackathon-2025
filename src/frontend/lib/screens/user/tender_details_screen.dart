import 'package:flutter/material.dart';
import 'package:frontend/models/tender_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:intl/intl.dart';

class TenderDetailsScreen extends StatelessWidget {
  final TenderModel tender;

  const TenderDetailsScreen({Key? key, required this.tender}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tender.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        elevation: 0,
        actions: [
          if (tender.isClosed!)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.red.shade100, width: 1),
              ),
              child: Text(
                'CLOSED',
                style: TextStyle(
                  color: Colors.red.shade800,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTypeIndicator(context),
                  const SizedBox(height: 24),
                  _buildSection(
                    context,
                    title: 'Description',
                    child: Text(
                      tender.description,
                      style: Theme.of(context).textTheme.bodyLarge,
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
                  if (tender.acceptedBid != null) ...[
                    const SizedBox(height: 24),
                    _buildAcceptedBidSection(context),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          if (!tender.isClosed!) _buildActionButton(context),
        ],
      ),
    );
  }

  Widget _buildTypeIndicator(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: tender.role == UserRole.buyer
            ? Colors.blue.shade50
            : Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: tender.role == UserRole.buyer
              ? Colors.blue.shade100
              : Colors.green.shade100,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            tender.role == UserRole.buyer ? Icons.shopping_cart : Icons.store,
            size: 16,
            color: tender.role == UserRole.buyer
                ? Colors.blue.shade800
                : Colors.green.shade800,
          ),
          const SizedBox(width: 8),
          Text(
            tender.role == UserRole.buyer ? 'Buying Request' : 'Selling Offer',
            style: TextStyle(
              color: tender.role == UserRole.buyer
                  ? Colors.blue.shade800
                  : Colors.green.shade800,
              fontWeight: FontWeight.bold,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[800],
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildProductDetailsSection(BuildContext context) {
    return _buildSection(
      context,
      title: 'Product Details',
      child: Column(
        children: [
          _buildDetailRow(
            context,
            label: 'Category',
            value: tender.category,
            icon: Icons.category,
          ),
          if (tender.subCategory != null)
            _buildDetailRow(
              context,
              label: 'Subcategory',
              value: tender.subCategory!,
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
    );
  }

  Widget _buildDeliverySection(BuildContext context) {
    return _buildSection(
      context,
      title: 'Delivery Information',
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
    );
  }

  Widget _buildTimingSection(BuildContext context) {
    return _buildSection(
      context,
      title: 'Timing',
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
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blueGrey[400]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(value, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcceptedBidSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade100, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green.shade800, size: 20),
              const SizedBox(width: 8),
              Text(
                'Accepted Bid',
                style: TextStyle(
                  color: Colors.green.shade800,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'This tender has an accepted bid and is no longer accepting offers.',
            style: TextStyle(color: Colors.green.shade800),
          ),
          // You can add more bid details here if available
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
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
            backgroundColor: tender.role == UserRole.buyer
                ? Colors.blue.shade600
                : Colors.green.shade600,
          ),
          child: Text(
            tender.role == UserRole.buyer ? 'Make an Offer' : 'Place a Bid',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
