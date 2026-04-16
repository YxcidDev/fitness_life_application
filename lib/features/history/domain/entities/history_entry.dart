class HistoryEntry {
  final String id;
  final String mealType;
  final String mealName;
  final double calories;
  final double proteins;
  final double carbs;
  final double fats;
  final DateTime analyzedAt;
  final String? imageUrl;
 
  const HistoryEntry({
    required this.id,
    required this.mealType,
    required this.mealName,
    required this.calories,
    required this.proteins,
    required this.carbs,
    required this.fats,
    required this.analyzedAt,
    this.imageUrl,
  });
}