import 'package:flutter/material.dart';

class CustomUserMenuListTile extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final IconData leadingIcon;
  final Color? iconColor;

  const CustomUserMenuListTile({
    super.key,
    required this.title,
    required this.leadingIcon,
    required this.onPressed,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.grey.shade800.withOpacity(0.4)
                : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.dividerColor.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  leadingIcon,
                  size: 24,
                  color: iconColor ?? theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 28,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
