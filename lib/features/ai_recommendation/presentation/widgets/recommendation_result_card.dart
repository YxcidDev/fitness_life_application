import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/meal_recommendation.dart';

class RecommendationResultCard extends StatelessWidget {
  final MealRecommendation recommendation;
  final VoidCallback onConsume;
  final VoidCallback onRegenerate;

  const RecommendationResultCard({
    super.key,
    required this.recommendation,
    required this.onConsume,
    required this.onRegenerate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kOrangeBg, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: kOrangeBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _mealTypeLabel(recommendation.mealType).toUpperCase(),
                  style: const TextStyle(
                      color: kOrange,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5),
                ),
              ),
              const SizedBox(height: 10),

              Text(
                recommendation.mealName,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: kDark),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                      child: _macroItem(
                          '${recommendation.calories.toStringAsFixed(0)}',
                          'kcal')),
                  Expanded(
                      child: _macroItem(
                          '${recommendation.protein.toStringAsFixed(0)}g',
                          'Proteína')),
                  Expanded(
                      child: _macroItem(
                          '${recommendation.carbs.toStringAsFixed(0)}g',
                          'Carbs')),
                  Expanded(
                      child: _macroItem(
                          '${recommendation.fat.toStringAsFixed(0)}g',
                          'Grasas')),
                ],
              ),
              const SizedBox(height: 16),

              const Text(
                'Ingredientes',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: kDark),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: recommendation.ingredients
                    .map((ing) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: kLightGrey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(ing,
                              style: const TextStyle(
                                  fontSize: 12, color: kDark)),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: kOrangeBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline,
                        color: kOrange, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        recommendation.reason,
                        style: const TextStyle(
                            color: kOrange, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onRegenerate,
                style: OutlinedButton.styleFrom(
                  foregroundColor: kDark,
                  side: const BorderSide(color: kLightGrey),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Regenerar'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: onConsume,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kOrange,
                  foregroundColor: kWhite,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Consumir comida'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _macroItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: kOrange),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: kGrey, fontSize: 11),
        ),
      ],
    );
  }

  String _mealTypeLabel(String type) {
    return switch (type) {
      'breakfast' => 'Desayuno',
      'lunch'     => 'Almuerzo',
      'dinner'    => 'Cena',
      'snack'     => 'Merienda',
      _           => type,
    };
  }
}