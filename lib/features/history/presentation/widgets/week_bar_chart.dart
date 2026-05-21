import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class BarChartData {
  final String label;
  final double value;
  final bool highlight;

  const BarChartData({
    required this.label,
    required this.value,
    this.highlight = false,
  });
}

class WeekBarChart extends StatelessWidget {
  final List<BarChartData> bars;
  final double maxValue;

  const WeekBarChart({
    super.key,
    required this.bars,
    required this.maxValue,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: bars.map((bar) {
          final fraction = maxValue == 0
              ? 0.0
              : (bar.value / maxValue).clamp(0.0, 1.0);
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
                      color: bar.highlight ? kOrange : kOrangeBg,
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                bar.label,
                style: TextStyle(
                  fontSize: 11,
                  color: bar.highlight ? kOrange : kGrey,
                  fontWeight:
                      bar.highlight ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}