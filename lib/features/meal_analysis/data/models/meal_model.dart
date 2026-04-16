import '../../domain/entities/meal.dart';
import 'food_item_model.dart';
 
class MealModel extends Meal {
  const MealModel({
    required super.id,
    required super.mealName,
    required super.calories,
    required super.proteins,
    required super.carbs,
    required super.fats,
    required super.items,
    required super.analyzedAt,
    super.imageUrl,
  });
 
  factory MealModel.fromJson(Map<String, dynamic> json) {
    final nutrients = json['nutrients'] as Map<String, dynamic>;
    final itemsList = (json['items'] as List)
        .map((e) => FoodItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
 
    return MealModel(
      id:          DateTime.now().millisecondsSinceEpoch.toString(),
      mealName:    json['meal_name']   as String,
      calories:    (nutrients['calories'] as num).toDouble(),
      proteins:    (nutrients['proteins'] as num).toDouble(),
      carbs:       (nutrients['carbs']    as num).toDouble(),
      fats:        (nutrients['fats']     as num).toDouble(),
      items:       itemsList,
      analyzedAt:  DateTime.tryParse(json['analyzed_at'] as String? ?? '') ?? DateTime.now(),
      imageUrl:    json['image_url']   as String?,
    );
  }
}