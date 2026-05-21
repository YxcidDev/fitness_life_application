class Profile {
  final String id;
  final String fullName;
  final String email;
  final String sex;
  final int    age;
  final double weightKg;
  final double heightCm;
  final String goal;
  final double caloriesGoal;
  final double proteinsGoal;
  final double carbsGoal;
  final double fatsGoal;

  const Profile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.sex,
    required this.age,
    required this.weightKg,
    required this.heightCm,
    required this.goal,
    required this.caloriesGoal,
    required this.proteinsGoal,
    required this.carbsGoal,
    required this.fatsGoal,
  });

  Profile copyWith({
    String? fullName, String? sex, int? age,
    double? weightKg, double? heightCm, String? goal,
    double? caloriesGoal, double? proteinsGoal,
    double? carbsGoal, double? fatsGoal,
  }) {
    return Profile(
      id:           id,
      fullName:     fullName     ?? this.fullName,
      email:        email,
      sex:          sex          ?? this.sex,
      age:          age          ?? this.age,
      weightKg:     weightKg     ?? this.weightKg,
      heightCm:     heightCm     ?? this.heightCm,
      goal:         goal         ?? this.goal,
      caloriesGoal: caloriesGoal ?? this.caloriesGoal,
      proteinsGoal: proteinsGoal ?? this.proteinsGoal,
      carbsGoal:    carbsGoal    ?? this.carbsGoal,
      fatsGoal:     fatsGoal     ?? this.fatsGoal,
    );
  }
}