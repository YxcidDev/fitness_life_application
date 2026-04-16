import 'food_item.dart';
 
class Meal {
  final String id;
  final String mealName;
  final double calories;
  final double proteins;
  final double carbs;
  final double fats;
  final List<FoodItem> items;
  final DateTime analyzedAt;
  final String? imageUrl;
 
  const Meal({
    required this.id,
    required this.mealName,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
    required this.items,
    required this.analyzedAt,
    this.imageUrl,
  });
}