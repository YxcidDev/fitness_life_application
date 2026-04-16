import 'dart:io';
import 'package:equatable/equatable.dart';
 
abstract class MealAnalysisEvent extends Equatable {
  @override
  List<Object?> get props => [];
}
 
class AnalyzeImageEvent extends MealAnalysisEvent {
  final File image;
  AnalyzeImageEvent(this.image);
  @override
  List<Object?> get props => [image.path];
}
 
class SaveMealEvent extends MealAnalysisEvent {
  final String mealType;
  SaveMealEvent(this.mealType);
  @override
  List<Object?> get props => [mealType];
}
 
class ResetAnalysisEvent extends MealAnalysisEvent {}