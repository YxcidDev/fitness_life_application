class NutritionContext {
  final String userId;
  final double caloriesConsumed;
  final double caloriesGoal;
  final double proteinsConsumed;
  final double proteinsGoal;
  final double carbsConsumed;
  final double carbsGoal;
  final double fatsConsumed;
  final double fatsGoal;
  final List<String> consumedMealTypes;
  final String userGoal;
  final String suggestedMealType;

  const NutritionContext({
    required this.userId,
    required this.caloriesConsumed,
    required this.caloriesGoal,
    required this.proteinsConsumed,
    required this.proteinsGoal,
    required this.carbsConsumed,
    required this.carbsGoal,
    required this.fatsConsumed,
    required this.fatsGoal,
    required this.consumedMealTypes,
    required this.userGoal,
    required this.suggestedMealType,
  });

  double get remainingCalories =>
      (caloriesGoal - caloriesConsumed).clamp(0.0, double.infinity);
  double get remainingProteins =>
      (proteinsGoal - proteinsConsumed).clamp(0.0, double.infinity);
  double get remainingCarbs =>
      (carbsGoal - carbsConsumed).clamp(0.0, double.infinity);
  double get remainingFats =>
      (fatsGoal - fatsConsumed).clamp(0.0, double.infinity);
}