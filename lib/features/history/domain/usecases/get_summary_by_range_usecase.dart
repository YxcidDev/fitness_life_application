import '../repositories/i_history_repository.dart';

class GetSummaryByRangeUseCase {
  final IHistoryRepository _repository;

  const GetSummaryByRangeUseCase(this._repository);

  Future<Map<String, double>> execute(DateTime from, DateTime to) =>
      _repository.getSummaryByRange(from, to);
}