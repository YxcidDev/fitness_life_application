class MealRecommendation {
  final String mealName;
  final String mealType;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final List<String> ingredients;
  final String reason;

  const MealRecommendation({
    required this.mealName,
    required this.mealType,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.ingredients,
    required this.reason,
  });
}