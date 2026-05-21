import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/supabase/supabase_client.dart';
import '../models/meal_recommendation_model.dart';
import '../models/nutrition_context_model.dart';

const _kN8nRecommendationWebhook =
    'WEBHOOK_URL';

class AIRecommendationRemoteDataSource {

  String normalizeMealType(String value) {
    switch (value.toLowerCase().trim()) {
      case 'desayuno':
      case 'breakfast':
        return 'breakfast';

      case 'almuerzo':
      case 'lunch':
        return 'lunch';

      case 'cena':
      case 'dinner':
        return 'dinner';

      case 'snack':
      case 'merienda':
        return 'snack';

      default:
        return 'lunch';
    }
  }

  Future<NutritionContextModel> getRecommendationContext() async {
    final userId = supabase.auth.currentUser!.id;

    final now = DateTime.now();

    final start =
        DateTime(now.year, now.month, now.day).toIso8601String();

    final end =
        DateTime(now.year, now.month, now.day, 23, 59, 59)
            .toIso8601String();

    final meals = await supabase
        .from('meals')
        .select('meal_type, calories, proteins, carbs, fats')
        .eq('user_id', userId)
        .gte('analyzed_at', start)
        .lte('analyzed_at', end);

    final goals = await supabase
        .from('daily_goals')
        .select()
        .eq('user_id', userId)
        .single();

    final profile = await supabase
        .from('user_profiles')
        .select('goal')
        .eq('id', userId)
        .single();

    return NutritionContextModel.fromSupabase(
      meals: List<Map<String, dynamic>>.from(meals as List),
      goals: goals,
      profile: profile,
      userId: userId,
    );
  }

  Future<MealRecommendationModel> generateRecommendation({
    required String userId,
    required List<String> availableIngredients,
    String? overrideMealType,
  }) async {

    final body = jsonEncode({
      'user_id': userId,
      'available_ingredients': availableIngredients,
      if (overrideMealType != null)
        'meal_type_override': overrideMealType,
    });

    final response = await http.post(
      Uri.parse(_kN8nRecommendationWebhook),
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception(
        'n8n webhook error: ${response.statusCode}\n${response.body}',
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is List && decoded.isNotEmpty) {

      final firstItem = decoded.first;

      if (firstItem is Map<String, dynamic> &&
          firstItem.containsKey('output')) {

        final output =
            Map<String, dynamic>.from(firstItem['output']);

        return MealRecommendationModel.fromJson(output);
      }
    }

    if (decoded is Map<String, dynamic>) {
      return MealRecommendationModel.fromJson(decoded);
    }

    throw Exception(
      'Formato de respuesta inválido desde n8n.',
    );
  }

  Future<void> consumeRecommendedMeal(
    MealRecommendationModel rec,
  ) async {

    final userId = supabase.auth.currentUser!.id;

    final normalizedMealType =
        normalizeMealType(rec.mealType);

    final mealRow = await supabase
        .from('meals')
        .insert({
          'user_id': userId,
          'meal_type': normalizedMealType,
          'meal_name': rec.mealName,
          'calories': rec.calories,
          'proteins': rec.protein,
          'carbs': rec.carbs,
          'fats': rec.fat,
          'is_ai_generated': true,
          'recommendation_reason': rec.reason,
        })
        .select('id')
        .single();

    final mealId = mealRow['id'] as String;

    final items = rec.ingredients
        .map((name) => {
              'meal_id': mealId,
              'name': name,
              'grams': 0.0,
              'calories': 0.0,
              'proteins': 0.0,
              'carbs': 0.0,
              'fats': 0.0,
            })
        .toList();

    if (items.isNotEmpty) {
      await supabase
          .from('meal_items')
          .insert(items);
    }
  }
}