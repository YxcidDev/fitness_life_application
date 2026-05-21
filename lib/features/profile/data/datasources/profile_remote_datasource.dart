import '../../../../core/supabase/supabase_client.dart';

class ProfileRemoteDataSource {

  Future<Map<String, dynamic>> getProfile() async {
    final userId = supabase.auth.currentUser!.id;

    final profile = await supabase
        .from('user_profiles')
        .select()
        .eq('id', userId)
        .single();

    final goals = await supabase
        .from('daily_goals')
        .select()
        .eq('user_id', userId)
        .single();

    return {'profile': profile, 'goals': goals};
  }

  Future<void> updateProfile(Map<String, dynamic> profileData,
      Map<String, dynamic> goalsData) async {
    final userId = supabase.auth.currentUser!.id;
    await supabase
        .from('user_profiles')
        .update(profileData)
        .eq('id', userId);
    await supabase
        .from('daily_goals')
        .update(goalsData)
        .eq('user_id', userId);
  }

  Future<void> signOut() async => supabase.auth.signOut();
}