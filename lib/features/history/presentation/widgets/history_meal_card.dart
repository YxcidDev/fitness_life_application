import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/history_entry.dart';
 
class HistoryMealCard extends StatelessWidget {
  final HistoryEntry entry;
 
  const HistoryMealCard({super.key, required this.entry});
 
  IconData get _icon {
    return switch (entry.mealType) {
      'breakfast' => Icons.egg_outlined,
      'lunch'     => Icons.restaurant_outlined,
      'dinner'    => Icons.dinner_dining_outlined,
      _           => Icons.cookie_outlined,
    };
  }
 
  String get _timeLabel {
    final h = entry.analyzedAt.hour.toString().padLeft(2, '0');
    final m = entry.analyzedAt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
                color: kLightGrey, borderRadius: BorderRadius.circular(12)),
            child: Icon(_icon, color: kDark, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entry.mealName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: kDark)),
                const SizedBox(height: 2),
                Text('$_timeLabel · ${entry.calories.toStringAsFixed(0)} kcal',
                    style: const TextStyle(color: kGrey, fontSize: 12)),
              ],
            ),
          ),
          Text('${entry.proteins.toStringAsFixed(0)}g prot',
              style: const TextStyle(
                  color: kOrange,
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
        ],
      ),
    );
  }
}