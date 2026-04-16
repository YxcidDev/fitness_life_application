import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
 
class MacroCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final double percent;
  final String percentLabel;
 
  const MacroCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.percent,
    required this.percentLabel,
  });
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 20, color: kDark),
              Text(percentLabel,
                  style: const TextStyle(fontSize: 11, color: kGrey)),
            ],
          ),
          const SizedBox(height: 6),
          Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16, color: kDark)),
          Text(label,
              style: const TextStyle(color: kGrey, fontSize: 12)),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percent,
            backgroundColor: kLightGrey,
            valueColor: const AlwaysStoppedAnimation<Color>(kOrange),
            minHeight: 3,
          ),
        ],
      ),
    );
  }
}