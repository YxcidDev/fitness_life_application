import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_input.dart';
import '../../../../core/widgets/app_label.dart';
import '../widgets/register_scaffold.dart';
import 'register_step2_screen.dart';
 
class RegisterStep1Screen extends StatefulWidget {
  const RegisterStep1Screen({super.key});
 
  @override
  State<RegisterStep1Screen> createState() => _RegisterStep1ScreenState();
}
 
class _RegisterStep1ScreenState extends State<RegisterStep1Screen> {
  final _nameCtrl    = TextEditingController();
  final _emailCtrl   = TextEditingController();
  final _passCtrl    = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _loading      = false;
 
  Future<void> _next() async {
    if (_passCtrl.text != _confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Las contraseñas no coinciden')));
      return;
    }
    setState(() => _loading = true);
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RegisterStep2Screen(
            email:    _emailCtrl.text.trim(),
            password: _passCtrl.text.trim(),
            fullName: _nameCtrl.text.trim(),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return RegisterScaffold(
      step: 1,
      title: 'Crea tu cuenta',
      subtitle: 'Únete y empieza a trackear tus macros',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppLabel('Nombre completo'),
          const SizedBox(height: 8),
          AppInput(controller: _nameCtrl, hint: 'Tu nombre'),
          const SizedBox(height: 16),
          const AppLabel('Correo electrónico'),
          const SizedBox(height: 8),
          AppInput(
              controller: _emailCtrl,
              hint: 'tu@email.com',
              keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 16),
          const AppLabel('Contraseña'),
          const SizedBox(height: 8),
          AppInput(
              controller: _passCtrl,
              hint: 'Mínimo 8 caracteres',
              obscure: true),
          const SizedBox(height: 16),
          const AppLabel('Confirmar contraseña'),
          const SizedBox(height: 8),
          AppInput(
              controller: _confirmCtrl,
              hint: 'Mínimo 8 caracteres',
              obscure: true),
          const SizedBox(height: 24),
          _loading
              ? const Center(child: CircularProgressIndicator(color: kOrange))
              : AppButton(label: 'Continuar', onTap: _next),
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