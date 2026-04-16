import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_profile_model.dart';
 
class AuthRepositoryImpl implements IAuthRepository {
  final AuthRemoteDataSource _dataSource;
 
  const AuthRepositoryImpl(this._dataSource);
 
  @override
  Future<String> signUp(String email, String password) =>
      _dataSource.signUp(email, password);
 
  @override
  Future<void> signIn(String email, String password) =>
      _dataSource.signIn(email, password);
 
  @override
  Future<void> signOut() => _dataSource.signOut();
 
  @override
  Future<bool> isLoggedIn() => _dataSource.isLoggedIn();
 
  @override
  Future<void> saveProfile(UserProfile profile) {
    final model = UserProfileModel(
      id:       profile.id,
      fullName: profile.fullName,
      email:    profile.email,
      sex:      profile.sex,
      age:      profile.age,
      weightKg: profile.weightKg,
      heightCm: profile.heightCm,
      goal:     profile.goal,
    );
    return _dataSource.saveProfile(model);
  }
}