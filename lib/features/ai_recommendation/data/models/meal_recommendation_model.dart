import '../../domain/entities/meal_recommendation.dart';

class MealRecommendationModel extends MealRecommendation {
  const MealRecommendationModel({
    required super.mealName,
    required super.mealType,
    required super.calories,
    required super.protein,
    required super.carbs,
    required super.fat,
    required super.ingredients,
    required super.reason,
  });

  factory MealRecommendationModel.fromJson(Map<String, dynamic> json) {
    return MealRecommendationModel(
      mealName:    json['meal_name']   as String,
      mealType:    json['meal_type']   as String,
      calories:    (json['calories']   as num).toDouble(),
      protein:     (json['protein']    as num).toDouble(),
      carbs:       (json['carbs']      as num).toDouble(),
      fat:         (json['fat']        as num).toDouble(),
      ingredients: List<String>.from(json['ingredients'] as List),
      reason:      json['reason']      as String,
    );
  }
}