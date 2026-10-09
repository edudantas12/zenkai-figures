import 'package:flutter/foundation.dart';

/// Validação local do formulário de login.
/// A autenticação real pode ser conectada posteriormente.
class LoginController extends ChangeNotifier {
  String? validar(String email, String senha) {
    final emailNormalizado = email.trim();

    if (emailNormalizado.isEmpty || senha.isEmpty) {
      return 'Informe o e-mail e a senha.';
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
        .hasMatch(emailNormalizado)) {
      return 'Informe um e-mail válido.';
    }
    return null;
  }

  String nomePeloEmail(String email) {
    final parteLocal = email.trim().split('@').first;
    if (parteLocal.isEmpty) return 'Colecionador';
    return parteLocal
        .replaceAll(RegExp(r'[._-]+'), ' ')
        .split(' ')
        .where((parte) => parte.isNotEmpty)
        .map((parte) => '${parte[0].toUpperCase()}${parte.substring(1)}')
        .join(' ');
  }
}
