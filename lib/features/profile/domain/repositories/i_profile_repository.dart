import '../entities/profile.dart';
 
abstract class IProfileRepository {
  Future<Profile> getProfile();
  Future<Profile> updateProfile(Profile profile);
  Future<void> signOut();
}