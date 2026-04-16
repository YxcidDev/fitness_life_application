class HomeSummary {
  final double caloriesConsumed;
  final double caloriesGoal;
  final double proteinsConsumed;
  final double proteinsGoal;
  final double carbsConsumed;
  final double carbsGoal;
  final double fatsConsumed;
  final double fatsGoal;
  final int mealsCount;
  final List<String> registeredMealTypes;
  final String userName;
 
  const HomeSummary({
    required this.caloriesConsumed,
    required this.caloriesGoal,
    required this.proteinsConsumed,
    required this.proteinsGoal,
    required this.carbsConsumed,
    required this.carbsGoal,
    required this.fatsConsumed,
    required this.fatsGoal,
    required this.mealsCount,
    required this.registeredMealTypes,
    required this.userName,
  });
 
  factory HomeSummary.empty({
    required double calGoal,
    required double protGoal,
    required double carbGoal,
    required double fatGoal,
    required String userName,
  }) {
    return HomeSummary(
      caloriesConsumed: 0, caloriesGoal: calGoal,
      proteinsConsumed: 0, proteinsGoal: protGoal,
      carbsConsumed: 0,    carbsGoal: carbGoal,
      fatsConsumed: 0,     fatsGoal: fatGoal,
      mealsCount: 0,
      registeredMealTypes: [],
      userName: userName,
    );
  }
 
  double get caloriesPercent =>
      caloriesGoal == 0 ? 0 : (caloriesConsumed / caloriesGoal).clamp(0.0, 1.0);
 
  double get proteinsPercent =>
      proteinsGoal == 0 ? 0 : (proteinsConsumed / proteinsGoal).clamp(0.0, 1.0);
 
  double get carbsPercent =>
      carbsGoal == 0 ? 0 : (carbsConsumed / carbsGoal).clamp(0.0, 1.0);
 
  double get fatsPercent =>
      fatsGoal == 0 ? 0 : (fatsConsumed / fatsGoal).clamp(0.0, 1.0);
}