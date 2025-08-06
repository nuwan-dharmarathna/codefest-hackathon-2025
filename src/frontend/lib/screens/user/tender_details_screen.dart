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
        title: Text(tender.title),
        actions: [
          if (tender.isClosed)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'CLOSED',
                style: TextStyle(
                  color: Colors.red.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, 'Basic Information'),
            _buildInfoRow(
              context,
              'Type',
              tender.role == UserRole.buyer
                  ? 'Buying Request'
                  : 'Selling Offer',
            ),
            _buildInfoRow(context, 'Title', tender.title),
            _buildInfoRow(context, 'Description', tender.description),

            const SizedBox(height: 24),
            _buildSectionHeader(context, 'Product Details'),
            _buildInfoRow(context, 'Category', tender.category),
            if (tender.subCategory != null)
              _buildInfoRow(
                context,
                'Subcategory',
                tender.subCategory ?? 'N/A',
              ),
            _buildInfoRow(
              context,
              'Quantity',
              '${tender.quantity} ${unitsToString(tender.unit)}',
            ),

            if (tender.deliveryRequired) ...[
              const SizedBox(height: 24),
              _buildSectionHeader(context, 'Delivery Information'),
              _buildInfoRow(context, 'Delivery Required', 'Yes'),
              if (tender.deliveryLocation != null)
                _buildInfoRow(
                  context,
                  'Delivery Location',
                  tender.deliveryLocation!,
                ),
            ],

            const SizedBox(height: 24),
            _buildSectionHeader(context, 'Timing'),
            _buildInfoRow(
              context,
              'Posted On',
              DateFormat('MMMM dd, yyyy - hh:mm a').format(tender.createdAt),
            ),
            if (tender.updatedAt != null)
              _buildInfoRow(
                context,
                'Last Updated',
                DateFormat('MMMM dd, yyyy - hh:mm a').format(tender.updatedAt!),
              ),

            if (tender.acceptedBid != null) ...[
              const SizedBox(height: 24),
              _buildSectionHeader(context, 'Accepted Bid'),
              // You can add bid details here if needed
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade100),
                ),
                child: const Text(
                  'This tender has an accepted bid',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],

            const SizedBox(height: 32),
            if (!tender.isClosed)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle bid/offer action
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    tender.role == UserRole.buyer
                        ? 'Make an Offer'
                        : 'Place a Bid',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
