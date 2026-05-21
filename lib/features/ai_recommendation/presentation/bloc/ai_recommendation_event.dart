import '../../domain/entities/meal_recommendation.dart';

abstract class AIRecommendationEvent {
  const AIRecommendationEvent();
}

class LoadRecommendationContext extends AIRecommendationEvent {
  const LoadRecommendationContext();
}

class GenerateRecommendation extends AIRecommendationEvent {
  final List<String> availableIngredients;
  final String? overrideMealType;

  const GenerateRecommendation({
    required this.availableIngredients,
    this.overrideMealType,
  });
}

class ConsumeRecommendation extends AIRecommendationEvent {
  final MealRecommendation recommendation;
  const ConsumeRecommendation(this.recommendation);
}

class RefreshRecommendation extends AIRecommendationEvent {
  const RefreshRecommendation();
}