import '../../domain/entities/user_profile.dart';
 
class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.sex,
    required super.age,
    required super.weightKg,
    required super.heightCm,
    required super.goal,
  });
 
  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id:        json['id'] as String,
      fullName:  json['full_name'] as String,
      email:     json['email'] as String? ?? '',
      sex:       json['sex'] as String,
      age:       json['age'] as int,
      weightKg:  (json['weight_kg'] as num).toDouble(),
      heightCm:  (json['height_cm'] as num).toDouble(),
      goal:      _goalFromString(json['goal'] as String),
    );
  }
 
  Map<String, dynamic> toJson() => {
    'id':        id,
    'full_name': fullName,
    'sex':       sex,
    'age':       age,
    'weight_kg': weightKg,
    'height_cm': heightCm,
    'goal':      _goalToString(goal),
  };
 
  static FitnessGoal _goalFromString(String s) {
    return switch (s) {
      'lose_weight'          => FitnessGoal.loseWeight,
      'gain_muscle'          => FitnessGoal.gainMuscle,
      'improve_performance'  => FitnessGoal.improvePerformance,
      _                      => FitnessGoal.maintain,
    };
  }
 
  static String _goalToString(FitnessGoal g) {
    return switch (g) {
      FitnessGoal.loseWeight          => 'lose_weight',
      FitnessGoal.gainMuscle          => 'gain_muscle',
      FitnessGoal.improvePerformance  => 'improve_performance',
      FitnessGoal.maintain            => 'maintain',
    };
  }
}