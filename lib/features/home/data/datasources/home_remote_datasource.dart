import '../../../../core/supabase/supabase_client.dart';
 
class HomeRemoteDataSource {
  Future<Map<String, dynamic>> getTodaySummary() async {
    final userId = supabase.auth.currentUser!.id;
    final now    = DateTime.now();
    final start  = DateTime(now.year, now.month, now.day).toIso8601String();
    final end    = DateTime(now.year, now.month, now.day, 23, 59, 59).toIso8601String();
 
    final meals = await supabase
        .from('meals')
        .select('meal_type, calories, proteins, carbs, fats')
        .eq('user_id', userId)
        .gte('analyzed_at', start)
        .lte('analyzed_at', end);
 
    final goals = await supabase
        .from('daily_goals')
        .select()
        .eq('user_id', userId)
        .single();
 
    final profile = await supabase
        .from('user_profiles')
        .select('full_name')
        .eq('id', userId)
        .single();
 
    return {
      'meals':   meals,
      'goals':   goals,
      'profile': profile,
    };
  }
}