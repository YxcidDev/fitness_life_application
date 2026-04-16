import '../entities/history_entry.dart';
 
abstract class IHistoryRepository {
  Future<List<HistoryEntry>> getHistory();
  Future<List<HistoryEntry>> getByDateRange(DateTime from, DateTime to);
  Future<Map<String, double>> getWeeklySummary();
}