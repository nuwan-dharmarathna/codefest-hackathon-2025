// widgets/tender_card.dart
import 'package:flutter/material.dart';
import 'package:frontend/models/tender_model.dart';
import 'package:intl/intl.dart';

class TenderCard extends StatelessWidget {
  final TenderModel tender;
  final VoidCallback? onTap;
  final bool showFullDetails;

  const TenderCard({
    super.key,
    required this.tender,
    this.onTap,
    this.showFullDetails = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM dd, yyyy - hh:mm a');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Status row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      tender.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusIndicator(context),
                ],
              ),

              const SizedBox(height: 8),

              // Description
              if (showFullDetails) ...[
                Text(tender.description, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 12),
              ],

              // Category and Subcategory
              _buildCategoryInfo(context),

              const SizedBox(height: 12),

              // Quantity and Unit
              Row(
                children: [
                  _buildInfoChip(
                    context,
                    icon: Icons.scale,
                    label: '${tender.quantity} ${tender.unit}',
                  ),
                  if (tender.deliveryRequired) ...[
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      context,
                      icon: Icons.local_shipping,
                      label: 'Delivery',
                      color: Colors.blue,
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 12),

              // Footer with creator and date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Posted ${dateFormat.format(tender.createdAt)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  if (tender.isClosed)
                    Text(
                      'Closed',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: tender.isClosed ? Colors.red[100] : Colors.green[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        tender.isClosed ? 'Closed' : 'Active',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: tender.isClosed ? Colors.red[800] : Colors.green[800],
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCategoryInfo(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        if (tender.category.isNotEmpty)
          _buildInfoChip(context, icon: Icons.category, label: tender.category),
        if (tender.subCategory?.isNotEmpty ?? false)
          _buildInfoChip(
            context,
            icon: Icons.subdirectory_arrow_right,
            label: tender.subCategory!,
            color: Colors.orange,
          ),
      ],
    );
  }

  Widget _buildInfoChip(
    BuildContext context, {
    required IconData icon,
    required String label,
    Color? color,
  }) {
    return Chip(
      backgroundColor: color?.withOpacity(0.1) ?? Colors.grey[200],
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      avatar: Icon(icon, size: 16, color: color ?? Colors.grey[700]),
      label: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: color ?? Colors.grey[700]),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}
