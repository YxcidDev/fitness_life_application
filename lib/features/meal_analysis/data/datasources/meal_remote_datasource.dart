import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import '../../../../core/supabase/supabase_client.dart';
import '../../../../core/config/env.dart';
import '../models/meal_model.dart';
import '../models/food_item_model.dart';

class MealRemoteDataSource {
  static const String _webhookUrl =
      'http://10.0.2.2:5678/webhook-test/3e473ea5-b834-4bb4-a0f3-527c77028958';

  Future<MealModel> analyzeFromImage(File image) async {
    try {
      final bytes = await image.readAsBytes();
      final base64 = base64Encode(bytes);

      final response = await http
          .post(
            Uri.parse(_webhookUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'image': base64}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception('webhook_http_${response.statusCode}');
      }

      final decoded = jsonDecode(response.body);

      final Map<String, dynamic> json;
      if (decoded is List && decoded.isNotEmpty) {
        json = Map<String, dynamic>.from(decoded.first as Map);
      } else if (decoded is Map<String, dynamic>) {
        json = decoded;
      } else {
        throw Exception('webhook_bad_format');
      }

      if (json.containsKey('error') ||
          json.containsKey('message') &&
              json['message'].toString().toLowerCase().contains('no food')) {
        throw Exception('ai_unreadable');
      }

      return MealModel.fromJson(json);
    } on SocketException {
      rethrow;
    } on Exception {
      rethrow;
    } catch (_) {
      throw Exception('webhook_bad_format');
    }
  }

  Future<void> saveMeal(MealModel meal, String mealType) async {
    final userId = supabase.auth.currentUser!.id;

    final inserted = await supabase
        .from('meals')
        .insert({
          'user_id': userId,
          'meal_type': mealType,
          'meal_name': meal.mealName,
          'image_url': meal.imageUrl,
          'calories': meal.calories,
          'proteins': meal.proteins,
          'carbs': meal.carbs,
          'fats': meal.fats,
          'analyzed_at': DateTime.now().toIso8601String(),
        })
        .select()
        .single();

    final mealId = inserted['id'] as String;

    final itemRows = meal.items.map((item) {
      final m = item as FoodItemModel;
      return {
        'meal_id': mealId,
        'name': m.name,
        'grams': m.grams,
        'calories': m.calories,
        'proteins': m.proteins,
        'carbs': m.carbs,
        'fats': m.fats,
      };
    }).toList();

    await supabase.from('meal_items').insert(itemRows);
  }
}
