import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/datasources/history_remote_datasource.dart';
import '../../data/repositories/history_repository_impl.dart';
import '../../domain/entities/history_entry.dart';
import '../../domain/usecases/get_history_usecase.dart';
import '../../domain/usecases/get_weekly_summary_usecase.dart';
import '../widgets/history_meal_card.dart';
import '../widgets/stat_card.dart';
import '../widgets/week_bar_chart.dart';
 
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
 
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}
 
class _HistoryScreenState extends State<HistoryScreen> {
  late final GetHistoryUseCase       _historyUseCase;
  late final GetWeeklySummaryUseCase _summaryUseCase;
 
  List<HistoryEntry>   _entries = [];
  Map<String, double>  _weekly  = {};
  bool _loading                 = true;
  int  _filterIndex             = 0;
  final _filters = ['Esta semana', 'Este mes', '3 meses', 'Todas'];
 
  @override
  void initState() {
    super.initState();
    final repo = HistoryRepositoryImpl(HistoryRemoteDataSource());
    _historyUseCase = GetHistoryUseCase(repo);
    _summaryUseCase = GetWeeklySummaryUseCase(repo);
    _load();
  }
 
  Future<void> _load() async {
    try {
      final entries = await _historyUseCase.execute();
      final weekly  = await _summaryUseCase.execute();
      if (mounted) {
        setState(() {
          _entries = entries;
          _weekly  = weekly;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Map<String, List<HistoryEntry>> get _grouped {
    final map = <String, List<HistoryEntry>>{};
    for (final e in _entries) {
      final now   = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final date  = DateTime(e.analyzedAt.year, e.analyzedAt.month, e.analyzedAt.day);
      final key   = date == today
          ? 'Hoy'
          : date == today.subtract(const Duration(days: 1))
              ? 'Ayer'
              : '${e.analyzedAt.day}/${e.analyzedAt.month}/${e.analyzedAt.year}';
      map.putIfAbsent(key, () => []).add(e);
    }
    return map;
  }
 
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: kOrange)),
      );
    }
 
    final grouped = _grouped;
    final weeklyCalories = _weekly['calories'] ?? 0;
    final mealsCount     = (_weekly['mealsCount'] ?? 0).toInt();
    final weeklyProteins = _weekly['proteins'] ?? 0;
 
    return SafeArea(
      child: RefreshIndicator(
        color: kOrange,
        onRefresh: _load,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Historial',
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: kDark)),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_filters.length, (i) {
                    final active = _filterIndex == i;
                    return GestureDetector(
                      onTap: () => setState(() => _filterIndex = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: active ? kOrange : kLightGrey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(_filters[i],
                            style: TextStyle(
                                color: active ? kWhite : kDark,
                                fontWeight: FontWeight.w500,
                                fontSize: 13)),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8)
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Calorías diarias',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: kDark)),
                    const SizedBox(height: 16),
                    WeekBarChart(
                      values: List.generate(7, (i) => 0),
                      maxValue: 2500,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Promedio: ${mealsCount > 0 ? (weeklyCalories / 7).toStringAsFixed(0) : 0} kcal',
                          style: const TextStyle(color: kGrey, fontSize: 12),
                        ),
                        const Text('Meta: 2,100 kcal',
                            style: TextStyle(color: kGrey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      icon: Icons.local_fire_department,
                      value: weeklyCalories.toStringAsFixed(0),
                      label: 'kcal esta semana',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatCard(
                      icon: Icons.restaurant_outlined,
                      value: mealsCount.toString(),
                      label: 'comidas registradas',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      icon: Icons.fitness_center,
                      value: '${weeklyProteins.toStringAsFixed(0)}g',
                      label: 'proteína total',
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: StatCard(
                      icon: Icons.emoji_events_outlined,
                      value: '0',
                      label: 'días con meta cumplida',
                      orange: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_entries.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('No hay comidas registradas aún',
                        style: TextStyle(color: kGrey)),
                  ),
                )
              else
                ...grouped.entries.map((group) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(group.key,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: kDark)),
                      const SizedBox(height: 10),
                      ...group.value.map(
                          (entry) => HistoryMealCard(entry: entry)),
                      const SizedBox(height: 16),
                    ],
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}