import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../data/datasources/meal_remote_datasource.dart';
import '../../data/repositories/meal_repository_impl.dart';
import '../../domain/usecases/analyze_meal_usecase.dart';
import '../../domain/usecases/save_meal_usecase.dart';
import '../bloc/meal_analysis_bloc.dart';
import '../bloc/meal_analysis_event.dart';
import '../bloc/meal_analysis_state.dart';
import 'result_screen.dart';

class AnalyzeScreen extends StatelessWidget {
  const AnalyzeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataSource = MealRemoteDataSource();
    final repo = MealRepositoryImpl(dataSource);
    return BlocProvider(
      create: (_) => MealAnalysisBloc(
        analyzeUseCase: AnalyzeMealUseCase(repo),
        saveUseCase: SaveMealUseCase(repo),
      ),
      child: const _AnalyzeBody(),
    );
  }
}

class _AnalyzeBody extends StatefulWidget {
  const _AnalyzeBody();

  @override
  State<_AnalyzeBody> createState() => _AnalyzeBodyState();
}

class _AnalyzeBodyState extends State<_AnalyzeBody> {
  File? _lastImage;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 85);
    if (picked == null) return;
    _lastImage = File(picked.path);
    if (mounted) {
      context.read<MealAnalysisBloc>().add(AnalyzeImageEvent(_lastImage!));
    }
  }

  void _retry() {
    if (_lastImage != null) {
      context.read<MealAnalysisBloc>().add(AnalyzeImageEvent(_lastImage!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MealAnalysisBloc, MealAnalysisState>(
      listener: (ctx, state) {
        if (state is MealAnalysisSuccess) {
          Navigator.push(
            ctx,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: ctx.read<MealAnalysisBloc>(),
                child: const ResultScreen(),
              ),
            ),
          );
        }
      },
      child: SafeArea(
        child: Stack(
          children: [
            // ── Contenido base siempre visible ──────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 16, 20, 4),
                  child: Text(
                    'Analizar plato',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kDark,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: Text(
                    'Toma o sube una foto de tu comida',
                    style: TextStyle(color: kGrey, fontSize: 14),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: kOrange,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: kWhite,
                              size: 40,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Foto del plato',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: kDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Asegúrate que el plato sea visible y bien iluminado',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: kGrey, fontSize: 13),
                          ),
                          const SizedBox(height: 28),
                          AppButton(
                            label: 'Seleccionar imagen',
                            onTap: () => _pickImage(ImageSource.gallery),
                          ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: () => _pickImage(ImageSource.camera),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: kLightGrey,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Center(
                                child: Text(
                                  'Tomar foto con cámara',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: kDark,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Overlay de carga / error encima de todo ─────────────────
            BlocBuilder<MealAnalysisBloc, MealAnalysisState>(
              builder: (ctx, state) {
                if (state is MealAnalysisLoading) {
                  return _FullOverlay(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        CircularProgressIndicator(color: kOrange),
                        SizedBox(height: 16),
                        Text(
                          'Analizando tu plato...',
                          style: TextStyle(
                            color: kWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state is MealAnalysisError) {
                  return _FullOverlay(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 56,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: kDark, fontSize: 14),
                          ),
                          const SizedBox(height: 20),
                          AppButton(label: 'Reintentar', onTap: _retry),
                        ],
                      ),
                    ),
                  );
                }

                return const SizedBox.shrink(); // sin overlay en estado idle
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Fondo oscuro semitransparente que cubre toda la pantalla
class _FullOverlay extends StatelessWidget {
  final Widget child;

  const _FullOverlay({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.55),
      child: Center(child: child),
    );
  }
}
