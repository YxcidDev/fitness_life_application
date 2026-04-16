import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../domain/entities/meal.dart';
 
abstract class MealAnalysisState extends Equatable {
  @override
  List<Object?> get props => [];
}
 
class MealAnalysisInitial extends MealAnalysisState {}
 
class MealAnalysisLoading extends MealAnalysisState {}
 
class MealAnalysisSuccess extends MealAnalysisState {
  final Meal meal;
  final File imageFile;
  MealAnalysisSuccess(this.meal, this.imageFile);
  @override
  List<Object?> get props => [meal, imageFile];
}
 
class MealSavedSuccess extends MealAnalysisState {}
 
class MealAnalysisError extends MealAnalysisState {
  final String message;
  MealAnalysisError(this.message);
  @override
  List<Object?> get props => [message];
}