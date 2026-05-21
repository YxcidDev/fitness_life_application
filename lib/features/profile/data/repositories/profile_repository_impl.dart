import '../../domain/entities/profile.dart';
import '../../domain/repositories/i_profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final ProfileRemoteDataSource _dataSource;

  const ProfileRepositoryImpl(this._dataSource);

  @override
  Future<Profile> getProfile() async {
    final data = await _dataSource.getProfile();
    final profile = data['profile'] as Map<String, dynamic>;
    final goals = data['goals'] as Map<String, dynamic>;
    return ProfileModel.fromJson(profile, goals);
  }

  @override
  Future<Profile> updateProfile(Profile p) async {
    await _dataSource.updateProfile(
      {
        'sex': p.sex,
        'age': p.age,
        'weight_kg': p.weightKg,
        'height_cm': p.heightCm,
        'goal': p.goal,
      },
      {
        'calories_goal': p.caloriesGoal,
        'proteins_goal': p.proteinsGoal,
        'carbs_goal': p.carbsGoal,
        'fats_goal': p.fatsGoal,
      },
    );
    return p;
  }

  @override
  Future<void> signOut() => _dataSource.signOut();
}
