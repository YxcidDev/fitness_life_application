import '../entities/home_summary.dart';
 
abstract class IHomeRepository {
  Future<HomeSummary> getTodaySummary();
}