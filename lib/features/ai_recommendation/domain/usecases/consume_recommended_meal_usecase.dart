import '../entities/meal_recommendation.dart';
import '../repositories/i_ai_recommendation_repository.dart';

class ConsumeRecommendedMealUseCase {
  final IAIRecommendationRepository _repository;
  const ConsumeRecommendedMealUseCase(this._repository);

  Future<void> execute(MealRecommendation recommendation) =>
      _repository.consumeRecommendedMeal(recommendation);
}