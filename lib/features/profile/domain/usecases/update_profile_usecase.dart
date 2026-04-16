import '../entities/profile.dart';
import '../repositories/i_profile_repository.dart';
 
class UpdateProfileUseCase {
  final IProfileRepository _repository;
 
  const UpdateProfileUseCase(this._repository);
 
  Future<void> execute(Profile profile) => _repository.updateProfile(profile);
}