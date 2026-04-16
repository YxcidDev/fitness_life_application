import '../../domain/entities/profile.dart';
import '../../domain/repositories/i_profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/profile_model.dart';
 
class ProfileRepositoryImpl implements IProfileRepository {
  final ProfileRemoteDataSource _dataSource;
 
  const ProfileRepositoryImpl(this._dataSource);
 
  @override
  Future<Profile> getProfile() async {
    final data    = await _dataSource.getProfile();
    final profile = data['profile'] as Map<String, dynamic>;
    final goals   = data['goals']   as Map<String, dynamic>;
    return ProfileModel.fromJson(profile, goals);
  }
 
  @override
  Future<void> updateProfile(Profile profile) =>
      _dataSource.updateProfile({'full_name': profile.fullName});
 
  @override
  Future<void> signOut() => _dataSource.signOut();
}