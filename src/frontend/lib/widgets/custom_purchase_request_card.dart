import 'package:flutter/material.dart';
import 'package:frontend/models/purchase_request_model.dart';
import 'package:frontend/models/tender_model.dart';
import 'package:intl/intl.dart';

class CustomPurchaseRequestCard extends StatelessWidget {
  final PurchaseRequestModel request;
  final VoidCallback onTap;

  const CustomPurchaseRequestCard({
    super.key,
    required this.request,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Get status color
    final statusColor = _getStatusColor(request.status);
    final statusText = request.status != null
        ? statusToString(request.status!).toUpperCase()
        : 'UNKNOWN';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outline.withOpacity(0.2), width: 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Request ID if available
                  if (request.id != null)
                    Text(
                      'Request #${request.id != null ? request.id!.substring(0, 8) : '--------'}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),

                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor.withOpacity(0.3)),
                    ),
                    child: Text(
                      statusText,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Product/Advertisement info
              if (request.advertisement != null)
                Text(
                  _getAdvertisementTitle(request.advertisement),
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

              const SizedBox(height: 8),

              // Quantity and price info
              Row(
                children: [
                  // Quantity
                  _buildInfoChip(
                    icon: Icons.scale,
                    label: '${request.quantity} ${_getUnitText(request.unit)}',
                    colorScheme: colorScheme,
                  ),

                  const SizedBox(width: 8),

                  // Price per unit if available
                  if (request.pricePerUnit != null)
                    _buildInfoChip(
                      icon: Icons.attach_money,
                      label:
                          'LKR ${request.pricePerUnit!.toStringAsFixed(2)}/unit',
                      colorScheme: colorScheme,
                    ),
                ],
              ),

              const SizedBox(height: 12),

              // Price and date section
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Total price
                    if (request.totalPrice != null)
                      Text(
                        'Total: LKR ${request.totalPrice!.toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      )
                    else
                      const Text('Price not available'),

                    // Date
                    if (request.createdAt != null)
                      Text(
                        DateFormat('MMM dd, yyyy').format(request.createdAt!),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                  ],
                ),
              ),

              // Additional info if available
              if (request.deliveryLocation != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        request.deliveryLocation!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],

              if (request.rejectionStatus != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Reason: ${request.rejectionStatus!}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.red,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required ColorScheme colorScheme,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colorScheme.primary),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
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
    if (advertisement is Map) return advertisement['name'] ?? 'Product';
    if (advertisement is String) return advertisement;
    return 'Product';
  }

  String _getUnitText(Units? unit) {
    if (unit == null) return 'units';
    return unitsToString(unit);
  }
}
