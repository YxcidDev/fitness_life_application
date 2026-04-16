import '../entities/home_summary.dart';
import '../repositories/i_home_repository.dart';
 
class GetHomeSummaryUseCase {
  final IHomeRepository _repository;
 
  const GetHomeSummaryUseCase(this._repository);
 
  Future<HomeSummary> execute() => _repository.getTodaySummary();
}