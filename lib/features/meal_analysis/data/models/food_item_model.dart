import '../../domain/entities/food_item.dart';
 
class FoodItemModel extends FoodItem {
  const FoodItemModel({
    required super.name,
    required super.grams,
    required super.calories,
    required super.proteins,
    required super.carbs,
    required super.fats,
  });
 
  factory FoodItemModel.fromJson(Map<String, dynamic> json) {
    return FoodItemModel(
      name:     json['name']     as String,
      grams:    (json['grams']    as num).toDouble(),
      calories: (json['calories'] as num).toDouble(),
      proteins: (json['proteins'] as num).toDouble(),
      carbs:    (json['carbs']    as num).toDouble(),
      fats:     (json['fats']     as num).toDouble(),
    );
  }
 
  Map<String, dynamic> toJson() => {
    'name':     name,
    'grams':    grams,
    'calories': calories,
    'proteins': proteins,
    'carbs':    carbs,
    'fats':     fats,
  };
}