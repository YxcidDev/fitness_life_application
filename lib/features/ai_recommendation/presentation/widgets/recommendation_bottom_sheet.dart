import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/ai_recommendation_bloc.dart';
import '../bloc/ai_recommendation_event.dart';
import '../bloc/ai_recommendation_state.dart';
import 'recommendation_result_card.dart';

class RecommendationBottomSheet extends StatefulWidget {
  const RecommendationBottomSheet({super.key});

  @override
  State<RecommendationBottomSheet> createState() =>
      _RecommendationBottomSheetState();
}

class _RecommendationBottomSheetState
    extends State<RecommendationBottomSheet> {
  final _ingredientController = TextEditingController();
  final List<String> _ingredients = [];
  String? _selectedMealType;

  @override
  void dispose() {
    _ingredientController.dispose();
    super.dispose();
  }

  void _addIngredient() {
    final text = _ingredientController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _ingredients.add(text);
      _ingredientController.clear();
    });
  }

  void _removeIngredient(String item) {
    setState(() => _ingredients.remove(item));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AIRecommendationBloc, AIRecommendationState>(
      listener: (context, state) {},
      builder: (context, state) {
        final isGenerating = state is AIRecommendationGenerating;
        final isLoaded     = state is AIRecommendationLoaded;
        final isConsuming  = state is AIRecommendationConsuming;
        final isConsumed   = state is AIRecommendationConsumed;

        final ctx = switch (state) {
          AIRecommendationContextLoaded s => s.context,
          AIRecommendationGenerating s    => s.context,
          AIRecommendationLoaded s        => s.context,
          AIRecommendationConsuming s     => s.context,
          AIRecommendationConsumed s      => s.context,
          AIRecommendationError s         => s.context,
          _                               => null,
        };

        return Container(
          height: MediaQuery.of(context).size.height * 0.92,
          decoration: const BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: kLightGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: kOrange,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Text(
                        'IA',
                        style: TextStyle(
                            color: kWhite,
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Asistente Nutricional',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: kDark),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: kGrey),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (ctx != null) ...[
                        _sectionTitle('Contexto nutricional hoy'),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: kLightGrey,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  child: _ctxMacro('Calorías',
                                      '${ctx.remainingCalories.toStringAsFixed(0)} kcal')),
                              Expanded(
                                  child: _ctxMacro('Proteína',
                                      '${ctx.remainingProteins.toStringAsFixed(0)}g')),
                              Expanded(
                                  child: _ctxMacro('Carbs',
                                      '${ctx.remainingCarbs.toStringAsFixed(0)}g')),
                              Expanded(
                                  child: _ctxMacro('Grasas',
                                      '${ctx.remainingFats.toStringAsFixed(0)}g')),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      _sectionTitle('Tipo de comida'),
                      const SizedBox(height: 8),
                      if (ctx != null)
                        _MealTypeSelector(
                          suggested: ctx.suggestedMealType,
                          selected:  _selectedMealType,
                          onChanged: (v) =>
                              setState(() => _selectedMealType = v),
                        ),
                      const SizedBox(height: 20),

                      _sectionTitle('Ingredientes disponibles'),
                      const SizedBox(height: 4),
                      const Text(
                        'La IA los usará si es posible.',
                        style: TextStyle(color: kGrey, fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _ingredientController,
                              onSubmitted: (_) => _addIngredient(),
                              decoration: InputDecoration(
                                hintText: 'ej. Pollo, Arroz, Huevos...',
                                hintStyle: const TextStyle(
                                    color: kGrey, fontSize: 13),
                                contentPadding:
                                    const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      const BorderSide(color: kLightGrey),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      const BorderSide(color: kLightGrey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      const BorderSide(color: kOrange),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: _addIngredient,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: kOrange,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.add,
                                  color: kWhite, size: 22),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      if (_ingredients.isNotEmpty)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _ingredients
                              .map((ing) => _IngredientChip(
                                    label:    ing,
                                    onDelete: () =>
                                        _removeIngredient(ing),
                                  ))
                              .toList(),
                        ),

                      const SizedBox(height: 24),

                      if (!isLoaded && !isConsuming && !isConsumed)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isGenerating
                                ? null
                                : () {
                                    context
                                        .read<AIRecommendationBloc>()
                                        .add(GenerateRecommendation(
                                          availableIngredients:
                                              _ingredients,
                                          overrideMealType:
                                              _selectedMealType,
                                        ));
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kOrange,
                              foregroundColor: kWhite,
                              disabledBackgroundColor:
                                  kOrange.withOpacity(0.6),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 0,
                            ),
                            child: isGenerating
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                        color: kWhite, strokeWidth: 2),
                                  )
                                : const Text('Generar comida con IA'),
                          ),
                        ),

                      if (isLoaded)
                        RecommendationResultCard(
                          recommendation: (state as AIRecommendationLoaded)
                              .recommendation,
                          onConsume: () {
                            context.read<AIRecommendationBloc>().add(
                                  ConsumeRecommendation(
                                      state.recommendation),
                                );
                          },
                          onRegenerate: () {
                            context
                                .read<AIRecommendationBloc>()
                                .add(GenerateRecommendation(
                                  availableIngredients: _ingredients,
                                  overrideMealType: _selectedMealType,
                                ));
                          },
                        ),

                      if (isConsuming)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: Column(
                              children: [
                                CircularProgressIndicator(color: kOrange),
                                SizedBox(height: 12),
                                Text('Guardando comida...',
                                    style: TextStyle(color: kGrey)),
                              ],
                            ),
                          ),
                        ),

                      if (isConsumed) ...[
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.check_circle,
                                  color: Color(0xFF4CAF50), size: 28),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '¡Comida registrada!',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Color(0xFF1B5E20)),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Tu dashboard se actualizó. La próxima recomendación sugerirá el siguiente slot.',
                                      style: TextStyle(
                                          color: Color(0xFF388E3C),
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: kOrange,
                              side: const BorderSide(color: kOrange),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Cerrar'),
                          ),
                        ),
                      ],

                      if (state is AIRecommendationError)
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEBEE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline,
                                  color: Colors.red),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Error: ${state.message}',
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 14, color: kDark),
    );
  }

  Widget _ctxMacro(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: kDark)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(color: kGrey, fontSize: 11)),
      ],
    );
  }
}

class _MealTypeSelector extends StatelessWidget {
  final String suggested;
  final String? selected;
  final ValueChanged<String?> onChanged;

  const _MealTypeSelector({
    required this.suggested,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final options = [
      ('breakfast', 'Desayuno'),
      ('lunch',     'Almuerzo'),
      ('dinner',    'Cena'),
      ('snack',     'Merienda'),
    ];

    return Wrap(
      spacing: 8,
      children: options.map((opt) {
        final (value, label) = opt;
        final isSelected = (selected ?? suggested) == value;

        return GestureDetector(
          onTap: () => onChanged(value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? kOrange : kLightGrey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? kWhite : kDark,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _IngredientChip extends StatelessWidget {
  final String label;
  final VoidCallback onDelete;

  const _IngredientChip({required this.label, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: kOrangeBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kOrange.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: const TextStyle(
                  color: kOrange,
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(Icons.close, size: 14, color: kOrange),
          ),
        ],
      ),
    );
  }
}