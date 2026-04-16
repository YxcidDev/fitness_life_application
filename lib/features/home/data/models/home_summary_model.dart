import '../../domain/entities/home_summary.dart';
 
class HomeSummaryModel extends HomeSummary {
  const HomeSummaryModel({
    required super.caloriesConsumed,
    required super.caloriesGoal,
    required super.proteinsConsumed,
    required super.proteinsGoal,
    required super.carbsConsumed,
    required super.carbsGoal,
    required super.fatsConsumed,
    required super.fatsGoal,
    required super.mealsCount,
    required super.registeredMealTypes,
    required super.userName,
  });
 
  factory HomeSummaryModel.fromSupabase({
    required List<Map<String, dynamic>> meals,
    required Map<String, dynamic> goals,
    required String userName,
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
 
    return HomeSummaryModel(
      caloriesConsumed: totalCal,
      caloriesGoal:     (goals['calories_goal'] as num).toDouble(),
      proteinsConsumed: totalProt,
      proteinsGoal:     (goals['proteins_goal'] as num).toDouble(),
      carbsConsumed:    totalCarbs,
      carbsGoal:        (goals['carbs_goal']    as num).toDouble(),
      fatsConsumed:     totalFats,
      fatsGoal:         (goals['fats_goal']     as num).toDouble(),
      mealsCount:       meals.length,
      registeredMealTypes: types,
      userName:         userName,
    );
  }
}