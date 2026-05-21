import '../entities/profile.dart';
import '../repositories/i_profile_repository.dart';
import '../services/nutrition_calculator.dart';

class UpdateProfileUseCase {
  final IProfileRepository _repository;

  const UpdateProfileUseCase(this._repository);

  Future<Profile> execute(Profile profile) async {
    
    final newCalories = NutritionCalculator.calculateTDEE(
      sex: profile.sex,
      weight: profile.weightKg,
      height: profile.heightCm,
      age: profile.age,
      goal: profile.goal,
    );

    final macros = NutritionCalculator.calculateMacros(newCalories);

    final updatedProfile = profile.copyWith(
      caloriesGoal: newCalories,
      proteinsGoal: macros['proteins'],
      carbsGoal: macros['carbs'],
      fatsGoal: macros['fats'],
    );

    await _repository.updateProfile(updatedProfile);

    return updatedProfile;
  }
}