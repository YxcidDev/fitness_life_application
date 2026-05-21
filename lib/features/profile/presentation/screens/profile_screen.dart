import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/number_picker_sheet.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/profile.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../widgets/settings_item.dart';
import '../widgets/settings_section.dart';
import '../../../auth/presentation/screens/login_screen.dart';
import '../../../auth/data/datasources/device_token_datasource.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final GetProfileUseCase _getUseCase;
  late final UpdateProfileUseCase _updateUseCase;
  Profile? _profile;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final remoteDataSource = ProfileRemoteDataSource();
    final repository = ProfileRepositoryImpl(remoteDataSource);
    _getUseCase = GetProfileUseCase(repository);
    _updateUseCase = UpdateProfileUseCase(repository);
    _load();
  }

  Future<void> _load() async {
    try {
      final profile = await _getUseCase.execute();
      if (mounted) setState(() { _profile = profile; _loading = false; });
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _signOut() async {
    await DeviceTokenDataSource().deactivateDeviceToken();
    await ProfileRemoteDataSource().signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (_) => false,
      );
    }
  }

  void _editBodyData() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BodyDataSheet(
        profile: _profile!,
        onSave: (weight, height, age, sex) async {
          final draft = _profile!.copyWith(
            weightKg: weight,
            heightCm: height,
            age: age,
            sex: sex,
          );
          final updated = await _updateUseCase.execute(draft);
          if (mounted) {
            setState(() => _profile = updated);
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  void _editGoal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _GoalSheet(
        currentGoal: _profile!.goal,
        onSelect: (goalKey) async {
          Navigator.pop(context);
          final draft = _profile!.copyWith(goal: goalKey);
          final updated = await _updateUseCase.execute(draft);
          if (mounted) setState(() => _profile = updated);
        },
      ),
    );
  }

  String _goalLabel(String goal) => switch (goal) {
    'lose_weight'         => 'Perder peso',
    'gain_muscle'         => 'Ganar músculo',
    'maintain'            => 'Mantener',
    'improve_performance' => 'Mejorar rendimiento',
    _                     => goal,
  };

  String _sexLabel(String sex) => sex == 'male' ? 'Masculino' : 'Femenino';

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: kOrange)),
      );
    }

    final p = _profile;
    final initial =
        p?.fullName.isNotEmpty == true ? p!.fullName[0].toUpperCase() : 'U';

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
                              ? '${p.weightKg.toStringAsFixed(0)} kg · '
                                '${p.heightCm.toStringAsFixed(0)} cm · '
                                '${p.age} años · '
                                '${_sexLabel(p.sex)}'
                              : 'Cargando...',
                          onTap: p != null ? _editBodyData : null,
                        ),
                        SettingsItem(
                          icon: Icons.local_fire_department_outlined,
                          title: 'Objetivo',
                          subtitle: p != null
                              ? '${_goalLabel(p.goal)} · '
                                '${p.caloriesGoal.toStringAsFixed(0)} kcal · '
                                '${p.proteinsGoal.toStringAsFixed(0)} g proteína'
                              : 'Cargando...',
                          onTap: p != null ? _editGoal : null,
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
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          initial,
                          style: const TextStyle(
                            color: kOrange,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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

class _BodyDataSheet extends StatefulWidget {
  final Profile profile;
  final Future<void> Function(
    double weight,
    double height,
    int age,
    String sex,
  ) onSave;

  const _BodyDataSheet({required this.profile, required this.onSave});

  @override
  State<_BodyDataSheet> createState() => _BodyDataSheetState();
}

class _BodyDataSheetState extends State<_BodyDataSheet> {
  late String _sex;
  late bool _isKg;
  late bool _isCm;
  late double _selectedWeight;
  late double _selectedHeight;
  late int    _selectedAge;
  late String _weightLabel;
  late String _heightLabel;
  late String _ageLabel;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _sex            = p.sex;
    _isKg           = true;
    _isCm           = true;
    _selectedWeight = p.weightKg;
    _selectedHeight = p.heightCm;
    _selectedAge    = p.age;
    _weightLabel    = '${p.weightKg.toStringAsFixed(0)}  kg';
    _heightLabel    = '${p.heightCm.toStringAsFixed(0)}  cm';
    _ageLabel       = '${p.age}  años';
  }

  Future<void> _pickAge() async {
    final items = ageItems();
    final initIndex =
        items.indexWhere((e) => e.numericValue == _selectedAge.toDouble());
    final picked = await showNumberPickerSheet(
      context: context,
      title: 'Edad',
      values: items,
      initialIndex: initIndex < 0 ? 0 : initIndex,
    );
    if (picked != null) {
      setState(() {
        _selectedAge = picked.numericValue.toInt();
        _ageLabel    = picked.label;
      });
    }
  }

  Future<void> _pickWeight() async {
    final items     = _isKg ? weightKgItems() : weightLbItems();
    final initIndex = _closestIndex(items, _selectedWeight);
    final picked = await showNumberPickerSheet(
      context: context,
      title: 'Peso',
      values: items,
      initialIndex: initIndex,
    );
    if (picked != null) {
      setState(() {
        _selectedWeight = picked.numericValue;
        _weightLabel    = picked.label;
      });
    }
  }

  Future<void> _pickHeight() async {
    final items     = _isCm ? heightCmItems() : heightFtItems();
    final initIndex = _closestIndex(items, _selectedHeight);
    final picked = await showNumberPickerSheet(
      context: context,
      title: 'Altura',
      values: items,
      initialIndex: initIndex,
    );
    if (picked != null) {
      setState(() {
        _selectedHeight = picked.numericValue;
        _heightLabel    = picked.label;
      });
    }
  }

  int _closestIndex(List<PickerItem> items, double target) {
    if (items.isEmpty) return 0;
    int idx = 0;
    double minDiff = double.infinity;
    for (int i = 0; i < items.length; i++) {
      final diff = (items[i].numericValue - target).abs();
      if (diff < minDiff) { minDiff = diff; idx = i; }
    }
    return idx;
  }

  void _onWeightUnitChanged(bool isKg) {
    setState(() {
      _isKg        = isKg;
      _selectedWeight = 0;
      _weightLabel = 'Seleccionar peso';
    });
  }

  void _onHeightUnitChanged(bool isCm) {
    setState(() {
      _isCm           = isCm;
      _selectedHeight = 0;
      _heightLabel    = 'Seleccionar altura';
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    await widget.onSave(
      _selectedWeight > 0 ? _selectedWeight : widget.profile.weightKg,
      _selectedHeight > 0 ? _selectedHeight : widget.profile.heightCm,
      _selectedAge    > 0 ? _selectedAge    : widget.profile.age,
      _sex,
    );
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: kLightGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Datos corporales',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: kDark),
          ),
          const SizedBox(height: 20),

          const _SectionLabel('Género'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _GenderCard(
                  label: 'Masculino',
                  icon: Icons.man,
                  isSelected: _sex == 'male',
                  onTap: () => setState(() => _sex = 'male'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _GenderCard(
                  label: 'Femenino',
                  icon: Icons.woman,
                  isSelected: _sex == 'female',
                  onTap: () => setState(() => _sex = 'female'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          const _SectionLabel('Edad'),
          const SizedBox(height: 8),
          _PickerField(
            label: _ageLabel,
            hasValue: _selectedAge > 0,
            onTap: _pickAge,
          ),
          const SizedBox(height: 16),

          const _SectionLabel('Peso'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _PickerField(
                  label: _weightLabel,
                  hasValue: _selectedWeight > 0,
                  onTap: _pickWeight,
                ),
              ),
              const SizedBox(width: 8),
              _UnitToggle(
                left: 'kg',
                right: 'lb',
                isLeft: _isKg,
                onToggle: _onWeightUnitChanged,
              ),
            ],
          ),
          const SizedBox(height: 16),

          const _SectionLabel('Altura'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _PickerField(
                  label: _heightLabel,
                  hasValue: _selectedHeight > 0,
                  onTap: _pickHeight,
                ),
              ),
              const SizedBox(width: 8),
              _UnitToggle(
                left: 'cm',
                right: 'ft',
                isLeft: _isCm,
                onToggle: _onHeightUnitChanged,
              ),
            ],
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: kOrange,
                foregroundColor: kWhite,
                disabledBackgroundColor: kOrange.withOpacity(0.6),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _saving
                  ? const SizedBox(
                      height: 20, width: 20,
                      child: CircularProgressIndicator(
                          color: kWhite, strokeWidth: 2),
                    )
                  : const Text(
                      'Guardar',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalSheet extends StatefulWidget {
  final String currentGoal;
  final Future<void> Function(String goalKey) onSelect;

  const _GoalSheet({required this.currentGoal, required this.onSelect});

  @override
  State<_GoalSheet> createState() => _GoalSheetState();
}

class _GoalSheetState extends State<_GoalSheet> {
  late String _selected;

  static const _goals = [
    (Icons.local_fire_department, 'Perder peso',          'Déficit calórico personalizado',    'lose_weight'),
    (Icons.balance,               'Mantener peso',         'Balance calórico equilibrado',       'maintain'),
    (Icons.fitness_center,        'Ganar músculo',         'Superávit calórico + proteína alta', 'gain_muscle'),
    (Icons.bolt,                  'Mejorar rendimiento',   'Macros para atletas activos',        'improve_performance'),
  ];

  @override
  void initState() {
    super.initState();
    _selected = widget.currentGoal;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: kLightGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            '¿Cuál es tu objetivo?',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: kDark),
          ),
          const SizedBox(height: 16),

          ...List.generate(_goals.length, (i) {
            final (icon, title, subtitle, key) = _goals[i];
            final sel = _selected == key;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GestureDetector(
                onTap: () => setState(() => _selected = key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: sel ? kOrangeBg : kLightGrey,
                    border: Border.all(
                      color: sel ? kOrange : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          color: sel ? kOrange : kDark,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(icon, color: kWhite, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: kDark)),
                            const SizedBox(height: 2),
                            Text(subtitle,
                                style: const TextStyle(
                                    color: kGrey, fontSize: 12)),
                          ],
                        ),
                      ),
                      if (sel)
                        const Icon(Icons.check_circle,
                            color: kOrange, size: 20),
                    ],
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => widget.onSelect(_selected),
              style: ElevatedButton.styleFrom(
                backgroundColor: kOrange,
                foregroundColor: kWhite,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Guardar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontWeight: FontWeight.w600, fontSize: 13, color: kDark),
    );
  }
}

class _PickerField extends StatelessWidget {
  final String label;
  final bool hasValue;
  final VoidCallback onTap;

  const _PickerField({
    required this.label,
    required this.hasValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: kLightGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  color: hasValue ? kDark : kGrey,
                  fontWeight:
                      hasValue ? FontWeight.w500 : FontWeight.normal,
                ),
              ),
            ),
            const Icon(Icons.expand_more_rounded, color: kGrey, size: 22),
          ],
        ),
      ),
    );
  }
}

class _GenderCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderCard({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? kOrangeBg : kLightGrey,
          border: Border.all(
            color: isSelected ? kOrange : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, size: 40, color: isSelected ? kOrange : kDark),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? kOrange : kDark,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnitToggle extends StatelessWidget {
  final String left;
  final String right;
  final bool isLeft;
  final Function(bool) onToggle;

  const _UnitToggle({
    required this.left,
    required this.right,
    required this.isLeft,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: kLightGrey, borderRadius: BorderRadius.circular(30)),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _btn(left, isLeft, () => onToggle(true)),
          _btn(right, !isLeft, () => onToggle(false)),
        ],
      ),
    );
  }

  Widget _btn(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: active ? kOrange : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? kWhite : kGrey,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}