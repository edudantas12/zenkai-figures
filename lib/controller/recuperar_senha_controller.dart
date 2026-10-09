import 'package:flutter/foundation.dart';

/// Validação do e-mail usado na recuperação de senha.
class RecuperarSenhaController extends ChangeNotifier {
  bool emailValido(String email) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim());
}
