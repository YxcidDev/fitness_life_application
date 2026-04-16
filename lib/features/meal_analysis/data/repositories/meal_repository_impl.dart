import 'dart:io';
import '../../domain/entities/meal.dart';
import '../../domain/repositories/i_meal_repository.dart';
import '../datasources/meal_remote_datasource.dart';
import '../models/meal_model.dart';
 
class MealRepositoryImpl implements IMealRepository {
  final MealRemoteDataSource _dataSource;
 
  const MealRepositoryImpl(this._dataSource);
 
  @override
  Future<Meal> analyzeFromImage(File image) =>
      _dataSource.analyzeFromImage(image);
 
  @override
  Future<void> saveMeal(Meal meal, String mealType) =>
      _dataSource.saveMeal(meal as MealModel, mealType);
}