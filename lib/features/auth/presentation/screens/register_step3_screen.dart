import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../app/main_shell.dart';
import '../widgets/register_scaffold.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/models/user_profile_model.dart';
import '../../domain/entities/user_profile.dart';
 
class RegisterStep3Screen extends StatefulWidget {
  final String email;
  final String password;
  final String fullName;
  final String sex;
  final int age;
  final double weightKg;
  final double heightCm;
 
  const RegisterStep3Screen({
    super.key,
    required this.email,
    required this.password,
    required this.fullName,
    required this.sex,
    required this.age,
    required this.weightKg,
    required this.heightCm,
  });
 
  @override
  State<RegisterStep3Screen> createState() => _RegisterStep3ScreenState();
}
 
class _RegisterStep3ScreenState extends State<RegisterStep3Screen> {
  int _selected = 0;
  bool _loading = false;
 
  final _goals = const [
    (Icons.local_fire_department, 'Perder Grasa',       'Déficit calórico personalizado',    'lose_weight'),
    (Icons.balance,               'Mantener peso',       'Balance calórico equilibrado',       'maintain'),
    (Icons.fitness_center,        'Ganar músculo',       'Superávit calórico + proteína alta', 'gain_muscle'),
    (Icons.bolt,                  'Mejorar rendimiento', 'Macros para atletas activos',        'improve_performance'),
  ];
 
  Future<void> _finish() async {
  setState(() => _loading = true);
  try {
    final dataSource = AuthRemoteDataSource();

    print('>>> 1. Iniciando signUp...');
    final userId = await dataSource.signUp(widget.email, widget.password);
    print('>>> 2. userId obtenido: $userId');

    print('>>> 3. Iniciando signIn...');
    await dataSource.signIn(widget.email, widget.password);
    print('>>> 4. signIn exitoso');

    final goalString = _goals[_selected].$4;
    final goal = switch (goalString) {
      'lose_weight'         => FitnessGoal.loseWeight,
      'gain_muscle'         => FitnessGoal.gainMuscle,
      'improve_performance' => FitnessGoal.improvePerformance,
      _                     => FitnessGoal.maintain,
    };

    print('>>> 5. Guardando perfil...');
    await dataSource.saveProfile(UserProfileModel(
      id:       userId,
      fullName: widget.fullName,
      email:    widget.email,
      sex:      widget.sex,
      age:      widget.age,
      weightKg: widget.weightKg,
      heightCm: widget.heightCm,
      goal:     goal,
    ));
    print('>>> 6. Perfil guardado correctamente');

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainShell()),
        (_) => false,
      );
    }
  } catch (e, stack) {
    print('>>> ERROR: $e');
    print('>>> STACK: $stack');
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  } finally {
    if (mounted) setState(() => _loading = false);
  }
}
 
  @override
  Widget build(BuildContext context) {
    return RegisterScaffold(
      step: 3,
      title: '¿Cuál es tu objetivo?',
      subtitle: 'Personalizaremos tu experiencia para ti',
      child: Column(
        children: [
          ...List.generate(_goals.length, (i) {
            final (icon, title, subtitle, _) = _goals[i];
            final sel = _selected == i;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () => setState(() => _selected = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: sel ? kOrangeBg : kLightGrey,
                    border: Border.all(
                        color: sel ? kOrange : Colors.transparent, width: 2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(
                          color: sel ? kOrange : kDark,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: kWhite, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: kDark)),
                            const SizedBox(height: 2),
                            Text(subtitle,
                                style: const TextStyle(
                                    color: kGrey, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 12),
          _loading
              ? const Center(child: CircularProgressIndicator(color: kOrange))
              : AppButton(label: 'Continuar', onTap: _finish),
        ],
      ),
    );
  }
}