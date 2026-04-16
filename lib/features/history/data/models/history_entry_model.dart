import '../../domain/entities/history_entry.dart';
 
class HistoryEntryModel extends HistoryEntry {
  const HistoryEntryModel({
    required super.id,
    required super.mealType,
    required super.mealName,
    required super.calories,
    required super.proteins,
    required super.carbs,
    required super.fats,
    required super.analyzedAt,
    super.imageUrl,
  });
 
  factory HistoryEntryModel.fromJson(Map<String, dynamic> json) {
    return HistoryEntryModel(
      id:         json['id']        as String,
      mealType:   json['meal_type'] as String,
      mealName:   json['meal_name'] as String,
      calories:   (json['calories'] as num).toDouble(),
      proteins:   (json['proteins'] as num).toDouble(),
      carbs:      (json['carbs']    as num).toDouble(),
      fats:       (json['fats']     as num).toDouble(),
      analyzedAt: DateTime.parse(json['analyzed_at'] as String),
      imageUrl:   json['image_url'] as String?,
    );
  }
}