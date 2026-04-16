import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
 
class AppInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final TextInputType keyboardType;
  final Widget? suffix;
 
  const AppInput({
    super.key,
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.suffix,
  });
 
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kLightGrey,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: kGrey),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          suffixIcon: suffix,
        ),
      ),
    );
  }
}