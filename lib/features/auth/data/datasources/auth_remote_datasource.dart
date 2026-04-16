import '../../../../core/supabase/supabase_client.dart';
import '../models/user_profile_model.dart';
import '../../domain/entities/user_profile.dart';
 
class AuthRemoteDataSource {
 
  Future<String> signUp(String email, String password) async {
    final res = await supabase.auth.signUp(email: email, password: password);
    return res.user!.id;
  }
 
  Future<void> signIn(String email, String password) async {
    await supabase.auth.signInWithPassword(email: email, password: password);
  }
 
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
 
  Future<void> saveProfile(UserProfileModel model) async {
    await supabase.from('user_profiles').insert(model.toJson());
 
    final calories = _calculateCalories(
      model.sex, model.weightKg, model.heightCm, model.age, model.goal,
    );
 
    await supabase.from('daily_goals').insert({
      'user_id':       model.id,
      'calories_goal': calories,
      'proteins_goal': (calories * 0.30) / 4,
      'carbs_goal':    (calories * 0.45) / 4,
      'fats_goal':     (calories * 0.25) / 9,
    });
  }
 
  Future<bool> isLoggedIn() async {
    return supabase.auth.currentSession != null;
  }
 
  double _calculateCalories(String sex, double weight, double height, int age, FitnessGoal goal) {
    double bmr = sex == 'male'
        ? 88.36 + (13.4 * weight) + (4.8 * height) - (5.7 * age)
        : 447.6 + (9.2  * weight) + (3.1 * height) - (4.3 * age);
 
    double tdee = bmr * 1.55;
 
    return switch (goal) {
      FitnessGoal.loseWeight         => tdee - 500,
      FitnessGoal.gainMuscle         => tdee + 300,
      FitnessGoal.improvePerformance => tdee + 200,
      FitnessGoal.maintain           => tdee,
    };
  }
}