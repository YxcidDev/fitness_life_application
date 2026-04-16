import 'dart:io';
import '../entities/meal.dart';
 
abstract class IMealRepository {
  Future<Meal> analyzeFromImage(File image);
  Future<void> saveMeal(Meal meal, String mealType);
}