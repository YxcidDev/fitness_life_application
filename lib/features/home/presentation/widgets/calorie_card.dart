import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/home_summary.dart';
 
class CalorieCard extends StatelessWidget {
  final HomeSummary summary;
 
  const CalorieCard({super.key, required this.summary});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: kOrange, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Calorías hoy',
              style: TextStyle(color: kWhite, fontSize: 14)),
          const SizedBox(height: 4),
          Text(summary.caloriesConsumed.toStringAsFixed(0),
              style: const TextStyle(
                  color: kWhite,
                  fontSize: 44,
                  fontWeight: FontWeight.bold)),
          Text('de ${summary.caloriesGoal.toStringAsFixed(0)} kcal meta diaria',
              style: const TextStyle(color: kWhite, fontSize: 13)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: summary.caloriesPercent,
              backgroundColor: kWhite.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(kWhite),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: 100, height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: summary.caloriesPercent,
                    strokeWidth: 8,
                    backgroundColor: kWhite.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(kWhite),
                  ),
                  Text(
                    '${(summary.caloriesPercent * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                        color: kWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
              child: Text('Completado',
                  style: TextStyle(color: kWhite, fontSize: 13))),
        ],
      ),
    );
  }
}