import '../../domain/entities/profile.dart';
 
class ProfileModel extends Profile {
  const ProfileModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.sex,
    required super.age,
    required super.weightKg,
    required super.heightCm,
    required super.goal,
    required super.caloriesGoal,
    required super.proteinsGoal,
  });
 
  factory ProfileModel.fromJson(
      Map<String, dynamic> profile, Map<String, dynamic> goals) {
    return ProfileModel(
      id:           profile['id']        as String,
      fullName:     profile['full_name'] as String,
      email:        profile['email']     as String? ?? '',
      sex:          profile['sex']       as String,
      age:          profile['age']       as int,
      weightKg:     (profile['weight_kg'] as num).toDouble(),
      heightCm:     (profile['height_cm'] as num).toDouble(),
      goal:         profile['goal']      as String,
      caloriesGoal: (goals['calories_goal'] as num).toDouble(),
      proteinsGoal: (goals['proteins_goal'] as num).toDouble(),
    );
  }
}