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
    final colorScheme = theme.colorScheme;
    final isBuyer = tender.role == UserRole.buyer;
    final categoryName = _getCategoryName(tender.categoryName);
    final subCategoryName = _getSubCategoryName(tender.subCategoryName);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: colorScheme.onSurface.withOpacity(0.07),
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
              // Title
              Text(
                tender.title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Category and subcategory
              if (categoryName != null || subCategoryName != null)
                Wrap(
                  spacing: 8,
                  children: [
                    if (categoryName != null)
                      _buildCategoryChip(categoryName, colorScheme, theme),
                    if (subCategoryName != null)
                      _buildCategoryChip(subCategoryName, colorScheme, theme),
                  ],
                ),

              const SizedBox(height: 12),

              // Description
              Text(
                tender.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.8),
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 16),

              // Details section
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Quantity
                    _buildDetailItem(
                      icon: Icons.scale,
                      label: 'Quantity',
                      value: '${tender.quantity} ${unitsToString(tender.unit)}',
                      theme: theme,
                      colorScheme: colorScheme,
                    ),

                    // Vertical divider
                    Container(
                      width: 1,
                      height: 40,
                      color: colorScheme.outline.withOpacity(0.2),
                    ),

                    // Date
                    _buildDetailItem(
                      icon: Icons.calendar_today,
                      label: 'Posted',
                      value: DateFormat('MMM dd').format(tender.createdAt!),
                      theme: theme,
                      colorScheme: colorScheme,
                    ),

                    // Vertical divider
                    Container(
                      width: 1,
                      height: 40,
                      color: colorScheme.outline.withOpacity(0.2),
                    ),

                    // Type
                    _buildDetailItem(
                      icon: isBuyer ? Icons.shopping_cart : Icons.store,
                      label: 'Type',
                      value: isBuyer ? 'Buyer Tender' : 'Seller Tender',
                      theme: theme,
                      colorScheme: colorScheme,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(
    String text,
    ColorScheme colorScheme,
    ThemeData theme,
  ) {
    return Chip(
      label: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.primary),
      ),
      backgroundColor: colorScheme.primary.withOpacity(0.1),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: EdgeInsets.zero,
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
    required ColorScheme colorScheme,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 20, color: colorScheme.primary),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
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
