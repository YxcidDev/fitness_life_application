import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../widgets/settings_item.dart';
import '../widgets/settings_section.dart';
import '../../../auth/presentation/screens/login_screen.dart';
 
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
 
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
 
class _ProfileScreenState extends State<ProfileScreen> {
  late final GetProfileUseCase _useCase;
  Profile? _profile;
  bool _loading = true;
 
  @override
  void initState() {
    super.initState();
    _useCase = GetProfileUseCase(
        ProfileRepositoryImpl(ProfileRemoteDataSource()));
    _load();
  }
 
  Future<void> _load() async {
    try {
      final profile = await _useCase.execute();
      if (mounted) setState(() { _profile = profile; _loading = false; });
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }
 
  Future<void> _signOut() async {
    await ProfileRemoteDataSource().signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    }
  }
 
  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: kOrange)),
      );
    }
 
    final p = _profile;
    final initial = p?.fullName.isNotEmpty == true ? p!.fullName[0].toUpperCase() : 'U';
 
    return Column(
      children: [
        Container(
          width: double.infinity,
          color: kOrange,
          height: 120 + MediaQuery.of(context).padding.top,
        ),
        Expanded(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 100),
                child: Column(
                  children: [
                    SettingsSection(
                      label: 'Salud',
                      items: [
                        SettingsItem(
                          icon: Icons.fitness_center,
                          title: 'Datos corporales',
                          subtitle: p != null
                              ? '${p.weightKg.toStringAsFixed(0)} kg · ${p.heightCm.toStringAsFixed(0)} cm · ${p.age} años'
                              : 'Cargando...',
                        ),
                        SettingsItem(
                          icon: Icons.track_changes_rounded,
                          title: 'Metas diarias',
                          subtitle: p != null
                              ? '${p.caloriesGoal.toStringAsFixed(0)} kcal · ${p.proteinsGoal.toStringAsFixed(0)}g proteína'
                              : 'Cargando...',
                        ),
                        SettingsItem(
                          icon: Icons.local_fire_department_outlined,
                          title: 'Objetivo',
                          subtitle: p?.goal ?? 'Cargando...',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SettingsSection(
                      label: 'Preferencias',
                      items: const [
                        SettingsItem(
                          icon: Icons.notifications_none_rounded,
                          title: 'Notificaciones',
                          subtitle: 'Recordatorios de comidas',
                        ),
                        SettingsItem(
                          icon: Icons.translate_rounded,
                          title: 'Idioma',
                          subtitle: 'Español',
                        ),
                        SettingsItem(
                          icon: Icons.dark_mode_outlined,
                          title: 'Modo oscuro',
                          subtitle: 'Desactivado',
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SettingsSection(
                      label: 'Cuenta',
                      items: [
                        SettingsItem(
                          icon: Icons.email_outlined,
                          title: p?.email ?? 'Cargando...',
                          subtitle: 'Correo verificado',
                        ),
                        SettingsItem(
                          icon: Icons.logout_rounded,
                          title: 'Cerrar sesión',
                          onTap: _signOut,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0, left: 0, right: 0,
                child: Center(
                  child: Transform.translate(
                    offset: const Offset(0, -30),
                    child: Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 12)
                        ],
                      ),
                      child: Center(
                        child: Text(initial,
                            style: const TextStyle(
                                color: kOrange,
                                fontSize: 40,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}