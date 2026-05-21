import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/datasources/history_remote_datasource.dart';
import '../../data/repositories/history_repository_impl.dart';
import '../../domain/entities/history_entry.dart';
import '../../domain/usecases/get_history_usecase.dart';
import '../../domain/usecases/get_summary_by_range_usecase.dart';
import '../widgets/history_meal_card.dart';
import '../widgets/stat_card.dart';
import '../widgets/week_bar_chart.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late final GetHistoryUseCase         _historyUseCase;
  late final GetSummaryByRangeUseCase  _summaryUseCase;

  List<HistoryEntry>  _entries = [];
  Map<String, double> _summary = {};
  List<BarChartData>  _bars    = [];
  double              _maxBar  = 0;
  bool  _loading               = true;
  int   _filterIndex           = 0;
  final _filters = ['Esta semana', 'Este mes', '3 meses', 'Todas'];

  @override
  void initState() {
    super.initState();
    final repo = HistoryRepositoryImpl(HistoryRemoteDataSource());
    _historyUseCase = GetHistoryUseCase(repo);
    _summaryUseCase = GetSummaryByRangeUseCase(repo);
    _load();
  }

  (DateTime, DateTime) get _range {
    final now   = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return switch (_filterIndex) {
      0 => ( 
        today.subtract(Duration(days: today.weekday - 1 + (now.weekday - 1))),
        today,
      ),
      1 => (DateTime(now.year, now.month, 1), today),
      2 => (today.subtract(const Duration(days: 90)), today),
      _ => (DateTime(2000), today),
    };
  }

  List<BarChartData> _buildBars(List<HistoryEntry> entries) {
    final now = DateTime.now();

    if (_filterIndex == 0) {
      const labels = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
      final monday = now.subtract(Duration(days: now.weekday - 1));
      return List.generate(7, (i) {
        final day = DateTime(monday.year, monday.month, monday.day + i);
        final cal = entries
            .where((e) =>
                e.analyzedAt.year  == day.year &&
                e.analyzedAt.month == day.month &&
                e.analyzedAt.day   == day.day)
            .fold(0.0, (sum, e) => sum + e.calories);
        final isToday = day.day == now.day &&
            day.month == now.month &&
            day.year  == now.year;
        return BarChartData(
          label:     isToday ? 'Hoy' : labels[i],
          value:     cal,
          highlight: isToday,
        );
      });
    }

    if (_filterIndex == 1) {
      final weeksInMonth = <String, double>{};
      for (final e in entries) {
        final week = 'Sem ${((e.analyzedAt.day - 1) ~/ 7) + 1}';
        weeksInMonth[week] = (weeksInMonth[week] ?? 0) + e.calories;
      }
      final sorted = weeksInMonth.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));
      final currentWeek = 'Sem ${((now.day - 1) ~/ 7) + 1}';
      return sorted.map((e) => BarChartData(
        label:     e.key,
        value:     e.value,
        highlight: e.key == currentWeek,
      )).toList();
    }

    final byMonth = <String, double>{};
    const monthNames = ['', 'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
                             'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
    for (final e in entries) {
      final key = '${monthNames[e.analyzedAt.month]} ${e.analyzedAt.year}';
      byMonth[key] = (byMonth[key] ?? 0) + e.calories;
    }
    final sorted = byMonth.entries.toList()
      ..sort((a, b) {
        final aDate = entries.firstWhere((e) =>
            monthNames[e.analyzedAt.month] == a.key.split(' ')[0]).analyzedAt;
        final bDate = entries.firstWhere((e) =>
            monthNames[e.analyzedAt.month] == b.key.split(' ')[0]).analyzedAt;
        return aDate.compareTo(bDate);
      });
    final currentMonth = '${monthNames[now.month]} ${now.year}';
    return sorted.map((e) => BarChartData(
      label:     e.key.split(' ')[0],
      value:     e.value,
      highlight: e.key == currentMonth,
    )).toList();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final (from, to) = _range;
      final entries = await _historyUseCase.execute();
      final filtered = entries.where((e) =>
          e.analyzedAt.isAfter(from.subtract(const Duration(seconds: 1))) &&
          e.analyzedAt.isBefore(to.add(const Duration(seconds: 1)))).toList();
      final summary = await _summaryUseCase.execute(from, to);
      final bars    = _buildBars(filtered);
      final maxBar  = bars.isEmpty ? 0.0
          : bars.map((b) => b.value).reduce((a, b) => a > b ? a : b);

      if (mounted) {
        setState(() {
          _entries  = filtered;
          _summary  = summary;
          _bars     = bars;
          _maxBar   = maxBar == 0 ? 1 : maxBar;
          _loading  = false;
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

  String get _chartTitle => switch (_filterIndex) {
    0 => 'Calorías esta semana',
    1 => 'Calorías este mes',
    2 => 'Calorías — últimos 3 meses',
    _ => 'Calorías — todo el historial',
  };

  String get _avgLabel {
    final cal = _summary['calories'] ?? 0;
    return switch (_filterIndex) {
      0 => 'Promedio: ${(cal / 7).toStringAsFixed(0)} kcal/día',
      1 => 'Promedio: ${(cal / 4).toStringAsFixed(0)} kcal/sem',
      2 => 'Promedio: ${(cal / 3).toStringAsFixed(0)} kcal/mes',
      _ => 'Total: ${cal.toStringAsFixed(0)} kcal',
    };
  }

  String get _statLabel => switch (_filterIndex) {
    0 => 'kcal esta semana',
    1 => 'kcal este mes',
    2 => 'kcal en 3 meses',
    _ => 'kcal totales',
  };

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: kOrange)),
      );
    }

    final grouped        = _grouped;
    final weeklyCalories = _summary['calories']   ?? 0;
    final mealsCount     = (_summary['mealsCount'] ?? 0).toInt();
    final weeklyProteins = _summary['proteins']   ?? 0;

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
                      onTap: () {
                        setState(() => _filterIndex = i);
                        _load();
                      },
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
                    Text(_chartTitle,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: kDark)),
                    const SizedBox(height: 16),
                    _bars.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Text('Sin datos',
                                  style: TextStyle(color: kGrey)),
                            ),
                          )
                        : WeekBarChart(bars: _bars, maxValue: _maxBar),
                    const SizedBox(height: 8),
                    Text(_avgLabel,
                        style: const TextStyle(color: kGrey, fontSize: 12)),
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
                      label: _statLabel,
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