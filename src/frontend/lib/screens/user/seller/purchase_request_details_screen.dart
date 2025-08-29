import 'package:flutter/material.dart';
import 'package:frontend/models/purchase_request_model.dart';
import 'package:frontend/models/tender_model.dart';
import 'package:intl/intl.dart';

class PurchaseRequestDetailsScreen extends StatelessWidget {
  final PurchaseRequestModel request;
  const PurchaseRequestDetailsScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = _getStatusColor(request.status);
    final statusText = request.status != null
        ? statusToString(request.status!)
        : 'Unknown';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Request Details'),
        actions: [
          if (request.status == Status.pending)
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                _showActionMenu(context);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Request #${request.id?.substring(0, 8) ?? 'N/A'}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: statusColor.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            statusText.toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: statusColor,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getAdvertisementTitle(request.advertisement),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (request.createdAt != null)
                      Text(
                        'Created: ${DateFormat('MMM dd, yyyy - hh:mm a').format(request.createdAt!)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Order Details Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Details',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      icon: Icons.scale,
                      label: 'Quantity',
                      value:
                          '${request.quantity} ${_getUnitText(request.unit)}',
                      colorScheme: colorScheme,
                    ),
                    const SizedBox(height: 12),
                    if (request.pricePerUnit != null)
                      _buildDetailRow(
                        icon: Icons.attach_money,
                        label: 'Price per unit',
                        value: '\$${request.pricePerUnit!.toStringAsFixed(2)}',
                        colorScheme: colorScheme,
                      ),
                    const SizedBox(height: 12),
                    if (request.totalPrice != null)
                      _buildDetailRow(
                        icon: Icons.payments,
                        label: 'Total price',
                        value: '\$${request.totalPrice!.toStringAsFixed(2)}',
                        colorScheme: colorScheme,
                        isHighlighted: true,
                      ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      icon: Icons.inventory,
                      label: 'Import required',
                      value: request.wantToImportThem == true ? 'Yes' : 'No',
                      colorScheme: colorScheme,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Delivery Information Card
            if (request.deliveryLocation != null)
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivery Information',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 20,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              request.deliveryLocation!,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Rejection Reason (if applicable)
            if (request.rejectionStatus != null)
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
                        request.rejectionStatus!,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // Action Buttons (for pending requests)
            if (request.status == Status.pending)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _handleAction(context, 'reject');
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
                        _handleAction(context, 'accept');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Accept'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required ColorScheme colorScheme,
    bool isHighlighted = false,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7)),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
              color: isHighlighted ? colorScheme.primary : null,
              fontSize: isHighlighted ? 16 : null,
            ),
            textAlign: TextAlign.right,
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

  String _getAdvertisementTitle(dynamic advertisement) {
    if (advertisement == null) return 'Unknown Product';
    if (advertisement is Map) return advertisement['title'] ?? 'Product';
    if (advertisement is String) return advertisement;
    return 'Product';
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
                  _handleAction(context, 'cancel');
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit Request'),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to edit screen
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleAction(BuildContext context, String action) {
    // Handle different actions here
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '${action[0].toUpperCase()}${action.substring(1)} Request',
          ),
          content: Text('Are you sure you want to $action this request?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Process the action
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Request $action successfully')),
                );
              },
              child: Text(action[0].toUpperCase() + action.substring(1)),
            ),
          ],
        );
      },
    );
  }
}
