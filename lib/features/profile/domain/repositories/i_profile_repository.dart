import '../entities/profile.dart';
 
abstract class IProfileRepository {
  Future<Profile> getProfile();
  Future<void> updateProfile(Profile profile);
  Future<void> signOut();
}