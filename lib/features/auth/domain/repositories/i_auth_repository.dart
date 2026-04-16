import '../entities/user_profile.dart';
 
abstract class IAuthRepository {
  Future<String> signUp(String email, String password);
  Future<void> signIn(String email, String password);
  Future<void> signOut();
  Future<void> saveProfile(UserProfile profile);
  Future<bool> isLoggedIn();
}