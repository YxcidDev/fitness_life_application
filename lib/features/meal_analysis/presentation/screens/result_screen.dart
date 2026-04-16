import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../domain/entities/meal.dart';
import '../bloc/meal_analysis_bloc.dart';
import '../bloc/meal_analysis_event.dart';
import '../bloc/meal_analysis_state.dart';
import '../widgets/food_breakdown.dart';
import '../../../../core/widgets/success_overlay.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MealAnalysisBloc, MealAnalysisState>(
      listener: (ctx, state) async {
        // En el listener de ResultScreen, reemplaza el showDialog existente:
        if (state is MealSavedSuccess) {
          showDialog(
            context: ctx,
            barrierDismissible: false,
            barrierColor: Colors.black.withOpacity(
              0.55,
            ), // 👈 esto da el fondo oscuro real
            builder: (_) =>
                const SuccessOverlay(message: 'Comida guardada correctamente'),
          );

          await Future.delayed(const Duration(seconds: 2));
          Navigator.pop(ctx); // cierra el dialog
          Navigator.pop(ctx); // regresa a la pantalla anterior
          ctx.read<MealAnalysisBloc>().add(ResetAnalysisEvent());
        }
        if (state is MealAnalysisError) {
          ScaffoldMessenger.of(
            ctx,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (ctx, state) {
        if (state is! MealAnalysisSuccess) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: kOrange)),
          );
        }
        return _ResultBody(meal: state.meal, imageFile: state.imageFile);
      },
    );
  }
}

class _ResultBody extends StatefulWidget {
  final Meal meal;
  final File imageFile;
  const _ResultBody({required this.meal, required this.imageFile});

  @override
  State<_ResultBody> createState() => _ResultBodyState();
}

class _ResultBodyState extends State<_ResultBody> {
  String _selectedType = 'lunch';

  final _mealTypes = const [
    ('breakfast', 'Desayuno'),
    ('lunch', 'Almuerzo'),
    ('dinner', 'Cena'),
    ('snack', 'Merienda'),
  ];

  @override
  Widget build(BuildContext context) {
    final meal = widget.meal;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 200,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(widget.imageFile, fit: BoxFit.cover),
                    Container(color: Colors.black.withOpacity(0.25)),
                    Positioned(
                      bottom: 12,
                      left: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Análisis nutricional completado',
                          style: TextStyle(color: kWhite, fontSize: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Resumen nutricional',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: kDark,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.refresh_rounded,
                            color: kOrange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: kOrange,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Total de calorías',
                                  style: TextStyle(color: kWhite, fontSize: 13),
                                ),
                                Text(
                                  meal.calories.toStringAsFixed(0),
                                  style: const TextStyle(
                                    color: kWhite,
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'kcal en este plato',
                                  style: TextStyle(color: kWhite, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 70,
                            height: 70,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: 0.5,
                                  strokeWidth: 6,
                                  backgroundColor: kWhite.withOpacity(0.3),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        kWhite,
                                      ),
                                ),
                                const Text(
                                  '50%',
                                  style: TextStyle(
                                    color: kWhite,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '¿Qué comida es esta?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: kDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: _mealTypes.map((t) {
                        final (type, label) = t;
                        final active = _selectedType == type;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedType = type),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: active ? kOrange : kLightGrey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  label,
                                  style: TextStyle(
                                    color: active ? kWhite : kGrey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Desgloce por alimento',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: kDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...meal.items.map((item) => FoodBreakdown(item: item)),
                    const SizedBox(height: 20),
                    BlocBuilder<MealAnalysisBloc, MealAnalysisState>(
                      builder: (ctx, state) {
                        if (state is MealAnalysisLoading) {
                          return const Center(
                            child: CircularProgressIndicator(color: kOrange),
                          );
                        }
                        return AppButton(
                          label: 'Guardar comida',
                          onTap: () => ctx.read<MealAnalysisBloc>().add(
                            SaveMealEvent(_selectedType),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
