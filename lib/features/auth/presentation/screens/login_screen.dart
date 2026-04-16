import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_input.dart';
import '../../../../core/widgets/app_label.dart';
import '../../../../core/widgets/dumbbell_icon.dart';
import '../../../../app/main_shell.dart';
import 'register_step1_screen.dart';
 
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
 
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
 
class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl  = TextEditingController();
  bool _obscure    = true;
  bool _loading    = false;
 
  Future<void> _login() async {
    setState(() => _loading = true);
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text.trim(),
      );
      if (mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const MainShell()));
      }
    } catch (e) {
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
    return Scaffold(
      backgroundColor: kWhite,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: kOrange,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 40, bottom: 32),
            child: const Column(
              children: [
                DumbbellIcon(size: 64, color: kWhite),
                SizedBox(height: 20),
                Text('¡Bienvenido/a de nuevo!',
                    style: TextStyle(
                        color: kWhite,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
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
                    hint: '••••••••',
                    obscure: _obscure,
                    suffix: IconButton(
                      icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                          color: kGrey),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('¿Olvidaste tu contraseña?',
                          style: TextStyle(color: kOrange)),
                    ),
                  ),
                  _loading
                      ? const Center(child: CircularProgressIndicator(color: kOrange))
                      : AppButton(label: 'Iniciar Sesión', onTap: _login),
                  const SizedBox(height: 24),
                  const Row(
                    children: [
                      Expanded(child: Divider(color: kLightGrey, thickness: 1.5)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('o continúa con',
                            style: TextStyle(color: kGrey, fontSize: 13)),
                      ),
                      Expanded(child: Divider(color: kLightGrey, thickness: 1.5)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                          color: kLightGrey,
                          borderRadius: BorderRadius.circular(14)),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('G',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: kDark)),
                          SizedBox(width: 12),
                          Text('Continuar con Google',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: kDark)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('¿No tienes cuenta? ',
                            style: TextStyle(color: kDark)),
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RegisterStep1Screen())),
                          child: const Text('Regístrate',
                              style: TextStyle(
                                  color: kOrange,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}