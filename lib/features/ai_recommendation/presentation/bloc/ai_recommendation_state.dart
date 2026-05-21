import '../../domain/entities/meal_recommendation.dart';
import '../../domain/entities/nutrition_context.dart';

abstract class AIRecommendationState {
  const AIRecommendationState();
}

class AIRecommendationInitial extends AIRecommendationState {
  const AIRecommendationInitial();
}

class AIRecommendationLoadingContext extends AIRecommendationState {
  const AIRecommendationLoadingContext();
}

class AIRecommendationContextLoaded extends AIRecommendationState {
  final NutritionContext context;
  const AIRecommendationContextLoaded(this.context);
}

class AIRecommendationGenerating extends AIRecommendationState {
  final NutritionContext context;
  const AIRecommendationGenerating(this.context);
}

class AIRecommendationLoaded extends AIRecommendationState {
  final NutritionContext context;
  final MealRecommendation recommendation;
  const AIRecommendationLoaded({
    required this.context,
    required this.recommendation,
  });
}

class AIRecommendationConsuming extends AIRecommendationState {
  final NutritionContext context;
  final MealRecommendation recommendation;
  const AIRecommendationConsuming({
    required this.context,
    required this.recommendation,
  });
}

class AIRecommendationConsumed extends AIRecommendationState {
  final NutritionContext context;
  const AIRecommendationConsumed(this.context);
}

class AIRecommendationError extends AIRecommendationState {
  final String message;
  final NutritionContext? context;
  const AIRecommendationError(this.message, {this.context});
}