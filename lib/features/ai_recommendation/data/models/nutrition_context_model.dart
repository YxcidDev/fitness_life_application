import '../../domain/entities/nutrition_context.dart';

class NutritionContextModel extends NutritionContext {
  const NutritionContextModel({
    required super.userId,
    required super.caloriesConsumed,
    required super.caloriesGoal,
    required super.proteinsConsumed,
    required super.proteinsGoal,
    required super.carbsConsumed,
    required super.carbsGoal,
    required super.fatsConsumed,
    required super.fatsGoal,
    required super.consumedMealTypes,
    required super.userGoal,
    required super.suggestedMealType,
  });

  factory NutritionContextModel.fromSupabase({
    required List<Map<String, dynamic>> meals,
    required Map<String, dynamic> goals,
    required Map<String, dynamic> profile,
    required String userId,
  }) {
    double totalCal = 0, totalProt = 0, totalCarbs = 0, totalFats = 0;
    final types = <String>[];

    for (final m in meals) {
      totalCal   += (m['calories'] as num).toDouble();
      totalProt  += (m['proteins'] as num).toDouble();
      totalCarbs += (m['carbs']    as num).toDouble();
      totalFats  += (m['fats']     as num).toDouble();
      types.add(m['meal_type'] as String);
    }

    return NutritionContextModel(
      userId:           userId,
      caloriesConsumed: totalCal,
      caloriesGoal:     (goals['calories_goal'] as num).toDouble(),
      proteinsConsumed: totalProt,
      proteinsGoal:     (goals['proteins_goal'] as num).toDouble(),
      carbsConsumed:    totalCarbs,
      carbsGoal:        (goals['carbs_goal']    as num).toDouble(),
      fatsConsumed:     totalFats,
      fatsGoal:         (goals['fats_goal']     as num).toDouble(),
      consumedMealTypes: types,
      userGoal:          profile['goal'] as String,
      suggestedMealType: _inferMealType(types, DateTime.now().hour),
    );
  }

  static String _inferMealType(List<String> consumed, int hour) {
    if (!consumed.contains('breakfast') && hour < 12) return 'breakfast';
    if (!consumed.contains('lunch')     && hour >= 10 && hour < 17) return 'lunch';
    if (!consumed.contains('dinner')    && hour >= 15) return 'dinner';

    for (final s in ['breakfast', 'lunch', 'dinner', 'snack']) {
      if (!consumed.contains(s)) return s;
    }
    return 'snack';
  }
}