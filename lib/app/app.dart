import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
 
class FitnessLifeApp extends StatelessWidget {
  const FitnessLifeApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Life',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const SplashScreen(),
    );
  }
}