import 'package:flutter/material.dart';

class CustomCategoryCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final String imageUrl;
  final VoidCallback? onTap;

  const CustomCategoryCard({
    super.key,
    required this.isSelected,
    required this.title,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.22, // Slightly wider
          child: Column(
            mainAxisSize: MainAxisSize.min, // Add this to prevent overflow
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.18,
                height: MediaQuery.of(context).size.width * 0.18,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                      : Theme.of(context).brightness == Brightness.light
                      ? Colors.white60
                      : Colors.white54.withOpacity(0.2),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(imageUrl, fit: BoxFit.contain),
                  ),
                ),
              ),
              const SizedBox(height: 6), // Reduced from 10
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                ), // Add horizontal padding
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontSize: 12, // Slightly smaller font
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
