import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
 
class MealSlot extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;
  final bool isEmpty;
 
  const MealSlot({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle = '',
    this.amount = '',
    this.isEmpty = false,
  });
 
  @override
  Widget build(BuildContext context) {
    if (isEmpty) {
      return Container(
        height: 60,
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kLightGrey, width: 1.5),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(title,
              style: const TextStyle(color: kGrey, fontSize: 14)),
        ),
      );
    }
 
    return Container(
      padding: const EdgeInsets.all(14),
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
            child: Icon(icon, color: kDark, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: kDark)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(color: kGrey, fontSize: 12)),
              ],
            ),
          ),
          Text(amount,
              style: const TextStyle(
                  color: kOrange,
                  fontWeight: FontWeight.bold,
                  fontSize: 15)),
        ],
      ),
    );
  }
}