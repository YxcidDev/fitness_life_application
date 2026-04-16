import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/home_summary.dart';
import '../../data/datasources/home_remote_datasource.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/usecases/get_home_summary_usecase.dart';
import '../widgets/calorie_card.dart';
import '../widgets/macro_card.dart';
import '../widgets/meal_slot.dart';
 
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
 
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
 
class _HomeScreenState extends State<HomeScreen> {
  late final GetHomeSummaryUseCase _useCase;
  HomeSummary? _summary;
  bool _loading = true;
 
  @override
  void initState() {
    super.initState();
    _useCase = GetHomeSummaryUseCase(
        HomeRepositoryImpl(HomeRemoteDataSource()));
    _load();
  }
 
  Future<void> _load() async {
    try {
      final summary = await _useCase.execute();
      if (mounted) setState(() { _summary = summary; _loading = false; });
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }
 
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: kOrange)),
      );
    }
 
    final s = _summary;
    if (s == null) {
      return const Scaffold(
        body: Center(child: Text('Error cargando datos')),
      );
    }
 
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Buenos días' : hour < 18 ? 'Buenas tardes' : 'Buenas noches';
 
    return SafeArea(
      child: RefreshIndicator(
        color: kOrange,
        onRefresh: _load,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$greeting,',
                              style: const TextStyle(color: kGrey, fontSize: 13)),
                          Text(s.userName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: kDark)),
                        ],
                      ),
                    ),
                    const Icon(Icons.notifications_none_rounded,
                        size: 26, color: kDark),
                    const SizedBox(width: 12),
                    Container(
                      width: 40, height: 40,
                      decoration: const BoxDecoration(
                          color: kOrange, shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          s.userName.isNotEmpty
                              ? s.userName[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                              color: kWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CalorieCard(summary: s),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: MacroCard(
                        icon: Icons.fitness_center,
                        value: '${s.proteinsConsumed.toStringAsFixed(0)}g',
                        label: 'Proteína',
                        percent: s.proteinsPercent,
                        percentLabel: '${(s.proteinsPercent * 100).toStringAsFixed(0)}%',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MacroCard(
                        icon: Icons.rice_bowl_outlined,
                        value: '${s.carbsConsumed.toStringAsFixed(0)}g',
                        label: 'Carbs',
                        percent: s.carbsPercent,
                        percentLabel: '${(s.carbsPercent * 100).toStringAsFixed(0)}%',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MacroCard(
                        icon: Icons.water_drop_outlined,
                        value: '${s.fatsConsumed.toStringAsFixed(0)}g',
                        label: 'Grasas',
                        percent: s.fatsPercent,
                        percentLabel: '${(s.fatsPercent * 100).toStringAsFixed(0)}%',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Expanded(
                        child: Text('Comidas de hoy',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: kDark))),
                    TextButton(
                      onPressed: () {},
                      child: const Text('+ Añadir',
                          style: TextStyle(color: kOrange, fontSize: 14)),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  children: [
                    _buildMealSlot(s, 'breakfast', Icons.egg_outlined,        'Desayuno'),
                    const SizedBox(height: 10),
                    _buildMealSlot(s, 'lunch',     Icons.restaurant_outlined,  'Almuerzo'),
                    const SizedBox(height: 10),
                    _buildMealSlot(s, 'dinner',    Icons.dinner_dining_outlined,'Cena'),
                    const SizedBox(height: 10),
                    _buildMealSlot(s, 'snack',     Icons.cookie_outlined,       'Merienda'),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
 
  Widget _buildMealSlot(HomeSummary s, String type, IconData icon, String label) {
    final registered = s.registeredMealTypes.contains(type);
    return MealSlot(
      icon:    icon,
      title:   label,
      isEmpty: !registered,
    );
  }
}