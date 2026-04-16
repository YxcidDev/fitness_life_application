enum FitnessGoal {
  loseWeight,
  gainMuscle,
  maintain,
  improvePerformance,
}
 
class UserProfile {
  final String id;
  final String fullName;
  final String email;
  final String sex;
  final int age;
  final double weightKg;
  final double heightCm;
  final FitnessGoal goal;
 
  const UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.sex,
    required this.age,
    required this.weightKg,
    required this.heightCm,
    required this.goal,
  });
}