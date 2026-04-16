import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
 
class RegisterScaffold extends StatelessWidget {
  final int step;
  final String title;
  final String subtitle;
  final Widget child;
 
  const RegisterScaffold({
    super.key,
    required this.step,
    required this.title,
    required this.subtitle,
    required this.child,
  });
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.chevron_left, size: 28),
                  ),
                  Expanded(
                    child: Center(
                      child: Text('Paso $step de 3',
                          style: const TextStyle(fontSize: 15, color: kDark)),
                    ),
                  ),
                  const SizedBox(width: 28),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: kDark)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: const TextStyle(color: kGrey, fontSize: 14)),
                    const SizedBox(height: 12),
                    Row(
                      children: List.generate(3, (i) {
                        return Expanded(
                          child: Container(
                            height: 4,
                            margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
                            decoration: BoxDecoration(
                              color: i < step ? kOrange : kLightGrey,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                    child,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}