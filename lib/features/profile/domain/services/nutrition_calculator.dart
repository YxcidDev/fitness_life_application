class NutritionCalculator {
  static double calculateTDEE({
    required String sex,
    required double weight,
    required double height,
    required int age,
    required String goal,
  }) {
    double bmr = sex == 'male'
        ? 88.36 + (13.4 * weight) + (4.8 * height) - (5.7 * age)
        : 447.6 + (9.2 * weight) + (3.1 * height) - (4.3 * age);

    double tdee = bmr * 1.55;

    return switch (goal) {
      'lose_weight'         => tdee - 500,
      'gain_muscle'         => tdee + 300,
      'improve_performance' => tdee + 200,
      'maintain'            => tdee,
      _                     => tdee,
    };
  }

  static Map<String, double> calculateMacros(double calories) {
    return {
      'proteins': (calories * 0.30) / 4,
      'carbs': (calories * 0.45) / 4,
      'fats': (calories * 0.25) / 9,
    };
  }
}