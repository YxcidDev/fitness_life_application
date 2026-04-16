import '../entities/profile.dart';
import '../repositories/i_profile_repository.dart';
 
class GetProfileUseCase {
  final IProfileRepository _repository;
 
  const GetProfileUseCase(this._repository);
 
  Future<Profile> execute() => _repository.getProfile();
}