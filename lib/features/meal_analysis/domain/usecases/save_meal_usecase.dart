import '../entities/meal.dart';
import '../repositories/i_meal_repository.dart';
 
class SaveMealUseCase {
  final IMealRepository _repository;
 
  const SaveMealUseCase(this._repository);
 
  Future<void> execute(Meal meal, String mealType) =>
      _repository.saveMeal(meal, mealType);
}