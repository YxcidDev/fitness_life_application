import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
 
class StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool orange;
 
  const StatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    this.orange = false,
  });
 
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: orange ? kOrangeBg : kWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: orange
            ? null
            : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: orange ? kOrange : kDark),
          const SizedBox(height: 6),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: orange ? kOrange : kDark)),
          Text(label,
              style: TextStyle(
                  color: orange ? kOrange : kGrey, fontSize: 12)),
        ],
      ),
    );
  }
}