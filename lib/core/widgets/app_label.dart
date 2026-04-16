import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
 
class AppLabel extends StatelessWidget {
  final String text;
 
  const AppLabel(this.text, {super.key});
 
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontWeight: FontWeight.w600, fontSize: 14, color: kDark));
  }
}