import '../../domain/entities/meal_recommendation.dart';
import '../../domain/entities/nutrition_context.dart';
import '../../domain/repositories/i_ai_recommendation_repository.dart';
import '../datasources/ai_recommendation_remote_datasource.dart';
import '../models/meal_recommendation_model.dart';

class AIRecommendationRepositoryImpl implements IAIRecommendationRepository {
  final AIRecommendationRemoteDataSource _dataSource;

  const AIRecommendationRepositoryImpl(this._dataSource);

  @override
  Future<NutritionContext> getRecommendationContext() =>
      _dataSource.getRecommendationContext();

  @override
  Future<MealRecommendation> generateRecommendation({
    required String userId,
    required List<String> availableIngredients,
    String? overrideMealType,
  }) =>
      _dataSource.generateRecommendation(
        userId:               userId,
        availableIngredients: availableIngredients,
        overrideMealType:     overrideMealType,
      );

  @override
  Future<void> consumeRecommendedMeal(MealRecommendation recommendation) =>
      _dataSource.consumeRecommendedMeal(
        recommendation as MealRecommendationModel,
      );
}