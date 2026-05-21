import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/ai_recommendation_bloc.dart';
import '../bloc/ai_recommendation_state.dart';
import 'recommendation_bottom_sheet.dart';

class RecommendationCard extends StatelessWidget {
  const RecommendationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AIRecommendationBloc, AIRecommendationState>(
      builder: (context, state) {
        if (state is AIRecommendationLoadingContext) {
          return _cardShell(
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(color: kOrange),
              ),
            ),
          );
        }

        final ctx = switch (state) {
          AIRecommendationContextLoaded s => s.context,
          AIRecommendationLoaded s       => s.context,
          AIRecommendationConsumed s     => s.context,
          AIRecommendationError s        => s.context,
          _                              => null,
        };

        if (ctx == null) return const SizedBox.shrink();

        final slotLabel = _mealTypeLabel(ctx.suggestedMealType);

        return _cardShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: kOrange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'IA',
                      style: TextStyle(
                          color: kWhite,
                          fontSize: 11,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Recomendación de comida',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: kDark),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  _macroChip(
                      '${ctx.remainingCalories.toStringAsFixed(0)} kcal',
                      Icons.local_fire_department_outlined),
                  const SizedBox(width: 8),
                  _macroChip(
                      '${ctx.remainingProteins.toStringAsFixed(0)}g prot',
                      Icons.fitness_center),
                  const SizedBox(width: 8),
                  _macroChip(
                      '${ctx.remainingCarbs.toStringAsFixed(0)}g carbs',
                      Icons.rice_bowl_outlined),
                ],
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  const Icon(Icons.schedule, size: 14, color: kGrey),
                  const SizedBox(width: 4),
                  Text(
                    'Sugerido: $slotLabel',
                    style: const TextStyle(color: kGrey, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _openBottomSheet(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kOrange,
                    foregroundColor: kWhite,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('Generar recomendación'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _macroChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: kOrangeBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: kOrange),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 11,
                  color: kOrange,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _cardShell({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
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

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<AIRecommendationBloc>(),
        child: const RecommendationBottomSheet(),
      ),
    );
  }
}