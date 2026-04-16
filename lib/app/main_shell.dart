import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/meal_analysis/presentation/screens/analyze_screen.dart';
import '../features/history/presentation/screens/history_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
 
class MainShell extends StatefulWidget {
  const MainShell({super.key});
 
  @override
  State<MainShell> createState() => _MainShellState();
}
 
class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
 
  final _pages = const [
    HomeScreen(),
    AnalyzeScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(index: 0, icon: Icons.home_rounded,          currentIndex: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
              _NavItem(index: 1, icon: Icons.camera_alt_outlined,   currentIndex: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
              _NavItem(index: 2, icon: Icons.bar_chart_rounded,     currentIndex: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
              _NavItem(index: 3, icon: Icons.person_outline_rounded, currentIndex: _currentIndex, onTap: (i) => setState(() => _currentIndex = i)),
            ],
          ),
        ),
      ),
    );
  }
}
 
class _NavItem extends StatelessWidget {
  final int index;
  final IconData icon;
  final int currentIndex;
  final ValueChanged<int> onTap;
 
  const _NavItem({required this.index, required this.icon, required this.currentIndex, required this.onTap});
 
  @override
  Widget build(BuildContext context) {
    final active = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: active ? kOrange : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: active ? kWhite : kDark, size: 24),
      ),
    );
  }
}