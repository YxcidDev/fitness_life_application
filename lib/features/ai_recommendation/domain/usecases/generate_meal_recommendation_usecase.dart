import '../entities/meal_recommendation.dart';
import '../repositories/i_ai_recommendation_repository.dart';

class GenerateMealRecommendationUseCase {
  final IAIRecommendationRepository _repository;
  const GenerateMealRecommendationUseCase(this._repository);

  Future<MealRecommendation> execute({
    required String userId,
    required List<String> availableIngredients,
    String? overrideMealType,
  }) =>
      _repository.generateRecommendation(
        userId: userId,
        availableIngredients: availableIngredients,
        overrideMealType: overrideMealType,
      );
}