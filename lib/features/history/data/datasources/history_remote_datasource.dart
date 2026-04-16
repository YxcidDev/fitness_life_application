import '../../../../core/supabase/supabase_client.dart';
 
class HistoryRemoteDataSource {
 
  Future<List<Map<String, dynamic>>> getHistory() async {
    final userId = supabase.auth.currentUser!.id;
    final result = await supabase
        .from('meals')
        .select()
        .eq('user_id', userId)
        .order('analyzed_at', ascending: false);
    return List<Map<String, dynamic>>.from(result);
  }
 
  Future<List<Map<String, dynamic>>> getByDateRange(
      DateTime from, DateTime to) async {
    final userId = supabase.auth.currentUser!.id;
    final result = await supabase
        .from('meals')
        .select()
        .eq('user_id', userId)
        .gte('analyzed_at', from.toIso8601String())
        .lte('analyzed_at', to.toIso8601String())
        .order('analyzed_at', ascending: false);
    return List<Map<String, dynamic>>.from(result);
  }
 
  Future<Map<String, double>> getWeeklySummary() async {
    final userId = supabase.auth.currentUser!.id;
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
 
    final result = await supabase
        .from('meals')
        .select('calories, proteins, carbs, fats')
        .eq('user_id', userId)
        .gte('analyzed_at', weekAgo.toIso8601String());
 
    final meals = List<Map<String, dynamic>>.from(result);
    double totalCal = 0, totalProt = 0, totalCarbs = 0, totalFats = 0;
    for (final m in meals) {
      totalCal   += (m['calories'] as num).toDouble();
      totalProt  += (m['proteins'] as num).toDouble();
      totalCarbs += (m['carbs']    as num).toDouble();
      totalFats  += (m['fats']     as num).toDouble();
    }
 
    return {
      'calories':   totalCal,
      'proteins':   totalProt,
      'carbs':      totalCarbs,
      'fats':       totalFats,
      'mealsCount': meals.length.toDouble(),
    };
  }
}