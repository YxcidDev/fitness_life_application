import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/consume_recommended_meal_usecase.dart';
import '../../domain/usecases/generate_meal_recommendation_usecase.dart';
import '../../domain/usecases/get_recommendation_context_usecase.dart';
import '../../data/datasources/ai_recommendation_remote_datasource.dart';
import '../../data/repositories/ai_recommendation_repository_impl.dart';
import 'ai_recommendation_event.dart';
import 'ai_recommendation_state.dart';

class AIRecommendationBloc
    extends Bloc<AIRecommendationEvent, AIRecommendationState> {
  final GetRecommendationContextUseCase _getContext;
  final GenerateMealRecommendationUseCase _generate;
  final ConsumeRecommendedMealUseCase _consume;

  AIRecommendationBloc({
    required GetRecommendationContextUseCase getContext,
    required GenerateMealRecommendationUseCase generate,
    required ConsumeRecommendedMealUseCase consume,
  })  : _getContext = getContext,
        _generate   = generate,
        _consume    = consume,
        super(const AIRecommendationInitial()) {
    on<LoadRecommendationContext>(_onLoadContext);
    on<GenerateRecommendation>(_onGenerate);
    on<ConsumeRecommendation>(_onConsume);
    on<RefreshRecommendation>(_onRefresh);
  }

  factory AIRecommendationBloc.create() {
    final ds   = AIRecommendationRemoteDataSource();
    final repo = AIRecommendationRepositoryImpl(ds);
    return AIRecommendationBloc(
      getContext: GetRecommendationContextUseCase(repo),
      generate:   GenerateMealRecommendationUseCase(repo),
      consume:    ConsumeRecommendedMealUseCase(repo),
    );
  }

  Future<void> _onLoadContext(
    LoadRecommendationContext event,
    Emitter<AIRecommendationState> emit,
  ) async {
    emit(const AIRecommendationLoadingContext());
    try {
      final ctx = await _getContext.execute();
      emit(AIRecommendationContextLoaded(ctx));
    } catch (e) {
      emit(AIRecommendationError(e.toString()));
    }
  }

  Future<void> _onGenerate(
    GenerateRecommendation event,
    Emitter<AIRecommendationState> emit,
  ) async {
    final currentCtx = _extractContext(state);
    if (currentCtx == null) return;

    emit(AIRecommendationGenerating(currentCtx));
    try {
      final rec = await _generate.execute(
        userId:               currentCtx.userId,
        availableIngredients: event.availableIngredients,
        overrideMealType:     event.overrideMealType,
      );
      emit(AIRecommendationLoaded(context: currentCtx, recommendation: rec));
    } catch (e) {
      emit(AIRecommendationError(e.toString(), context: currentCtx));
    }
  }

  Future<void> _onConsume(
    ConsumeRecommendation event,
    Emitter<AIRecommendationState> emit,
  ) async {
    final currentCtx = _extractContext(state);
    if (currentCtx == null) return;

    emit(AIRecommendationConsuming(
      context:        currentCtx,
      recommendation: event.recommendation,
    ));
    try {
      await _consume.execute(event.recommendation);
      final updatedCtx = await _getContext.execute();
      emit(AIRecommendationConsumed(updatedCtx));
    } catch (e) {
      emit(AIRecommendationError(e.toString(), context: currentCtx));
    }
  }

  Future<void> _onRefresh(
    RefreshRecommendation event,
    Emitter<AIRecommendationState> emit,
  ) async {
    add(const LoadRecommendationContext());
  }

  _extractContext(AIRecommendationState s) {
    if (s is AIRecommendationContextLoaded) return s.context;
    if (s is AIRecommendationGenerating)    return s.context;
    if (s is AIRecommendationLoaded)        return s.context;
    if (s is AIRecommendationConsuming)     return s.context;
    if (s is AIRecommendationConsumed)      return s.context;
    if (s is AIRecommendationError)         return s.context;
    return null;
  }
}