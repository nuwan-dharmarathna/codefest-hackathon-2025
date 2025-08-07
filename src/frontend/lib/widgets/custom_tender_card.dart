import 'package:flutter/material.dart';
import 'package:frontend/models/tender_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:intl/intl.dart';

class CustomTenderCard extends StatelessWidget {
  final TenderModel tender;
  final VoidCallback onTap;

  const CustomTenderCard({Key? key, required this.tender, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isBuyer = tender.role == UserRole.buyer;
    final categoryName = _getCategoryName(tender.category);
    final subCategoryName = _getSubCategoryName(tender.subCategory);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              // Header with title and status
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tender.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (categoryName != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            categoryName,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (tender.isClosed!) _buildStatusBadge('CLOSED', Colors.red),
                ],
              ),

              const SizedBox(height: 12),

              // Description
              Text(
                tender.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade800,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 16),

              // Details row
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  // Quantity
                  _buildDetailChip(
                    icon: Icons.scale,
                    label: '${tender.quantity} ${unitsToString(tender.unit)}',
                  ),

                  // Subcategory
                  if (subCategoryName != null)
                    _buildDetailChip(
                      icon: Icons.category,
                      label: subCategoryName,
                    ),

                  // Time
                  _buildDetailChip(
                    icon: Icons.access_time,
                    label: DateFormat('MMM dd').format(tender.createdAt!),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Footer with type and action button
              Row(
                children: [
                  // Type indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isBuyer
                          ? Colors.blue.shade50
                          : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isBuyer
                            ? Colors.blue.shade100
                            : Colors.orange.shade100,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isBuyer ? Icons.shopping_cart : Icons.store,
                          size: 16,
                          color: isBuyer
                              ? Colors.blue.shade800
                              : Colors.orange.shade800,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isBuyer ? 'Buying' : 'Selling',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isBuyer
                                ? Colors.blue.shade800
                                : Colors.orange.shade800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Action button
                  OutlinedButton(
                    onPressed: onTap,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: BorderSide(color: theme.primaryColor),
                    ),
                    child: Text(
                      isBuyer ? 'Make Offer' : 'Place Bid',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.primaryColor,
                      ),
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

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDetailChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
          ),
        ],
      ),
    );
  }

  String? _getCategoryName(dynamic category) {
    if (category == null) return null;
    if (category is Map) return category['name'] ?? category['nameOnBuyerSide'];
    if (category is String) return category;
    return null;
  }

  String? _getSubCategoryName(dynamic subCategory) {
    if (subCategory == null) return null;
    if (subCategory is Map) return subCategory['name'];
    if (subCategory is String) return subCategory;
    return null;
  }
}
