import 'dart:io';
import '../entities/meal.dart';
import '../repositories/i_meal_repository.dart';
 
class AnalyzeMealUseCase {
  final IMealRepository _repository;
 
  const AnalyzeMealUseCase(this._repository);
 
  Future<Meal> execute(File image) => _repository.analyzeFromImage(image);
}