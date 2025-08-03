import 'package:flutter/material.dart';

class CustomSubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final String lableText;
  const CustomSubmitButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.lableText,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.onSurface.withOpacity(0.1),
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(lableText, style: TextStyle(fontSize: 18)),
            ),
    );
  }
}
