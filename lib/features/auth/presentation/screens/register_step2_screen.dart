import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_label.dart';
import '../../../../core/widgets/number_picker_sheet.dart';
import '../widgets/register_scaffold.dart';
import 'register_step3_screen.dart';

class RegisterStep2Screen extends StatefulWidget {
  final String email;
  final String password;
  final String fullName;

  const RegisterStep2Screen({
    super.key,
    required this.email,
    required this.password,
    required this.fullName,
  });

  @override
  State<RegisterStep2Screen> createState() => _RegisterStep2ScreenState();
}

class _RegisterStep2ScreenState extends State<RegisterStep2Screen> {
  bool _isMale   = true;
  bool _isKg     = true;
  bool _isCm     = true;

  int    _selectedAge    = 21;
  double _selectedWeight = 70;
  double _selectedHeight = 175;

  String _ageLabel    = '21  años';
  String _weightLabel = '70  kg';
  String _heightLabel = '175  cm';

  String? _ageError;
  String? _weightError;
  String? _heightError;

  bool _validateAll() {
    String? ageErr    = _selectedAge == 0    ? 'Selecciona tu edad'    : null;
    String? weightErr = _selectedWeight == 0 ? 'Selecciona tu peso'    : null;
    String? heightErr = _selectedHeight == 0 ? 'Selecciona tu altura'  : null;
    setState(() {
      _ageError    = ageErr;
      _weightError = weightErr;
      _heightError = heightErr;
    });
    return ageErr == null && weightErr == null && heightErr == null;
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
        _ageError    = null;
      });
    }
  }

  Future<void> _pickWeight() async {
    final items = _isKg ? weightKgItems() : weightLbItems();
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
        _weightError    = null;
      });
    }
  }

  Future<void> _pickHeight() async {
    final items = _isCm ? heightCmItems() : heightFtItems();
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
        _heightError    = null;
      });
    }
  }

  int _closestIndex(List<PickerItem> items, double target) {
    if (items.isEmpty) return 0;
    int idx = 0;
    double minDiff = double.infinity;
    for (int i = 0; i < items.length; i++) {
      final diff = (items[i].numericValue - target).abs();
      if (diff < minDiff) {
        minDiff = diff;
        idx = i;
      }
    }
    return idx;
  }


  void _onWeightUnitChanged(bool isKg) {
    setState(() {
      _isKg        = isKg;
      _selectedWeight = 0;
      _weightLabel = isKg ? 'Seleccionar peso' : 'Seleccionar peso';
    });
  }

  void _onHeightUnitChanged(bool isCm) {
    setState(() {
      _isCm          = isCm;
      _selectedHeight = 0;
      _heightLabel    = isCm ? 'Seleccionar altura' : 'Seleccionar altura';
    });
  }

  @override
  Widget build(BuildContext context) {
    return RegisterScaffold(
      step: 2,
      title: 'Cuéntanos de ti',
      subtitle: 'Personalizaremos tu plan nutricional',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppLabel('Género'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _GenderCard(
                  label: 'Masculino',
                  icon: Icons.man,
                  isSelected: _isMale,
                  onTap: () => setState(() => _isMale = true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _GenderCard(
                  label: 'Femenino',
                  icon: Icons.woman,
                  isSelected: !_isMale,
                  onTap: () => setState(() => _isMale = false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          const AppLabel('Edad'),
          const SizedBox(height: 8),
          _PickerField(
            label: _ageLabel,
            hasValue: _selectedAge > 0,
            onTap: _pickAge,
          ),
          _FieldError(_ageError),
          const SizedBox(height: 16),

          const AppLabel('Peso actual'),
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
          _FieldError(_weightError),
          const SizedBox(height: 16),

          const AppLabel('Altura'),
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
          _FieldError(_heightError),
          const SizedBox(height: 24),

          AppButton(
            label: 'Continuar',
            onTap: () {
              if (!_validateAll()) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RegisterStep3Screen(
                    email:    widget.email,
                    password: widget.password,
                    fullName: widget.fullName,
                    sex:      _isMale ? 'male' : 'female',
                    age:      _selectedAge,
                    weightKg: _selectedWeight,
                    heightCm: _selectedHeight,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('¿Ya tienes cuenta? ',
                    style: TextStyle(color: kDark)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text('Inicia sesión',
                      style: TextStyle(
                          color: kOrange,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
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
            const Icon(Icons.expand_more_rounded,
                color: kGrey, size: 22),
          ],
        ),
      ),
    );
  }
}

class _FieldError extends StatelessWidget {
  final String? message;
  const _FieldError(this.message);

  @override
  Widget build(BuildContext context) {
    if (message == null) return const SizedBox(height: 4);
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 4),
      child: Text(message!,
          style: const TextStyle(color: Colors.red, fontSize: 12)),
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
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? kOrangeBg : kLightGrey,
          border: Border.all(
              color: isSelected ? kOrange : Colors.transparent, width: 2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, size: 52, color: isSelected ? kOrange : kDark),
            const SizedBox(height: 8),
            Text(label,
                style: TextStyle(
                    color: isSelected ? kOrange : kDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 15)),
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
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: active ? kOrange : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Text(label,
            style: TextStyle(
                color: active ? kWhite : kGrey,
                fontWeight: FontWeight.w600,
                fontSize: 13)),
      ),
    );
  }
}