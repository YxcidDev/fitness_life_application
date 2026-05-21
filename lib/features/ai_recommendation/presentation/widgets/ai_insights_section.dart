import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/ai_recommendation_bloc.dart';
import '../bloc/ai_recommendation_event.dart';
import '../bloc/ai_recommendation_state.dart';
import 'recommendation_card.dart';

class AIInsightsSection extends StatelessWidget {
  final VoidCallback? onMealConsumed;

  const AIInsightsSection({
    super.key,
    this.onMealConsumed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AIRecommendationBloc.create()
            ..add(const LoadRecommendationContext()),
      child: _AIInsightsSectionContent(
        onMealConsumed: onMealConsumed,
      ),
    );
  }
}

class _AIInsightsSectionContent extends StatelessWidget {
  final VoidCallback? onMealConsumed;

  const _AIInsightsSectionContent({this.onMealConsumed});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AIRecommendationBloc, AIRecommendationState>(
      listener: (context, state) {
        if (state is AIRecommendationConsumed) {
          onMealConsumed?.call();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Asistente IA',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: kDark),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Recomendaciones personalizadas',
                      style: TextStyle(color: kGrey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              BlocBuilder<AIRecommendationBloc, AIRecommendationState>(
                builder: (ctx, state) => IconButton(
                  onPressed: state is AIRecommendationLoadingContext
                      ? null
                      : () => ctx
                          .read<AIRecommendationBloc>()
                          .add(const RefreshRecommendation()),
                  icon:
                      const Icon(Icons.refresh, color: kGrey, size: 20),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          const RecommendationCard(),
        ],
      ),
    );
  }
}