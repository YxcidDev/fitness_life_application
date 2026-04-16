import 'package:flutter/material.dart';
 
class DumbbellIcon extends StatelessWidget {
  final double size;
  final Color color;
 
  const DumbbellIcon({super.key, required this.size, required this.color});
 
  @override
  Widget build(BuildContext context) {
    return Icon(Icons.fitness_center, size: size, color: color);
  }
}