import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SuccessOverlay extends StatelessWidget {
  final String message;

  const SuccessOverlay({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    // Dialog con fondo transparente — la barrera oscura la maneja showDialog
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: kOrange,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, color: kWhite, size: 42),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: kDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}