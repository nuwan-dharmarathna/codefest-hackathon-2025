import 'package:flutter/material.dart';

class CustomCategoryCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final String? imageUrl;
  final VoidCallback? onTap;

  const CustomCategoryCard({
    super.key,
    required this.isSelected,
    required this.title,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: _buildImageCard(theme),
      ),
    );
  }

  Widget _buildImageCard(ThemeData theme) {
    return SizedBox(
      width: 100,
      height: 90, // Total fixed height for image card
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image container
          SizedBox(height: 5),
          Container(
            width: 74,
            height: 74,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: isSelected
                  ? theme.colorScheme.primary.withOpacity(0.2)
                  : theme.brightness == Brightness.light
                  ? Colors.white60
                  : Colors.white54.withOpacity(0.2),
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.3),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(imageUrl!, fit: BoxFit.contain),
              ),
            ),
          ),
          // Title text
          SizedBox(
            height: 35, // Fixed height for text area
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
