import '../entities/nutrition_context.dart';
import '../repositories/i_ai_recommendation_repository.dart';

class GetRecommendationContextUseCase {
  final IAIRecommendationRepository _repository;
  const GetRecommendationContextUseCase(this._repository);

  Future<NutritionContext> execute() => _repository.getRecommendationContext();
}