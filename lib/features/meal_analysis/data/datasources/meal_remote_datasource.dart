import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../../core/supabase/supabase_client.dart';
import '../../../../core/config/env.dart';
import '../models/meal_model.dart';
import '../models/food_item_model.dart';
 
class MealRemoteDataSource {
 
  Future<MealModel> analyzeFromImage(File image) async {
    final bytes  = await image.readAsBytes();
    final base64 = base64Encode(bytes);
 
    final response = await http.post(
      Uri.parse(Env.webhookUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'image': base64}),
    );
 
    if (response.statusCode != 200) {
      throw Exception('Error del webhook: ${response.statusCode}');
    }
 
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return MealModel.fromJson(json);
  }
 
  Future<void> saveMeal(MealModel meal, String mealType) async {
    final userId = supabase.auth.currentUser!.id;
 
    final inserted = await supabase.from('meals').insert({
      'user_id':     userId,
      'meal_type':   mealType,
      'meal_name':   meal.mealName,
      'image_url':   meal.imageUrl,
      'calories':    meal.calories,
      'proteins':    meal.proteins,
      'carbs':       meal.carbs,
      'fats':        meal.fats,
      'analyzed_at': meal.analyzedAt.toIso8601String(),
    }).select().single();
 
    final mealId = inserted['id'] as String;
 
    final itemRows = meal.items.map((item) {
      final m = item as FoodItemModel;
      return {
        'meal_id':  mealId,
        'name':     m.name,
        'grams':    m.grams,
        'calories': m.calories,
        'proteins': m.proteins,
        'carbs':    m.carbs,
        'fats':     m.fats,
      };
    }).toList();
 
    await supabase.from('meal_items').insert(itemRows);
  }
}