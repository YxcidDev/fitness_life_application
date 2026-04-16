import '../repositories/i_auth_repository.dart';
 
class SignUpUseCase {
  final IAuthRepository _repository;
 
  const SignUpUseCase(this._repository);
 
  Future<String> execute(String email, String password) {
    return _repository.signUp(email, password);
  }
}