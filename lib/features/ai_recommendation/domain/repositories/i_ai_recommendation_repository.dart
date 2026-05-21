import '../entities/meal_recommendation.dart';
import '../entities/nutrition_context.dart';

abstract class IAIRecommendationRepository {
  Future<NutritionContext> getRecommendationContext();

  Future<MealRecommendation> generateRecommendation({
    required String userId,
    required List<String> availableIngredients,
    String? overrideMealType,
  });

  Future<void> consumeRecommendedMeal(MealRecommendation recommendation);
}