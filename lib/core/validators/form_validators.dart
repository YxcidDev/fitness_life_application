class FormValidators {
  FormValidators._();

  static String? validateName(String value) {
    final v = value.trim();
    if (v.isEmpty) return 'El nombre es obligatorio';
    if (v.length < 2) return 'Mínimo 2 caracteres';
    if (v.length > 50) return 'Máximo 50 caracteres';
    if (RegExp(r'[0-9]').hasMatch(v)) return 'El nombre no puede contener números';
    if (!RegExp(r"^[a-zA-ZÀ-ÿ\u00f1\u00d1\s''-]+$").hasMatch(v)) {
      return 'Solo se permiten letras y espacios';
    }
    return null;
  }

  static String? validateEmail(String value) {
    final v = value.trim();
    if (v.isEmpty) return 'El correo es obligatorio';
    if (!RegExp(r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$')
        .hasMatch(v)) {
      return 'Ingresa un correo válido (ej. tu@email.com)';
    }
    return null;
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) return 'La contraseña es obligatoria';
    if (value.length < 8) return 'Mínimo 8 caracteres';
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Debe contener al menos una mayúscula';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Debe contener al menos un número';
    }
    return null;
  }

  static String? validateConfirmPassword(String password, String confirm) {
    if (confirm.isEmpty) return 'Confirma tu contraseña';
    if (password != confirm) return 'Las contraseñas no coinciden';
    return null;
  }
}