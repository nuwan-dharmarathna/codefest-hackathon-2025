import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;
  final EdgeInsetsGeometry padding;
  final TextStyle? textStyle;
  final bool isFullWidth;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;

  const CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.backgroundColor = Colors.blue,
    this.textColor,
    this.width,
    this.height = 48.0,
    this.borderRadius = 8.0,
    this.borderColor = Colors.transparent,
    this.borderWidth = 1.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.textStyle,
    this.isFullWidth = false,
    this.boxShadow,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultTextStyle = theme.textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w600,
      color: textColor ?? theme.colorScheme.onPrimary,
    );

    return Padding(
      padding: padding,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Ink(
            width: isFullWidth ? double.infinity : width,
            height: height,
            decoration: BoxDecoration(
              color: gradient != null ? null : backgroundColor,
              gradient: gradient,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: onPressed == null ? theme.disabledColor : borderColor,
                width: borderWidth,
              ),
              boxShadow: boxShadow,
            ),
            child: Center(
              child: Text(
                title,
                style: textStyle ?? defaultTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
