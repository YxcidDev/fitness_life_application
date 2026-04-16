import '../repositories/i_auth_repository.dart';
 
class SignInUseCase {
  final IAuthRepository _repository;
 
  const SignInUseCase(this._repository);
 
  Future<void> execute(String email, String password) {
    return _repository.signIn(email, password);
  }
}