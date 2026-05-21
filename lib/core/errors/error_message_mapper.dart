import 'dart:io';

String mapErrorToFriendlyMessage(Object error) {
  final raw = error.toString().toLowerCase();

  // ── Sin internet ────────────────────────────────────────────
  if (error is SocketException ||
      raw.contains('socketexception') ||
      raw.contains('failed host lookup') ||
      raw.contains('network is unreachable')) {
    return 'Sin conexión a internet. Revisa tu red e inténtalo de nuevo.';
  }

  // ── Timeout ─────────────────────────────────────────────────
  if (raw.contains('timeout') || raw.contains('timed out')) {
    return 'La solicitud tardó demasiado. Verifica tu conexión e inténtalo de nuevo.';
  }

  // ── Webhook / n8n apagado o caído ────────────────────────────
  if (raw.contains('webhook_unavailable')) {
    return 'El servicio de IA no está disponible en este momento. Inténtalo más tarde.';
  }

  // ── n8n devolvió error HTTP ──────────────────────────────────
  if (raw.contains('webhook_http_')) {
    if (raw.contains('webhook_http_502') ||
        raw.contains('webhook_http_503') ||
        raw.contains('webhook_http_504')) {
      return 'El servidor de análisis está saturado. Espera unos segundos e inténtalo de nuevo.';
    }
    if (raw.contains('webhook_http_500')) {
      return 'Ocurrió un error interno en el servidor de IA. Inténtalo de nuevo.';
    }
    return 'El servicio de IA respondió con un error inesperado. Inténtalo más tarde.';
  }

  // ── Respuesta con formato inesperado ─────────────────────────
  if (raw.contains('webhook_bad_format') ||
      raw.contains('formatexception') ||
      raw.contains('is not a subtype') ||
      raw.contains('jsonunsupported')) {
    return 'La IA devolvió una respuesta inesperada. Inténtalo de nuevo.';
  }

  // ── Gemini / IA no pudo analizar ────────────────────────────
  if (raw.contains('ai_unreadable')) {
    return 'No se pudo identificar la comida en la imagen. Intenta con una foto más clara y bien iluminada.';
  }

  // ── Supabase / base de datos ─────────────────────────────────
  if (raw.contains('supabase') ||
      raw.contains('postgrest') ||
      raw.contains('relation') ||
      raw.contains('violates')) {
    return 'Error al guardar los datos. Inténtalo de nuevo.';
  }

  // ── Sesión expirada ──────────────────────────────────────────
  if (raw.contains('401') || raw.contains('unauthorized') || raw.contains('jwt')) {
    return 'Tu sesión ha expirado. Por favor, inicia sesión de nuevo.';
  }

  // ── Fallback genérico ────────────────────────────────────────
  return 'Algo salió mal. Inténtalo de nuevo.';
}