import 'package:flutter/material.dart';

class CustomCategoryCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  const CustomCategoryCard({
    super.key,
    required this.isSelected,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.15,
          height: MediaQuery.of(context).size.width * 0.15,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.white60
                : Colors.white54.withOpacity(0.2),
            border: Border.all(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurface,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(50),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset(
                "assets/icons/farmer.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          title,
          style: isSelected == true
              ? TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                )
              : TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 14,
                ),
        ),
      ],
    );
  }
}
