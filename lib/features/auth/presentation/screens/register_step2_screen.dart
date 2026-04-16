import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_input.dart';
import '../../../../core/widgets/app_label.dart';
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
  bool _isMale = true;
  bool _isKg   = true;
  bool _isCm   = true;
  final _ageCtrl    = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
 
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
          const SizedBox(height: 16),
          const AppLabel('Edad'),
          const SizedBox(height: 8),
          AppInput(
              controller: _ageCtrl,
              hint: 'Ej: 21',
              keyboardType: TextInputType.number),
          const SizedBox(height: 16),
          const AppLabel('Peso actual'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: AppInput(
                    controller: _weightCtrl,
                    hint: 'Ej: 70',
                    keyboardType: TextInputType.number),
              ),
              const SizedBox(width: 8),
              _UnitToggle(
                  left: 'kg',
                  right: 'lb',
                  isLeft: _isKg,
                  onToggle: (v) => setState(() => _isKg = v)),
            ],
          ),
          const SizedBox(height: 16),
          const AppLabel('Altura'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: AppInput(
                    controller: _heightCtrl,
                    hint: 'Ej: 182',
                    keyboardType: TextInputType.number),
              ),
              const SizedBox(width: 8),
              _UnitToggle(
                  left: 'cm',
                  right: 'ft',
                  isLeft: _isCm,
                  onToggle: (v) => setState(() => _isCm = v)),
            ],
          ),
          const SizedBox(height: 24),
          AppButton(
            label: 'Continuar',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RegisterStep3Screen(
                    email:    widget.email,
                    password: widget.password,
                    fullName: widget.fullName,
                    sex:      _isMale ? 'male' : 'female',
                    age:      int.tryParse(_ageCtrl.text) ?? 0,
                    weightKg: double.tryParse(_weightCtrl.text) ?? 0,
                    heightCm: double.tryParse(_heightCtrl.text) ?? 0,
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
                          color: kOrange, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
 
class _GenderCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
 
  const _GenderCard({required this.label, required this.icon, required this.isSelected, required this.onTap});
 
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
 
  const _UnitToggle({required this.left, required this.right, required this.isLeft, required this.onToggle});
 
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
        child: Text(label,
            style: TextStyle(
                color: active ? kWhite : kGrey,
                fontWeight: FontWeight.w600,
                fontSize: 13)),
      ),
    );
  }
}