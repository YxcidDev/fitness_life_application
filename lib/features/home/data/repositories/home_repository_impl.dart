import '../../domain/entities/home_summary.dart';
import '../../domain/repositories/i_home_repository.dart';
import '../datasources/home_remote_datasource.dart';
import '../models/home_summary_model.dart';
 
class HomeRepositoryImpl implements IHomeRepository {
  final HomeRemoteDataSource _dataSource;
 
  const HomeRepositoryImpl(this._dataSource);
 
  @override
  Future<HomeSummary> getTodaySummary() async {
    final data    = await _dataSource.getTodaySummary();
    final meals   = List<Map<String, dynamic>>.from(data['meals'] as List);
    final goals   = data['goals']   as Map<String, dynamic>;
    final profile = data['profile'] as Map<String, dynamic>;
    final name    = profile['full_name'] as String;
 
    if (meals.isEmpty) {
      return HomeSummary.empty(
        calGoal:  (goals['calories_goal'] as num).toDouble(),
        protGoal: (goals['proteins_goal'] as num).toDouble(),
        carbGoal: (goals['carbs_goal']    as num).toDouble(),
        fatGoal:  (goals['fats_goal']     as num).toDouble(),
        userName: name,
      );
    }
 
    return HomeSummaryModel.fromSupabase(
        meals: meals, goals: goals, userName: name);
  }
}