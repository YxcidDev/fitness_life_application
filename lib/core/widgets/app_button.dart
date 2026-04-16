import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
 
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
 
  const AppButton({super.key, required this.label, required this.onTap});
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: kOrange,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(label,
              style: const TextStyle(
                  color: kWhite, fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    );
  }
}