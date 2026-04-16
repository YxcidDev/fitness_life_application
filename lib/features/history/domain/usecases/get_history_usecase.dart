import '../entities/history_entry.dart';
import '../repositories/i_history_repository.dart';
 
class GetHistoryUseCase {
  final IHistoryRepository _repository;
 
  const GetHistoryUseCase(this._repository);
 
  Future<List<HistoryEntry>> execute() => _repository.getHistory();
}