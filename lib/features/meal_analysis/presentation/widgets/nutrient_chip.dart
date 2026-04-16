import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
 
class NutrientChip extends StatelessWidget {
  final String value;
  final String label;
 
  const NutrientChip({super.key, required this.value, required this.label});
 
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        margin: const EdgeInsets.only(right: 6),
        decoration: BoxDecoration(
            color: kLightGrey, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: kDark)),
            Text(label,
                style: const TextStyle(color: kGrey, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}