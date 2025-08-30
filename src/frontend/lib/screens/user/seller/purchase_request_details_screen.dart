import 'package:flutter/material.dart';
import 'package:frontend/models/tender_model.dart';
import 'package:intl/intl.dart';
import 'package:frontend/models/purchase_request_model.dart';

class PurchaseRequestDetailsScreen extends StatefulWidget {
  final PurchaseRequestModel request;

  const PurchaseRequestDetailsScreen({Key? key, required this.request})
    : super(key: key);

  @override
  State<PurchaseRequestDetailsScreen> createState() =>
      _PurchaseRequestDetailsScreenState();
}

class _PurchaseRequestDetailsScreenState
    extends State<PurchaseRequestDetailsScreen> {
  final TextEditingController _rejectionReasonController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = _getStatusColor(widget.request.status);
    final statusText = widget.request.status != null
        ? statusToString(widget.request.status!)
        : 'Unknown';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          "Purchase Requests Details",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: statusColor.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text(
                    'REQUEST ${statusText.toUpperCase()}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (widget.request.createdAt != null)
                    Text(
                      'Created: ${DateFormat('MMM dd, yyyy - hh:mm a').format(widget.request.createdAt!)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Order Summary
            Text(
              'Order Summary',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildSummaryRow(
                      'Request ID',
                      '#${widget.request.id?.substring(0, 8) ?? 'N/A'}',
                      colorScheme,
                    ),
                    const Divider(),
                    _buildSummaryRow(
                      'Product',
                      widget.request.advertisementName,
                      colorScheme,
                    ),
                    const Divider(),
                    _buildSummaryRow(
                      'Quantity',
                      '${widget.request.quantity} ${_getUnitText(widget.request.unit)}',
                      colorScheme,
                    ),
                    const Divider(),
                    if (widget.request.pricePerUnit != null)
                      _buildSummaryRow(
                        'Price per unit',
                        'LKR ${widget.request.pricePerUnit!.toStringAsFixed(2)}',
                        colorScheme,
                      ),
                    if (widget.request.pricePerUnit != null) const Divider(),
                    if (widget.request.totalPrice != null)
                      _buildSummaryRow(
                        'Total Amount',
                        'LKR ${widget.request.totalPrice!.toStringAsFixed(2)}',
                        colorScheme,
                        isHighlighted: true,
                      ),
                    const Divider(),
                    _buildSummaryRow(
                      'Import Required',
                      widget.request.wantToImportThem == true ? 'Yes' : 'No',
                      colorScheme,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Advertisement Details
            Text(
              'Advertisement Details',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildAdvertisementCard(context, widget.request.advertisement),

            const SizedBox(height: 20),

            // Customer Details
            Text(
              'Customer Details',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildCustomerCard(context, widget.request.buyerId),

            const SizedBox(height: 20),

            // Delivery Information (if available)
            if (widget.request.advertisement is Map &&
                widget.request.advertisement['deliveryAvailable'] == true &&
                widget.request.deliveryLocation != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivery Information',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 20,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Delivery to:',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurface.withOpacity(
                                      0.6,
                                    ),
                                  ),
                                ),
                                Text(
                                  widget.request.deliveryLocation!,
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 20),

            // Rejection Reason (if applicable)
            if (widget.request.rejectionStatus != null)
              Card(
                elevation: 2,
                color: Colors.red.withOpacity(0.05),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.red.withOpacity(0.2)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info, color: Colors.red, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Rejection Reason',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.request.rejectionStatus!,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 10),

            // Action Buttons (for seller and pending requests)
            if (widget.request.status == Status.pending)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _showRejectionDialog(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Reject'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _acceptRequest(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.primary,
                        side: const BorderSide(color: Colors.green),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Accept'),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    ColorScheme colorScheme, {
    bool isHighlighted = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              color: isHighlighted ? colorScheme.primary : null,
              fontSize: isHighlighted ? 16 : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvertisementCard(BuildContext context, dynamic advertisement) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (advertisement is! Map<String, dynamic>) {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Advertisement details not available'),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              advertisement['name'] ?? 'No Name',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (advertisement['description'] != null)
              Text(
                advertisement['description'],
                style: theme.textTheme.bodyMedium,
              ),
            const SizedBox(height: 12),
            if (advertisement['images'] != null &&
                advertisement['images'].isNotEmpty)
              Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(advertisement['images'][0]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  advertisement['location'] ?? 'Location not specified',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.local_shipping,
                  size: 16,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(width: 4),
                Text(
                  advertisement['deliveryAvailable'] == true
                      ? 'Delivery Available'
                      : 'No Delivery',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerCard(BuildContext context, dynamic buyer) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (buyer is! Map<String, dynamic>) {
      return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.person_off,
                  size: 40,
                  color: colorScheme.onSurface.withOpacity(0.3),
                ),
                const SizedBox(height: 12),
                Text(
                  'Customer details not available',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      shadowColor: colorScheme.primary.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with avatar and name
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.primary.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${buyer['firstName']} ${buyer['lastName']}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Buyer',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // Contact Information Section
            Text(
              'CONTACT INFORMATION',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.5),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 12),

            _buildCustomerDetailRow(
              Icons.phone,
              'Phone',
              buyer['phone'] ?? 'Not provided',
              colorScheme,
            ),
            const SizedBox(height: 12),

            _buildCustomerDetailRow(
              Icons.email,
              'Email',
              buyer['email'] ?? 'Not provided',
              colorScheme,
            ),

            const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 16),

            // Location Section
            Text(
              'LOCATION',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.5),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 12),

            _buildCustomerDetailRow(
              Icons.location_on,
              'Address',
              buyer['location'] ?? 'Location not provided',
              colorScheme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerDetailRow(
    IconData icon,
    String label,
    String value,
    ColorScheme colorScheme,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(Status? status) {
    switch (status) {
      case Status.pending:
        return Colors.orange;
      case Status.accepted:
        return Colors.green;
      case Status.rejected:
        return Colors.red;
      case Status.cancelled:
        return Colors.grey;
      case Status.paid:
        return Colors.purple;
      case null:
        return Colors.grey;
    }
  }

  String _getUnitText(Units? unit) {
    if (unit == null) return 'units';
    return unitsToString(unit);
  }

  void _showActionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel Request'),
                onTap: () {
                  Navigator.pop(context);
                  _cancelRequest(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRejectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Reject Request'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Please provide a reason for rejection:'),
              const SizedBox(height: 16),
              TextField(
                controller: _rejectionReasonController,
                decoration: const InputDecoration(
                  hintText: 'Enter rejection reason',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_rejectionReasonController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please provide a rejection reason'),
                    ),
                  );
                  return;
                }
                Navigator.pop(context);
                _rejectRequest(context, _rejectionReasonController.text);
              },
              child: const Text('Reject'),
            ),
          ],
        );
      },
    );
  }

  void _acceptRequest(BuildContext context) {
    // Implement accept request logic
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Accept Request'),
          content: const Text(
            'Are you sure you want to accept this purchase request?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Process acceptance
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Request accepted successfully'),
                  ),
                );
              },
              child: const Text('Accept'),
            ),
          ],
        );
      },
    );
  }

  void _rejectRequest(BuildContext context, String reason) {
    // Implement reject request logic with reason
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Request rejected. Reason: $reason')),
    );
  }

  void _cancelRequest(BuildContext context) {
    // Implement cancel request logic
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cancel Request'),
          content: const Text(
            'Are you sure you want to cancel this purchase request?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Process cancellation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Request cancelled successfully'),
                  ),
                );
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _rejectionReasonController.dispose();
    super.dispose();
  }
}
