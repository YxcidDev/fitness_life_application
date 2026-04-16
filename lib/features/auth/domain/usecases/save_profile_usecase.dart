import '../entities/user_profile.dart';
import '../repositories/i_auth_repository.dart';
 
class SaveProfileUseCase {
  final IAuthRepository _repository;
 
  const SaveProfileUseCase(this._repository);
 
  Future<void> execute(UserProfile profile) {
    return _repository.saveProfile(profile);
  }
}