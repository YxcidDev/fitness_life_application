import '../repositories/i_history_repository.dart';
 
class GetWeeklySummaryUseCase {
  final IHistoryRepository _repository;
 
  const GetWeeklySummaryUseCase(this._repository);
 
  Future<Map<String, double>> execute() => _repository.getWeeklySummary();
}