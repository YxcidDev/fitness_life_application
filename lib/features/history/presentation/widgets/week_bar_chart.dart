import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
 
class WeekBarChart extends StatelessWidget {
  final List<double> values; // 7 valores, uno por día
  final double maxValue;
 
  const WeekBarChart({
    super.key,
    required this.values,
    required this.maxValue,
  });
 
  static const _days = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Hoy'];
 
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (i) {
          final isToday  = i == 6;
          final fraction = maxValue == 0 ? 0.0 : (values[i] / maxValue).clamp(0.0, 1.0);
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 28,
                    height: 60 * fraction,
                    decoration: BoxDecoration(
                      color: isToday ? kOrange : kOrangeBg,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(_days[i],
                  style: TextStyle(
                      fontSize: 11,
                      color: isToday ? kOrange : kGrey,
                      fontWeight:
                          isToday ? FontWeight.bold : FontWeight.normal)),
            ],
          );
        }),
      ),
    );
  }
}