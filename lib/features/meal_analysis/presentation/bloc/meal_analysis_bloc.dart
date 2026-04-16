import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/analyze_meal_usecase.dart';
import '../../domain/usecases/save_meal_usecase.dart';
import '../../domain/entities/meal.dart';
import 'meal_analysis_event.dart';
import 'meal_analysis_state.dart';
 
class MealAnalysisBloc extends Bloc<MealAnalysisEvent, MealAnalysisState> {
  final AnalyzeMealUseCase _analyzeUseCase;
  final SaveMealUseCase    _saveUseCase;
  Meal? _currentMeal;
  File? _currentImage;
 
  MealAnalysisBloc({
    required AnalyzeMealUseCase analyzeUseCase,
    required SaveMealUseCase    saveUseCase,
  })  : _analyzeUseCase = analyzeUseCase,
        _saveUseCase    = saveUseCase,
        super(MealAnalysisInitial()) {
    on<AnalyzeImageEvent>(_onAnalyze);
    on<SaveMealEvent>(_onSave);
    on<ResetAnalysisEvent>(_onReset);
  }
 
  Future<void> _onAnalyze(AnalyzeImageEvent event, Emitter emit) async {
    emit(MealAnalysisLoading());
    try {
      final meal = await _analyzeUseCase.execute(event.image);
      _currentMeal = meal;
      _currentImage = event.image;
      emit(MealAnalysisSuccess(meal, event.image));
    } catch (e) {
      emit(MealAnalysisError(e.toString()));
    }
  }
 
  Future<void> _onSave(SaveMealEvent event, Emitter emit) async {
    if (_currentMeal == null) return;
    emit(MealAnalysisLoading());
    try {
      await _saveUseCase.execute(_currentMeal!, event.mealType);
      emit(MealSavedSuccess());
    } catch (e) {
      emit(MealAnalysisError(e.toString()));
    }
  }
 
  void _onReset(ResetAnalysisEvent event, Emitter emit) {
    _currentMeal = null;
    _currentImage = null;
    emit(MealAnalysisInitial());
  }
}