import '../../domain/entities/history_entry.dart';
import '../../domain/repositories/i_history_repository.dart';
import '../datasources/history_remote_datasource.dart';
import '../models/history_entry_model.dart';
 
class HistoryRepositoryImpl implements IHistoryRepository {
  final HistoryRemoteDataSource _dataSource;
 
  const HistoryRepositoryImpl(this._dataSource);
 
  @override
  Future<List<HistoryEntry>> getHistory() async {
    final data = await _dataSource.getHistory();
    return data.map((e) => HistoryEntryModel.fromJson(e)).toList();
  }
 
  @override
  Future<List<HistoryEntry>> getByDateRange(DateTime from, DateTime to) async {
    final data = await _dataSource.getByDateRange(from, to);
    return data.map((e) => HistoryEntryModel.fromJson(e)).toList();
  }
 
  @override
  Future<Map<String, double>> getWeeklySummary() =>
      _dataSource.getWeeklySummary();
}