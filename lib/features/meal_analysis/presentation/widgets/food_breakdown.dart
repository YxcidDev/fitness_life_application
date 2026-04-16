import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/food_item.dart';
import 'nutrient_chip.dart';
 
class FoodBreakdown extends StatelessWidget {
  final FoodItem item;
 
  const FoodBreakdown({super.key, required this.item});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(item.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: kDark)),
              ),
              Text('${item.grams.toStringAsFixed(0)}g',
                  style: const TextStyle(color: kOrange, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              NutrientChip(value: item.calories.toStringAsFixed(0), label: 'kcal'),
              NutrientChip(value: '${item.proteins.toStringAsFixed(1)}g', label: 'Prot'),
              NutrientChip(value: '${item.carbs.toStringAsFixed(1)}g',    label: 'Carbs'),
              NutrientChip(value: '${item.fats.toStringAsFixed(1)}g',     label: 'Grasas'),
            ],
          ),
        ],
      ),
    );
  }
}