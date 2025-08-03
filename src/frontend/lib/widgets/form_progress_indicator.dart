import 'package:flutter/material.dart';

class FormProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const FormProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (index) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            height: 4,
            decoration: BoxDecoration(
              color: index < currentStep
                  ? (Theme.of(context).brightness == Brightness.light
                        ? Colors.black54
                        : Colors.white60)
                  : (Theme.of(context).brightness == Brightness.light
                        ? Colors.white60
                        : Colors.black54),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
