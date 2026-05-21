import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/validators/form_validators.dart';
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

  String? _nameError;
  String? _emailError;
  String? _passError;
  String? _confirmError;

  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _onNameChanged(String v) {
    if (_nameError != null) {
      setState(() => _nameError = FormValidators.validateName(v));
    }
  }

  void _onEmailChanged(String v) {
    if (_emailError != null) {
      setState(() => _emailError = FormValidators.validateEmail(v));
    }
  }

  void _onPassChanged(String v) {
    if (_passError != null) {
      setState(() => _passError = FormValidators.validatePassword(v));
    }
    if (_confirmError != null && _confirmCtrl.text.isNotEmpty) {
      setState(() => _confirmError = FormValidators.validateConfirmPassword(
          v, _confirmCtrl.text));
    }
  }

  void _onConfirmChanged(String v) {
    if (_confirmError != null) {
      setState(() => _confirmError =
          FormValidators.validateConfirmPassword(_passCtrl.text, v));
    }
  }

  bool _validateAll() {
    final nameErr    = FormValidators.validateName(_nameCtrl.text);
    final emailErr   = FormValidators.validateEmail(_emailCtrl.text);
    final passErr    = FormValidators.validatePassword(_passCtrl.text);
    final confirmErr = FormValidators.validateConfirmPassword(
        _passCtrl.text, _confirmCtrl.text);

    setState(() {
      _nameError    = nameErr;
      _emailError   = emailErr;
      _passError    = passErr;
      _confirmError = confirmErr;
    });

    return nameErr == null &&
        emailErr == null &&
        passErr == null &&
        confirmErr == null;
  }

  Future<void> _next() async {
    if (!_validateAll()) return;

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
          AppInput(
            controller: _nameCtrl,
            hint: 'Tu nombre',
            onChanged: _onNameChanged,
          ),
          _ErrorText(_nameError),

          const SizedBox(height: 16),

          const AppLabel('Correo electrónico'),
          const SizedBox(height: 8),
          AppInput(
            controller: _emailCtrl,
            hint: 'tu@email.com',
            keyboardType: TextInputType.emailAddress,
            onChanged: _onEmailChanged,
          ),
          _ErrorText(_emailError),

          const SizedBox(height: 16),

          const AppLabel('Contraseña'),
          const SizedBox(height: 8),
          AppInput(
            controller: _passCtrl,
            hint: 'Mínimo 8 caracteres, una mayúscula y un número',
            obscure: true,
            onChanged: _onPassChanged,
          ),
          _ErrorText(_passError),

          const SizedBox(height: 16),

          const AppLabel('Confirmar contraseña'),
          const SizedBox(height: 8),
          AppInput(
            controller: _confirmCtrl,
            hint: 'Repite tu contraseña',
            obscure: true,
            onChanged: _onConfirmChanged,
          ),
          _ErrorText(_confirmError),

          const SizedBox(height: 24),

          _loading
              ? const Center(
                  child: CircularProgressIndicator(color: kOrange))
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

class _ErrorText extends StatelessWidget {
  final String? message;
  const _ErrorText(this.message);

  @override
  Widget build(BuildContext context) {
    if (message == null) return const SizedBox(height: 4);
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 4),
      child: Text(
        message!,
        style: const TextStyle(color: Colors.red, fontSize: 12),
      ),
    );
  }
}